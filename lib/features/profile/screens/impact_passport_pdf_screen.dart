import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class ImpactPassportPdfScreen extends ConsumerWidget {
  const ImpactPassportPdfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Eco Passport 🛂'),
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
                Icon(Icons.badge_rounded, size: 56, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'CIRCULAR PASSPORT & IMPACT PASS',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Official Lifetime Carbon Footprint Reduction Record',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  textAlign: TextAlign.center,
                ),
                Divider(height: 24, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('142 kg', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('CO₂ Offset', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('6 Swaps', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Items Reused', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('5 Trees', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Planted', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Export High-Res Digital Passport'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Digital Eco Passport exported successfully! 🛂'),
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
