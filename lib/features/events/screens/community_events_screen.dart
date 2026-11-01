import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CommunityEventsScreen extends ConsumerWidget {
  const CommunityEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> events = [
      {
        'title': 'Green University Book Drive 📚',
        'location': 'City Campus Library Quad',
        'date': 'Nov 15, 2026 • 10:00 AM',
        'participants': 42,
        'category': 'Books & Media',
        'image': 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=600',
      },
      {
        'title': 'Neighborhood Clothing Swap 🧥',
        'location': 'Community Center Hall B',
        'date': 'Nov 22, 2026 • 2:00 PM',
        'participants': 88,
        'category': 'Clothing & Apparel',
        'image': 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=600',
      },
      {
        'title': 'E-Waste & Gadget Recycling Day ⚡',
        'location': 'Downtown Eco Park',
        'date': 'Dec 02, 2026 • 9:00 AM',
        'participants': 64,
        'category': 'Electronics',
        'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=600',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Swap Events 🎪'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final event = events[index];

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
                    event['image'] as String,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event['category'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.people_rounded, size: 16, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                '${event['participants']} going',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event['title'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(event['location'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(event['date'] as String, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: const Text('RSVP / Join Event'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully registered for community swap event! 🌱'),
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
