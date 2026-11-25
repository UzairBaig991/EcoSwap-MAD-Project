import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class SupplyChainPassportScreen extends ConsumerWidget {
  const SupplyChainPassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circular Supply Chain Passport 📦')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.impactGradient, borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                Icon(Icons.inventory_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text('Transparent Lifecycle Tracking', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Trace item origin, manufacturing material composition, and re-use history.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
