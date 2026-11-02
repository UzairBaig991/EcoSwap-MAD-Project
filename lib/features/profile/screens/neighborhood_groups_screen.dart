import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class NeighborhoodGroupsScreen extends ConsumerWidget {
  const NeighborhoodGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> groups = [
      {
        'name': 'Downtown Sustainability Circle',
        'members': 342,
        'activeListings': 48,
        'description': 'Local residents collaborating on zero-waste living, tool sharing, and weekend clothing swaps.',
        'image': 'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=600',
        'isJoined': true,
      },
      {
        'name': 'Greenwich Village Re-users',
        'members': 189,
        'activeListings': 22,
        'description': 'Neighborhood group focused on vintage book exchanges and furniture giving.',
        'image': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=600',
        'isJoined': false,
      },
      {
        'name': 'Metro Zero Waste Alliance',
        'members': 520,
        'activeListings': 95,
        'description': 'City-wide eco pod organizing massive electronic recycling and plant sharing events.',
        'image': 'https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?w=600',
        'isJoined': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Neighborhood Eco-Pods 🏘️'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final group = groups[index];
          final isJoined = group['isJoined'] as bool;

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
                    group['image'] as String,
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
                          Row(
                            children: [
                              const Icon(Icons.people_alt_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('${group['members']} members', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${group['activeListings']} active items',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        group['name'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        group['description'] as String,
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isJoined ? theme.colorScheme.surfaceContainerHighest : AppColors.primary,
                          foregroundColor: isJoined ? theme.colorScheme.onSurface : Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isJoined ? 'Left neighborhood pod.' : 'Successfully joined neighborhood eco-pod! 🌱'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        child: Text(isJoined ? 'Joined (Tap to Leave)' : 'Join Eco-Pod'),
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
