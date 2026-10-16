import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../core/errors/exceptions.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> getOrCreateChat({
    required String listingId,
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhoto,
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
    required String listingTitle,
    String? listingImage,
  });

  Stream<List<ChatModel>> getUserChatsStream(String userId);
  Stream<List<MessageModel>> getChatMessagesStream(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
    required String recipientId,
    bool isOffer,
    String? offerItemTitle,
    String? offerItemImage,
  });
  Future<void> respondToOffer({
    required String chatId,
    required String messageId,
    required String newStatus, // Accepted, Declined
  });
  Future<void> markAsRead(String chatId, String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<ChatModel> getOrCreateChat({
    required String listingId,
    required String currentUserId,
    required String currentUserName,
    String? currentUserPhoto,
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
    required String listingTitle,
    String? listingImage,
  }) async {
    try {
      final participants = [currentUserId, ownerId]..sort();
      final chatId = '${listingId}_${participants.join('_')}';

      final doc = await _firestore.collection('chats').doc(chatId).get();
      if (doc.exists) {
        return ChatModel.fromFirestore(doc);
      }

      final newChat = ChatModel(
        id: chatId,
        listingId: listingId,
        listingTitle: listingTitle,
        listingImage: listingImage,
        participants: participants,
        participantNames: {
          currentUserId: currentUserName,
          ownerId: ownerName,
        },
        participantPhotos: {
          if (currentUserPhoto != null) currentUserId: currentUserPhoto,
          if (ownerPhoto != null) ownerId: ownerPhoto,
        },
        lastMessage: 'Conversation started',
        lastMessageSenderId: currentUserId,
        lastMessageAt: DateTime.now(),
        unreadCount: {
          currentUserId: 0,
          ownerId: 0,
        },
        createdAt: DateTime.now(),
      );

      await _firestore.collection('chats').doc(chatId).set(newChat.toFirestore());
      return newChat;
    } catch (e) {
      throw ServerException('Failed to initialize chat: ${e.toString()}');
    }
  }

  @override
  Stream<List<ChatModel>> getUserChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
      chats.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      return chats;
    });
  }

  @override
  Stream<List<MessageModel>> getChatMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc, chatId)).toList();
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
    required String recipientId,
    bool isOffer = false,
    String? offerItemTitle,
    String? offerItemImage,
  }) async {
    try {
      final messageRef = _firestore.collection('chats').doc(chatId).collection('messages').doc();

      final message = MessageModel(
        id: messageRef.id,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        text: text,
        createdAt: DateTime.now(),
        readBy: [senderId],
        isOffer: isOffer,
        offerItemTitle: offerItemTitle,
        offerItemImage: offerItemImage,
        offerStatus: isOffer ? 'Pending' : null,
      );

      await messageRef.set(message.toFirestore());

      // Update Chat last message & increment unread counter
      final lastMsgText = isOffer ? '🔄 Offered swap: "$offerItemTitle"' : text;
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': lastMsgText,
        'lastMessageSenderId': senderId,
        'lastMessageAt': Timestamp.now(),
        'unreadCount.$recipientId': FieldValue.increment(1),
      });
    } catch (e) {
      throw ServerException('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<void> respondToOffer({
    required String chatId,
    required String messageId,
    required String newStatus,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'offerStatus': newStatus,
      });

      if (newStatus == 'Accepted') {
        final chatDoc = await _firestore.collection('chats').doc(chatId).get();
        if (chatDoc.exists) {
          final listingId = chatDoc.data()?['listingId'];
          if (listingId != null) {
            await _firestore.collection('listings').doc(listingId).update({
              'status': 'Claimed',
              'updatedAt': Timestamp.now(),
            });
          }
        }
      }
    } catch (e) {
      throw ServerException('Failed to respond to offer: ${e.toString()}');
    }
  }

  @override
  Future<void> markAsRead(String chatId, String userId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'unreadCount.$userId': 0,
      });
    } catch (_) {
      // Ignored non-critical failure
    }
  }
}
