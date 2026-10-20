import '../datasources/chat_remote_datasource.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({ChatRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSourceImpl();

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
    return await _remoteDataSource.getOrCreateChat(
      listingId: listingId,
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      currentUserPhoto: currentUserPhoto,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerPhoto: ownerPhoto,
      listingTitle: listingTitle,
      listingImage: listingImage,
    );
  }

  @override
  Stream<List<ChatModel>> getUserChatsStream(String userId) {
    return _remoteDataSource.getUserChatsStream(userId);
  }

  @override
  Stream<List<MessageModel>> getChatMessagesStream(String chatId) {
    return _remoteDataSource.getChatMessagesStream(chatId);
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
    String? imageUrl,
    double? locationLat,
    double? locationLng,
    String? locationAddress,
  }) async {
    await _remoteDataSource.sendMessage(
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      recipientId: recipientId,
      isOffer: isOffer,
      offerItemTitle: offerItemTitle,
      offerItemImage: offerItemImage,
      imageUrl: imageUrl,
      locationLat: locationLat,
      locationLng: locationLng,
      locationAddress: locationAddress,
    );
  }

  @override
  Future<void> respondToOffer({
    required String chatId,
    required String messageId,
    required String newStatus,
  }) async {
    await _remoteDataSource.respondToOffer(
      chatId: chatId,
      messageId: messageId,
      newStatus: newStatus,
    );
  }

  @override
  Future<void> markAsRead(String chatId, String userId) async {
    await _remoteDataSource.markAsRead(chatId, userId);
  }
}
