import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        width: 54,
        height: 54,
        color: AppColors.primaryContainer,
        child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
      );
    }

    if (url.startsWith('data:image')) {
      try {
        final base64Data = url.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(bytes, width: 54, height: 54, fit: BoxFit.cover);
      } catch (_) {
        return Container(
          width: 54,
          height: 54,
          color: AppColors.primaryContainer,
          child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primary),
        );
      }
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: 54,
      height: 54,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(
        width: 54,
        height: 54,
        color: AppColors.primaryContainer,
        child: const Icon(Icons.broken_image_rounded, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chatsAsync = ref.watch(userChatsStreamProvider);
    final currentUser = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: chatsAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.forum_outlined,
                    size: 64,
                    color: AppColors.textMutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.emptyChats,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'When you connect with item owners, your chats appear here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherUserId = chat.participants.firstWhere(
                (id) => id != currentUser?.uid,
                orElse: () => '',
              );

              final otherUserName = chat.participantNames[otherUserId] ?? 'Neighbor';
              final unread = chat.unreadCount[currentUser?.uid] ?? 0;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(chat.listingImage),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        otherUserName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      AppFormatters.formatTimeAgo(chat.lastMessageAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: unread > 0 ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
                        fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      'Item: ${chat.listingTitle}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                        color: unread > 0
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: unread > 0
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  ref.read(chatControllerProvider.notifier).markAsRead(chat.id);
                  context.push('/chat/${chat.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading messages: $err')),
      ),
    );
  }
}
