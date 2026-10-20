import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/chat_repository_impl.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/message_model.dart';
import '../../auth/providers/auth_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

final userChatsStreamProvider = StreamProvider<List<ChatModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.asData?.value?.uid;
  if (userId == null) return Stream.value([]);

  final repo = ref.watch(chatRepositoryProvider);
  return repo.getUserChatsStream(userId);
});

final chatMessagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatMessagesStream(chatId);
});

enum ChatOperationStatus { initial, loading, success, error }

class ChatOperationState {
  final ChatOperationStatus status;
  final String? errorMessage;

  const ChatOperationState({
    this.status = ChatOperationStatus.initial,
    this.errorMessage,
  });

  ChatOperationState copyWith({
    ChatOperationStatus? status,
    String? errorMessage,
  }) {
    return ChatOperationState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatOperationState>((ref) {
  return ChatController(ref.watch(chatRepositoryProvider), ref);
});

class ChatController extends StateNotifier<ChatOperationState> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatController(this._repository, this._ref) : super(const ChatOperationState());

  Future<ChatModel?> initializeChat({
    required String listingId,
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
    required String listingTitle,
    String? listingImage,
  }) async {
    state = state.copyWith(status: ChatOperationStatus.loading, errorMessage: null);

    try {
      final currentUser = await _ref.read(currentUserModelProvider.future);
      if (currentUser == null) throw Exception('User not authenticated');

      final chat = await _repository.getOrCreateChat(
        listingId: listingId,
        currentUserId: currentUser.uid,
        currentUserName: currentUser.displayName,
        currentUserPhoto: currentUser.photoUrl,
        ownerId: ownerId,
        ownerName: ownerName,
        ownerPhoto: ownerPhoto,
        listingTitle: listingTitle,
        listingImage: listingImage,
      );

      state = state.copyWith(status: ChatOperationStatus.success);
      return chat;
    } catch (e) {
      state = state.copyWith(
        status: ChatOperationStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<bool> sendMessage({
    required String chatId,
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
    try {
      final currentUser = await _ref.read(currentUserModelProvider.future);
      if (currentUser == null) return false;

      await _repository.sendMessage(
        chatId: chatId,
        senderId: currentUser.uid,
        senderName: currentUser.displayName,
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
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> respondToOffer({
    required String chatId,
    required String messageId,
    required String newStatus,
  }) async {
    try {
      await _repository.respondToOffer(
        chatId: chatId,
        messageId: messageId,
        newStatus: newStatus,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> markAsRead(String chatId) async {
    final user = _ref.read(authStateProvider).asData?.value;
    if (user != null) {
      await _repository.markAsRead(chatId, user.uid);
    }
  }
}
