import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoTrophyCabinetScreen extends ConsumerWidget {
  const EcoTrophyCabinetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> trophies = [
      {
        'title': 'Golden Leaf Trophy 🏆',
        'sub': 'Top 1% City Carbon Offsetter',
        'color': Colors.amber,
        'icon': Icons.emoji_events_rounded,
      },
      {
        'title': 'Emerald Shield 🛡️',
        'sub': '100% Verified Safe Trader',
        'color': AppColors.primary,
        'icon': Icons.security_rounded,
      },
      {
        'title': 'Sapphire Ocean Award 🌊',
        'sub': '500g Plastic Packaging Avoided',
        'color': AppColors.secondary,
        'icon': Icons.water_drop_rounded,
      },
      {
        'title': 'Forest Canopy Crown 👑',
        'sub': '10 Trees Sponsored & Planted',
        'color': AppColors.co2Green,
        'icon': Icons.forest_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shaded Trophy Cabinet 🏆'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.darkShadeGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: const Column(
              children: [
                Icon(Icons.workspace_premium_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  '3D Shaded Trophy Hall',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Your verified circular economy milestone awards with 3D gradient aura highlights.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: trophies.length,
            itemBuilder: (context, index) {
              final t = trophies[index];
              final color = t['color'] as Color;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadingShadows,
                  border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(t['icon'] as IconData, color: color, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t['sub'] as String,
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
