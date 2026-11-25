import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class ReforestationTrackerScreen extends ConsumerWidget {
  const ReforestationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Reforestation Tracker 🌲'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: const Column(
              children: [
                Icon(Icons.park_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Community Tree-Canopy Map',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '1,450 native trees planted in city parks funded by community swap points and carbon offsets.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.park_rounded),
            label: const Text('Track Sponsored Sapling Growth'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tree sapling growth status: Healthy & Growing! 🌲'),
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
