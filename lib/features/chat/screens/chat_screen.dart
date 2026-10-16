import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/message_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String? initialListingTitle;
  final String? initialOwnerId;
  final String? initialOwnerName;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.initialListingTitle,
    this.initialOwnerId,
    this.initialOwnerName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatModel? _activeChat;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
    final userChats = ref.read(userChatsStreamProvider).asData?.value ?? [];
    ChatModel? foundChat;

    try {
      foundChat = userChats.firstWhere((c) => c.id == widget.chatId);
    } catch (_) {
      foundChat = null;
    }

    if (foundChat != null) {
      _activeChat = foundChat;
      ref.read(chatControllerProvider.notifier).markAsRead(widget.chatId);
    } else if (widget.initialOwnerId != null) {
      final listingId = widget.chatId.split('_').first;
      final createdChat = await ref.read(chatControllerProvider.notifier).initializeChat(
            listingId: listingId,
            ownerId: widget.initialOwnerId!,
            ownerName: widget.initialOwnerName ?? 'Owner',
            listingTitle: widget.initialListingTitle ?? 'Listing Item',
          );
      _activeChat = createdChat;
    }

    if (mounted) {
      setState(() => _initializing = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handleSend({bool isOffer = false, String? offerTitle, String? offerImage}) async {
    final text = _textController.text.trim();
    if ((text.isEmpty && !isOffer) || _activeChat == null) return;

    final currentUser = ref.read(authStateProvider).asData?.value;
    if (currentUser == null) return;

    final recipientId = _activeChat!.participants.firstWhere(
      (id) => id != currentUser.uid,
      orElse: () => '',
    );

    _textController.clear();

    final success = await ref.read(chatControllerProvider.notifier).sendMessage(
          chatId: _activeChat!.id,
          text: isOffer ? 'I offered to swap with: "$offerTitle"' : text,
          recipientId: recipientId,
          isOffer: isOffer,
          offerItemTitle: offerTitle,
          offerItemImage: offerImage,
        );

    if (success) {
      Timer(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _showMakeOfferModal() {
    final myListings = ref.read(userListingsStreamProvider).asData?.value ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Propose a Swap Offer 🔄',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Select an item from your listings to offer in exchange:'),
              const SizedBox(height: 16),
              if (myListings.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('You have no active listings. Post an item first to make swap offers!'),
                )
              else
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    itemCount: myListings.length,
                    itemBuilder: (context, idx) {
                      final item = myListings[idx];
                      return ListTile(
                        leading: const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${item.category} • ${item.condition}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _handleSend(
                              isOffer: true,
                              offerTitle: item.title,
                              offerImage: item.images.isNotEmpty ? item.images.first : null,
                            );
                          },
                          child: const Text('Offer This Item'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfferBubble(MessageModel msg, bool isMe, ThemeData theme) {
    final status = msg.offerStatus ?? 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primaryContainer : AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == 'Accepted'
              ? AppColors.success
              : (status == 'Declined' ? AppColors.error : AppColors.primary),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'SWAP OFFER',
                style: TextStyle(
                  color: isMe ? AppColors.primaryDark : AppColors.secondaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Accepted'
                      ? AppColors.success
                      : (status == 'Declined' ? AppColors.error : AppColors.warning),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Offered Item: "${msg.offerItemTitle ?? 'Item'}"',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (!isMe && status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(chatControllerProvider.notifier).respondToOffer(
                            chatId: widget.chatId,
                            messageId: msg.id,
                            newStatus: 'Declined',
                          );
                    },
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(chatControllerProvider.notifier).respondToOffer(
                            chatId: widget.chatId,
                            messageId: msg.id,
                            newStatus: 'Accepted',
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Offer Accepted! Item status updated to Claimed 🎉'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    child: const Text('Accept Swap'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(authStateProvider).asData?.value;
    final messagesAsync = ref.watch(chatMessagesStreamProvider(widget.chatId));

    final otherUserId = _activeChat?.participants.firstWhere(
      (id) => id != currentUser?.uid,
      orElse: () => '',
    );
    final otherUserName = _activeChat?.participantNames[otherUserId] ??
        widget.initialOwnerName ??
        'Swapper';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(otherUserName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              _activeChat?.listingTitle ?? widget.initialListingTitle ?? 'Listing Item',
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_calls_rounded, color: AppColors.primary),
            tooltip: 'Make Swap Offer',
            onPressed: _showMakeOfferModal,
          ),
          if (_activeChat != null)
            TextButton.icon(
              onPressed: () => context.push('/listing/${_activeChat!.listingId}'),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('View Item'),
            ),
        ],
      ),
      body: _initializing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Listing Header Banner
                if (_activeChat != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: AppColors.primaryContainer.withOpacity(0.5),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Chat regarding "${_activeChat!.listingTitle}"',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _showMakeOfferModal,
                          child: const Text('+ Propose Swap'),
                        ),
                      ],
                    ),
                  ),

                // Messages Stream
                Expanded(
                  child: messagesAsync.when(
                    data: (messages) {
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            'Say hi! Propose an offer or arrange a time to swap.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == currentUser?.uid;

                          if (msg.isOffer) {
                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: _buildOfferBubble(msg, isMe, theme),
                            );
                          }

                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? AppColors.primary
                                    : (theme.brightness == Brightness.dark
                                        ? AppColors.surfaceVariantDark
                                        : AppColors.surfaceVariantLight),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.text,
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppFormatters.formatTimeAgo(msg.createdAt),
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white70
                                          : theme.colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                ),

                // Message Input Box
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(color: theme.colorScheme.outline, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary),
                          tooltip: 'Propose Swap Offer',
                          onPressed: _showMakeOfferModal,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _handleSend(),
                          icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
