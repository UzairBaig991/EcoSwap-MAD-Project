import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class HallOfFameScreen extends ConsumerWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> champions = [
      {
        'rank': '1',
        'name': 'Sarah Jenkins',
        'title': 'Zero-Waste Pioneer 🏆',
        'co2Saved': '482 kg CO₂',
        'swaps': 48,
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        'medalColor': Colors.amber,
      },
      {
        'rank': '2',
        'name': 'Alex Rivers',
        'title': 'Master Reforester 🌳',
        'co2Saved': '395 kg CO₂',
        'swaps': 36,
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        'medalColor': Colors.grey.shade400,
      },
      {
        'rank': '3',
        'name': 'Elena Vance',
        'title': 'Circular Hero 🌿',
        'co2Saved': '310 kg CO₂',
        'swaps': 29,
        'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        'medalColor': Colors.brown.shade300,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Hall of Fame 🏆'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Icon(Icons.emoji_events_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Annual Sustainability Champions',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Celebrating community members who led the movement in diverted landfill waste and verified carbon savings.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Hall of Fame Rankings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ...champions.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (c['medalColor'] as Color).withOpacity(0.5), width: 1.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: (c['medalColor'] as Color).withOpacity(0.2),
                      child: Text(c['rank'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: c['medalColor'] as Color)),
                    ),
                    const SizedBox(width: 14),
                    CircleAvatar(
                      backgroundImage: NetworkImage(c['image'] as String),
                      radius: 22,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(c['title'] as String, style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(c['co2Saved'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                        Text('${c['swaps']} swaps', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
