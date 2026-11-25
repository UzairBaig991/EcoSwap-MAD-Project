import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoTransportMileageScreen extends ConsumerWidget {
  const EcoTransportMileageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Transport Meter 🚶'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: const Column(
              children: [
                Icon(Icons.directions_walk_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Zero-Emission Handoff Miles',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'You have logged 38.5 miles of walking or biking for local item handoffs — preventing car exhaust emissions!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.add_location_alt_rounded),
            label: const Text('Log Walkable Swap Pickup (+15 pts)'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Walkable pickup logged! +15 Eco Points added to balance. 🚶'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
