import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class LivingHackFeedScreen extends ConsumerWidget {
  const LivingHackFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sustainable Living Hacks 💡')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.impactGradient, borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                Icon(Icons.lightbulb_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text('Daily Eco Tips & Tricks', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Discover simple daily eco hacks for energy conservation, food waste reduction, and smart swapping.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
