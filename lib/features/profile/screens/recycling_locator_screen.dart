import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class RecyclingLocatorScreen extends ConsumerWidget {
  const RecyclingLocatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> centers = [
      {
        'name': 'EcoTech E-Waste & Battery Drop-Off',
        'address': '22 Circuit Road, Tech District',
        'distance': '1.8 km away',
        'accepted': 'Smartphones, Laptops, Batteries, Chargers',
        'hours': 'Mon - Fri: 9:00 AM - 5:00 PM',
        'badge': 'Certified Green Facility 🟢',
      },
      {
        'name': 'City Glass & Metal Eco-Station',
        'address': '77 Circular Avenue, Industrial Zone',
        'distance': '3.2 km away',
        'accepted': 'Glass Bottles, Aluminum Cans, Scrap Metal',
        'hours': 'Daily: 8:00 AM - 7:00 PM',
        'badge': 'Zero Landfill Partner 🌱',
      },
      {
        'name': 'GreenHarvest Organic Composting Plant',
        'address': '5 Orchard Lane, Valley Suburbs',
        'distance': '4.6 km away',
        'accepted': 'Food Scraps, Yard Waste, Biodegradable Packaging',
        'hours': 'Tue - Sun: 7:00 AM - 4:00 PM',
        'badge': 'Organic Certified 🌿',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling & E-Waste Locator ♻️'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: centers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final center = centers[index];

          return Container(
            padding: const EdgeInsets.all(20),
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
                        center['distance'] as String,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      center['badge'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  center['name'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 4),
                    Text(center['address'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 15, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 4),
                    Text(center['hours'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Accepted: ${center['accepted']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.map_rounded),
                  label: const Text('Get Directions & Drop-Off Info'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening recycling center directions & drop-off guidelines! ♻️'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
