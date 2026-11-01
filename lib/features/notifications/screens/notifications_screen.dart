import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Swap Offer! 🔄',
        'subtitle': 'Sarah offered a Vintage Denim Jacket for your Solid Oak Study Desk.',
        'time': '10m ago',
        'isRead': false,
        'icon': Icons.swap_horizontal_circle_rounded,
        'color': AppColors.secondary,
      },
      {
        'title': 'Eco Challenge Completed! 🏆',
        'subtitle': 'You completed the "Zero Waste Weekend" quest and earned 100 Eco Points!',
        'time': '2h ago',
        'isRead': false,
        'icon': Icons.emoji_events_rounded,
        'color': AppColors.tertiary,
      },
      {
        'title': 'Item Claimed Successfully 🌱',
        'subtitle': 'Your listing "Mountain Bicycle" has been claimed. CO₂ saved: ~42kg.',
        'time': '1d ago',
        'isRead': true,
        'icon': Icons.eco_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Welcome to EcoSwap! 🎉',
        'subtitle': 'Thanks for joining our sustainable community. Start exploring nearby listings.',
        'time': '3d ago',
        'isRead': true,
        'icon': Icons.celebration_rounded,
        'color': AppColors.info,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];
          final isRead = n['isRead'] as bool;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRead
                  ? theme.cardColor
                  : theme.colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead ? theme.colorScheme.outline.withOpacity(0.3) : AppColors.primary.withOpacity(0.5),
                width: isRead ? 1 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: (n['color'] as Color).withOpacity(0.15),
                  child: Icon(n['icon'] as IconData, color: n['color'] as Color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              n['title'] as String,
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            n['time'] as String,
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
