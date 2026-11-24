import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CarbonHeatmapScreen extends ConsumerWidget {
  const CarbonHeatmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> weeklyActivity = [
      {'day': 'Mon', 'savedKg': 18.5, 'level': 0.8},
      {'day': 'Tue', 'savedKg': 24.0, 'level': 1.0},
      {'day': 'Wed', 'savedKg': 12.0, 'level': 0.5},
      {'day': 'Thu', 'savedKg': 32.5, 'level': 1.2},
      {'day': 'Fri', 'savedKg': 28.0, 'level': 0.9},
      {'day': 'Sat', 'savedKg': 40.0, 'level': 1.5},
      {'day': 'Sun', 'savedKg': 15.0, 'level': 0.6},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CO₂ Offset Heatmap 📉'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.darkShadeGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 28, color: Colors.amber),
                    SizedBox(width: 10),
                    Text(
                      'Weekly Footprint Savings Heatmap',
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '170.0 kg CO₂ avoided this week across local community swaps!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weeklyActivity.map((a) {
                    final level = a['level'] as double;
                    final day = a['day'] as String;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          width: 28,
                          height: 80 * level,
                          decoration: BoxDecoration(
                            gradient: AppColors.ecoGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryLight.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(day, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Shaded Activity Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildInsightTile(theme, 'Peak Swap Activity', 'Saturday was your highest carbon offset day (40kg CO₂ saved)', Icons.insights_rounded, AppColors.primary),
          _buildInsightTile(theme, 'Zero-Waste Streak', '7 consecutive days of active circular re-use listings', Icons.bolt_rounded, AppColors.tertiary),
        ],
      ),
    );
  }

  Widget _buildInsightTile(ThemeData theme, String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadingShadows,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
