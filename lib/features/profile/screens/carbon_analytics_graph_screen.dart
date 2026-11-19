import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CarbonAnalyticsGraphScreen extends ConsumerWidget {
  const CarbonAnalyticsGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Analytics Graph 📊'),
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
                Icon(Icons.query_stats_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Monthly Carbon Offset Growth',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Your circular swaps avoided 142 kg of CO₂ emissions this month — up 24% from last month!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Category Impact Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildCategoryBar(theme, 'Furniture & Decor', '65 kg CO₂ (45%)', 0.85, AppColors.primary),
          _buildCategoryBar(theme, 'Electronics & Tech', '42 kg CO₂ (30%)', 0.60, AppColors.secondary),
          _buildCategoryBar(theme, 'Clothing & Fashion', '35 kg CO₂ (25%)', 0.45, AppColors.tertiary),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(ThemeData theme, String title, String subtitle, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
              Text(subtitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
