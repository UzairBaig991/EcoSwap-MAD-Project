import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
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
    String? imageUrl,
    double? locationLat,
    double? locationLng,
    String? locationAddress,
  });
  Future<void> respondToOffer({
    required String chatId,
    required String messageId,
    required String newStatus,
  });
  Future<void> markAsRead(String chatId, String userId);
}
