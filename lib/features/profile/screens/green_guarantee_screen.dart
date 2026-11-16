import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class GreenGuaranteeScreen extends ConsumerWidget {
  const GreenGuaranteeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoSwap Green Guarantee 🛡️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.verified_user_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  '100% Safe & Fair Exchange Guarantee',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Every swap on EcoSwap is protected by community trust verification, public meeting check-ins, and anti-fraud monitoring.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Your Protection Pillars', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildPillarTile(theme, 'Verified Member Profiles', 'All active swappers go through phone & email identity checks.', Icons.shield_rounded, AppColors.primary),
          _buildPillarTile(theme, 'Public Exchange Safe-Zones', 'Recommended meeting spots at verified community hubs and libraries.', Icons.location_city_rounded, AppColors.secondary),
          _buildPillarTile(theme, 'QR Code Handoff Verification', 'In-person QR code scans confirm physical item transfer.', Icons.qr_code_scanner_rounded, AppColors.tertiary),
          _buildPillarTile(theme, 'Dispute Protection & Moderation', 'Dedicated eco-moderators resolve listing condition discrepancies.', Icons.support_agent_rounded, AppColors.co2Green),
        ],
      ),
    );
  }

  Widget _buildPillarTile(ThemeData theme, String title, String subtitle, IconData icon, Color color) {
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
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurfaceVariant, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
