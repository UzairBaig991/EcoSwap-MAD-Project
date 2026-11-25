import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class RepairRefurbishHubScreen extends ConsumerWidget {
  const RepairRefurbishHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair & Refurbish Hub 🛠️'),
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
                Icon(Icons.build_circle_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Community Upcycling Workshops',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Fix electronics, refurbish furniture, or restore clothing with guidance from certified local makers.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.handyman_rounded),
            label: const Text('Book Repair Session at Local Hub'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Repair workshop session requested! +30 Eco Points 🛠️'),
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
