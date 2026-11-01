import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class PersonalSwapInsightsScreen extends ConsumerWidget {
  const PersonalSwapInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Swap Insights 📊'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Value Reclaimed',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                SizedBox(height: 6),
                Text(
                  '\$1,240 USD',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  '🌱 142 kg CO₂ saved • 6 items successfully swapped',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Category Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildInsightBar(context, 'Furniture & Home', 0.45, '45%'),
          _buildInsightBar(context, 'Clothing & Apparel', 0.25, '25%'),
          _buildInsightBar(context, 'Books & Media', 0.20, '20%'),
          _buildInsightBar(context, 'Electronics & Gadgets', 0.10, '10%'),
          const SizedBox(height: 24),

          const Text('Performance Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildMetricTile(theme, 'Average Offer Response Time', '18 minutes', Icons.bolt_rounded, AppColors.tertiary),
          _buildMetricTile(theme, 'Swap Completion Rate', '98.5%', Icons.verified_rounded, AppColors.primary),
          _buildMetricTile(theme, 'Trust & Reliability Rating', '4.9 / 5.0 ⭐', Icons.star_rounded, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildInsightBar(BuildContext context, String category, double progress, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primaryContainer,
            color: AppColors.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
