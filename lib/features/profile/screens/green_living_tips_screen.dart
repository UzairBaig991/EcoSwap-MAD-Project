import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class GreenLivingTipsScreen extends ConsumerWidget {
  const GreenLivingTipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> tips = [
      {
        'title': 'Zero-Waste Kitchen Hacks 🍳',
        'category': 'Food & Waste',
        'description': 'Store vegetables in airtight glass containers with damp paper towels to double their shelf life and prevent food spoilage.',
        'impact': 'Saves ~15kg food waste monthly',
        'icon': Icons.kitchen_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Upcycling Old Denim & Clothing 👖',
        'category': 'Fashion',
        'description': 'Turn old worn jeans into durable tote bags, denim coasters, or cleaning rags instead of throwing them in the trash.',
        'impact': 'Saves ~25kg CO₂ per garment',
        'icon': Icons.checkroom_rounded,
        'color': AppColors.secondary,
      },
      {
        'title': 'Smart Home Energy Conservation ⚡',
        'category': 'Energy',
        'description': 'Unplug phantom electronics (chargers, microwaves, TVs on standby) when not in use to cut up to 10% off your monthly power bill.',
        'impact': 'Saves ~120 kWh electricity',
        'icon': Icons.bolt_rounded,
        'color': AppColors.tertiary,
      },
      {
        'title': 'Composting Organic Scraps 🌱',
        'category': 'Gardening',
        'description': 'Combine green waste (fruit peels, coffee grounds) with brown waste (dry leaves, cardboard) to create nutrient-rich soil for plants.',
        'impact': 'Reduces household landfill by 30%',
        'icon': Icons.spa_rounded,
        'color': AppColors.co2Green,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Living Tips & Daily Feed 🌿'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final tip = tips[index];
          final color = tip['color'] as Color;

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
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tip['category'] as String,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tip bookmarked to your saved eco library! 🔖'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(tip['icon'] as IconData, color: color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        tip['title'] as String,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tip['description'] as String,
                  style: TextStyle(fontSize: 13.5, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        tip['impact'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.primary),
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
