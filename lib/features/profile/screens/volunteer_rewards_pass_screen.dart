import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class VolunteerRewardsPassScreen extends ConsumerWidget {
  const VolunteerRewardsPassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Rewards Pass 🎗️'),
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
                Icon(Icons.volunteer_activism_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Community Volunteer Hours',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Logged 12 hours organizing neighborhood swap meets and local e-waste recycling drives.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Claim Official Volunteer Certificate Pass'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Volunteer certificate pass claimed! Thank you for serving your community. 🎗️'),
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
