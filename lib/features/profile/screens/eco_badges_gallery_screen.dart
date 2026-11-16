import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoBadgesGalleryScreen extends ConsumerWidget {
  const EcoBadgesGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> badges = [
      {
        'title': 'Zero Waste Pioneer ♻️',
        'desc': 'Completed 5+ free giveaways to local community members',
        'isUnlocked': true,
        'color': AppColors.primary,
        'icon': Icons.recycling_rounded,
      },
      {
        'title': 'Carbon Champion 🏆',
        'desc': 'Offset over 100 kg of CO₂ through circular exchanges',
        'isUnlocked': true,
        'color': AppColors.tertiary,
        'icon': Icons.emoji_events_rounded,
      },
      {
        'title': 'Master Swapper 🔄',
        'desc': 'Completed 10+ direct item trades without cancellations',
        'isUnlocked': true,
        'color': AppColors.secondary,
        'icon': Icons.swap_horizontal_circle_rounded,
      },
      {
        'title': 'Master Reforester 🌳',
        'desc': 'Pledged 5+ trees to urban tree-planting initiatives',
        'isUnlocked': true,
        'color': AppColors.co2Green,
        'icon': Icons.forest_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collectible Eco Badges 🏅'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Icon(Icons.workspace_premium_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Your Achievement Showcase',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Unlock collectible badges by participating in swaps, planting trees, and reducing landfill waste.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Unlocked Badges (4/4)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ...badges.map((b) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (b['color'] as Color).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: (b['color'] as Color).withOpacity(0.2),
                      radius: 24,
                      child: Icon(b['icon'] as IconData, color: b['color'] as Color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(b['desc'] as String, style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
