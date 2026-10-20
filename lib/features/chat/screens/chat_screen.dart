import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/network/cloudinary_service.dart';
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
  final ImagePicker _picker = ImagePicker();

  ChatModel? _activeChat;
  bool _initializing = true;

  final List<String> _quickReplies = [
    'Is this item still available?',
    'Where can we meet to swap?',
    'I can pick it up today!',
    'What condition is it in?',
  ];

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

  Future<void> _handleSend({
    bool isOffer = false,
    String? offerTitle,
    String? offerImage,
    String? imageUrl,
    String? locationAddress,
  }) async {
    final text = _textController.text.trim();
    if ((text.isEmpty && !isOffer && imageUrl == null && locationAddress == null) ||
        _activeChat == null) {
      return;
    }

    final currentUser = ref.read(authStateProvider).asData?.value;
    if (currentUser == null) return;

    final recipientId = _activeChat!.participants.firstWhere(
      (id) => id != currentUser.uid,
      orElse: () => '',
    );

    _textController.clear();

    final success = await ref.read(chatControllerProvider.notifier).sendMessage(
          chatId: _activeChat!.id,
          text: isOffer
              ? 'Offered swap with: "$offerTitle"'
              : (imageUrl != null
                  ? '📷 Photo'
                  : (locationAddress != null ? '📍 Shared Location: $locationAddress' : text)),
          recipientId: recipientId,
          isOffer: isOffer,
          offerItemTitle: offerTitle,
          offerItemImage: offerImage,
          imageUrl: imageUrl,
          locationLat: locationAddress != null ? 37.7749 : null,
          locationLng: locationAddress != null ? -122.4194 : null,
          locationAddress: locationAddress,
        );

    if (success) {
      Timer(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (photo == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading photo...'), duration: Duration(seconds: 2)),
      );

      final uploadedUrl = await CloudinaryService.uploadImage(File(photo.path));
      if (uploadedUrl != null) {
        _handleSend(imageUrl: uploadedUrl);
      }
    } catch (_) {}
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Photo Attachment
                  InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndSendImage();
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.purple.shade100,
                          child: const Icon(Icons.photo_library_rounded, color: Colors.purple, size: 28),
                        ),
                        const SizedBox(height: 8),
                        const Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Swap Offer Attachment
                  InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showMakeOfferModal();
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryContainer,
                          child: const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(height: 8),
                        const Text('Swap Offer', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Share Location Attachment
                  InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _handleSend(locationAddress: 'Downtown Green Park Pickup Point');
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.location_on_rounded, color: Colors.green, size: 28),
                        ),
                        const SizedBox(height: 8),
                        const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.78,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(/* WhatsApp Green */ 0xFFDCF8C6)
                                    : (theme.brightness == Brightness.dark
                                        ? AppColors.surfaceVariantDark
                                        : Colors.white),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(14),
                                  topRight: const Radius.circular(14),
                                  bottomLeft: isMe ? const Radius.circular(14) : const Radius.circular(2),
                                  bottomRight: isMe ? const Radius.circular(2) : const Radius.circular(14),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (msg.imageUrl != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: msg.imageUrl!,
                                          width: 200,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (msg.locationAddress != null)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on_rounded, color: Colors.green, size: 20),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              msg.locationAddress!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Text(
                                    msg.text,
                                    style: TextStyle(
                                      color: isMe ? Colors.black87 : theme.colorScheme.onSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Time & Double Blue Ticks (WhatsApp Style)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppFormatters.formatTimeAgo(msg.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 10,
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        // WhatsApp Double Blue Ticks (✓✓)
                                        const Icon(
                                          Icons.done_all_rounded,
                                          size: 16,
                                          color: Color(0xFF34B7F1), // WhatsApp Blue
                                        ),
                                      ],
                                    ],
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

                // Quick Replies Bar
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _quickReplies.length,
                    itemBuilder: (ctx, idx) {
                      final text = _quickReplies[idx];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          label: Text(text, style: const TextStyle(fontSize: 11)),
                          onPressed: () {
                            _textController.text = text;
                            _handleSend();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),

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
                          icon: const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
                          tooltip: 'Add Photo or Location',
                          onPressed: _showAttachmentMenu,
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
