import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class ReforestationPledgeScreen extends ConsumerWidget {
  const ReforestationPledgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> parks = [
      {
        'name': 'Downtown Urban Eco-Forest Park',
        'location': 'Central Avenue Sector 4',
        'treesPlanted': 340,
        'needed': 500,
        'image': 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600',
      },
      {
        'name': 'Greenwich Riverside Canopy',
        'location': 'Westside Waterfront',
        'treesPlanted': 180,
        'needed': 300,
        'image': 'https://images.unsplash.com/photo-1511497584788-876761c11969?w=600',
      },
      {
        'name': 'Community Orchard Reserve',
        'location': 'North Valley District',
        'treesPlanted': 420,
        'needed': 600,
        'image': 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Tree Planting Parks 🌳'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: parks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final park = parks[index];

          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    park['image'] as String,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${park['treesPlanted']} / ${park['needed']} Trees Planted',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.forest_rounded, size: 16, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text('Active Planting Zone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        park['name'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(park['location'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Text('Sponsor 1 Tree Sapling (100 Eco Points)'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tree sapling sponsored! Thank you for greening our city. 🌳'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
