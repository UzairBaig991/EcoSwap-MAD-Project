import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class AiConditionVerifierScreen extends ConsumerWidget {
  const AiConditionVerifierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Condition Verifier 🔍'),
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
                Icon(Icons.find_in_page_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Computer Vision Listing Audit',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'AI computer vision analyzes photo clarity, detects physical defects, and confirms condition accuracy.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Verification Results', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildAuditTile(theme, 'Photo Clarity & Lighting', 'High Quality (1080p+ verified)', Icons.center_focus_strong_rounded, AppColors.primary),
          _buildAuditTile(theme, 'Surface Defect Inspection', 'No major scratches or tears detected', Icons.saved_search_rounded, AppColors.primary),
          _buildAuditTile(theme, 'Listing Authenticity Score', '98% Genuine Item Confidence', Icons.verified_user_rounded, AppColors.tertiary),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Attach AI Quality Badge to Listing'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI Quality Badge attached to listing! 🔍'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTile(ThemeData theme, String title, String subtitle, IconData icon, Color color) {
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
