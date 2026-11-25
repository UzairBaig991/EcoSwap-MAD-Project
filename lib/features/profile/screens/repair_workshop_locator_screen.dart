import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class RepairWorkshopLocatorScreen extends ConsumerWidget {
  const RepairWorkshopLocatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repair Workshop Locator 📍')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.impactGradient, borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                Icon(Icons.location_searching_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text('Certified Local Repair Cafes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Locate community repair cafes offering free appliance, electronics, and bicycle fixes.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
