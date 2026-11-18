import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class PublicImpactLedgerScreen extends ConsumerWidget {
  const PublicImpactLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transparent Impact Ledger 📜'),
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
                Icon(Icons.receipt_long_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Verified Circular Economy Ledger',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Transparent public record of every item reused, carbon offset credit logged, and landfill diversion across EcoSwap.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Recent Public Audit Entries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildLedgerEntry(theme, 'TX-98421 • Solid Oak Study Desk', '18.5 kg CO₂ Saved', 'Nov 18, 2026', Icons.check_circle_outline_rounded, AppColors.primary),
          _buildLedgerEntry(theme, 'TX-98420 • Vintage Denim Jacket', '6.2 kg CO₂ Saved', 'Nov 18, 2026', Icons.check_circle_outline_rounded, AppColors.primary),
          _buildLedgerEntry(theme, 'TX-98419 • Adult Mountain Bike', '42.0 kg CO₂ Saved', 'Nov 17, 2026', Icons.check_circle_outline_rounded, AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildLedgerEntry(ThemeData theme, String tx, String impact, String date, IconData icon, Color color) {
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
                Text(tx, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(impact, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
