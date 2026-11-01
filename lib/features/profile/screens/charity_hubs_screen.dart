import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CharityHubsScreen extends ConsumerWidget {
  const CharityHubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> hubs = [
      {
        'name': 'Green Hope Community Center',
        'address': '14 Eco Avenue, Downtown',
        'distance': '1.2 km away',
        'hours': 'Mon - Sat: 9:00 AM - 6:00 PM',
        'accepted': 'Clothing, Books, Small Furniture',
        'phone': '+1 (555) 234-5678',
        'image': 'https://images.unsplash.com/photo-1532629345422-7515f3d16bb9?w=600',
      },
      {
        'name': 'SecondLife Textile & Electronics Bank',
        'address': '88 Regeneration Blvd, Westside',
        'distance': '3.4 km away',
        'hours': 'Daily: 8:00 AM - 8:00 PM',
        'accepted': 'Electronics, Gadgets, Winter Wear',
        'phone': '+1 (555) 987-6543',
        'image': 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600',
      },
      {
        'name': 'Urban Re-use & Furniture Depot',
        'address': '45 Circular Way, North District',
        'distance': '5.1 km away',
        'hours': 'Tue - Sun: 10:00 AM - 5:00 PM',
        'accepted': 'Furniture, Home Decor, Appliances',
        'phone': '+1 (555) 456-7890',
        'image': 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=600',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charity & Donation Hubs 🤝'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hubs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final hub = hubs[index];

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
                    hub['image'] as String,
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
                              hub['distance'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('Verified Partner', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hub['name'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(hub['address'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 15, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(hub['hours'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 15, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('Accepted: ${hub['accepted']}', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.directions_outlined),
                        label: const Text('Schedule Donation Drop-Off'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Donation drop-off scheduled! Earn +100 bonus Eco Points upon delivery. 🌱'),
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
