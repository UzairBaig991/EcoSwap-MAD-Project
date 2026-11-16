import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CarbonLeaderboardScreen extends ConsumerWidget {
  const CarbonLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> rankings = [
      {
        'rank': '1',
        'name': 'Downtown Eco-District',
        'co2Saved': '1,280 kg CO₂',
        'badge': 'Emerald Legend 💎',
        'color': AppColors.primary,
      },
      {
        'rank': '2',
        'name': 'Greenwich Village',
        'co2Saved': '940 kg CO₂',
        'badge': 'Forest Guardian 🌳',
        'color': AppColors.secondary,
      },
      {
        'rank': '3',
        'name': 'SoHo Circular Alliance',
        'co2Saved': '720 kg CO₂',
        'badge': 'Sprout Pioneer 🌱',
        'color': AppColors.tertiary,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('City Carbon Leaderboard 🏆'),
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
                Icon(Icons.military_tech_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Citywide Zero-Waste Rankings',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Rankings updated live based on verified item swaps and landfill waste diverted.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Top Performing Neighborhoods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ...rankings.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (r['color'] as Color).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: (r['color'] as Color).withOpacity(0.15),
                      child: Text(r['rank'] as String, style: TextStyle(fontWeight: FontWeight.bold, color: r['color'] as Color)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(r['badge'] as String, style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text(r['co2Saved'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.primary)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
