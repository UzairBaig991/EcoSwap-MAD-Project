import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CircularOrbitGalaxyScreen extends ConsumerWidget {
  const CircularOrbitGalaxyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impact Orbit Galaxy 🌌'),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.ecoGradient,
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withOpacity(0.5),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.public_rounded, size: 56, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Community Impact Galaxy Orbit',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your profile is a core node in the local circular economy network. Connected to 142 local swappers!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Active Orbit Rings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildRingTile(theme, 'Landfill Diversion Ring', '6 items safely re-homed and reused', Icons.recycling_rounded, AppColors.primary),
          _buildRingTile(theme, 'Tree Canopy Growth Ring', '10 trees sponsored in urban forest parks', Icons.forest_rounded, AppColors.secondary),
          _buildRingTile(theme, 'Carbon Credit Galaxy', '2.84 verified carbon offset credits logged', Icons.account_balance_wallet_rounded, AppColors.tertiary),
        ],
      ),
    );
  }

  Widget _buildRingTile(ThemeData theme, String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadingShadows,
        border: Border.all(color: color.withOpacity(0.4)),
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
