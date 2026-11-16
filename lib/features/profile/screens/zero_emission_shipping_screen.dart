import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class ZeroEmissionShippingScreen extends ConsumerWidget {
  const ZeroEmissionShippingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zero-Emission Eco Courier 🚲'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
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
                Icon(Icons.pedal_bike_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Local Cargo Bike Delivery',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Need an item delivered locally? Choose zero-emission electric cargo bike couriers or parcel locker pickups.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Available Eco Delivery Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildOptionTile(theme, 'E-Bike Cargo Courier', '0.0 kg CO₂ • Same Day Delivery', '\$3.50 USD', Icons.electric_bike_rounded, AppColors.primary),
          _buildOptionTile(theme, 'Community Locker Pick-Up', '0.0 kg CO₂ • 24/7 Access Locker', 'FREE 🎁', Icons.lock_clock_rounded, AppColors.secondary),
          _buildOptionTile(theme, 'Walking Volunteer Handoff', '0.0 kg CO₂ • Neighbors helping neighbors', 'FREE 🎁', Icons.directions_walk_rounded, AppColors.tertiary),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.local_shipping_rounded),
            label: const Text('Request E-Cargo Courier Pickup'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Zero-emission courier request dispatched! 🚲'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(ThemeData theme, String title, String subtitle, String price, IconData icon, Color color) {
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
                Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}
