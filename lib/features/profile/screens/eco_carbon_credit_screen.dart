import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoCarbonCreditScreen extends ConsumerWidget {
  const EcoCarbonCreditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Credit Ledger 💳'),
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
                Icon(Icons.account_balance_wallet_rounded, size: 52, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Verified Carbon Credit Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                SizedBox(height: 4),
                Text(
                  '2.84 Credits',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('1 Credit = 50kg Verified CO₂ Offset', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Carbon Credit Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildTransactionTile(theme, 'Oak Study Desk Swap', '+0.37 Credits', 'Verified Oct 28, 2026', Icons.add_circle_outline_rounded, AppColors.primary),
          _buildTransactionTile(theme, 'Tree Planting Pledge Contribution', '-1.00 Credits', 'Redeemed Oct 20, 2026', Icons.forest_rounded, AppColors.secondary),
          _buildTransactionTile(theme, 'Mountain Bike Re-use', '+0.84 Credits', 'Verified Oct 15, 2026', Icons.add_circle_outline_rounded, AppColors.primary),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.volunteer_activism_rounded),
            label: const Text('Pledge Credits to Urban Reforestation'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carbon credits pledged to local urban tree planting! 🌳'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(ThemeData theme, String title, String amount, String date, IconData icon, Color color) {
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
