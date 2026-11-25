import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class PlasticChallengeScreen extends ConsumerWidget {
  const PlasticChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plastic Elimination Challenge 🚫')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.impactGradient, borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                Icon(Icons.no_food_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text('30-Day Plastic-Free Living Quest', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Eliminate single-use plastic water bottles and shopping bags to unlock community badges.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
