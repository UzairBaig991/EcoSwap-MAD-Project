import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class DisputeMediationScreen extends ConsumerWidget {
  const DisputeMediationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispute & Mediation Hub 🛡️'),
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
                Icon(Icons.gavel_rounded, size: 52, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Community Dispute Protection',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'EcoSwap guarantees fair exchanges. If an item condition differs from its description, our eco-moderators resolve issues promptly.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Protection & Guarantee Guidelines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildGuidelineTile(theme, 'Item Inspection Window', 'Inspect items at the public meeting location before scanning the exchange QR code.', Icons.search_rounded),
          _buildGuidelineTile(theme, 'Condition Matching Guarantee', 'Listings must accurately reflect condition (Like New, Good, Fair).', Icons.verified_rounded),
          _buildGuidelineTile(theme, '24/7 Moderator Resolution', 'Report condition mismatches for instant mediation support.', Icons.support_agent_rounded),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.report_problem_outlined),
            label: const Text('Open Condition Dispute Request'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispute request submitted! An eco-moderator will assist you within 2 hours. 🛡️'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineTile(ThemeData theme, String title, String subtitle, IconData icon) {
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
            backgroundColor: AppColors.primaryContainer,
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
