import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoWishlistScreen extends ConsumerStatefulWidget {
  const EcoWishlistScreen({super.key});

  @override
  ConsumerState<EcoWishlistScreen> createState() => _EcoWishlistScreenState();
}

class _EcoWishlistScreenState extends ConsumerState<EcoWishlistScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'title': 'Acoustic Guitar',
      'category': 'Music & Hobbies',
      'matchCount': 2,
      'isRadarActive': true,
    },
    {
      'title': 'Kindle Paperwhite E-Reader',
      'category': 'Electronics',
      'matchCount': 1,
      'isRadarActive': true,
    },
    {
      'title': 'Indoor Rubber Plant',
      'category': 'Home & Garden',
      'matchCount': 4,
      'isRadarActive': true,
    },
  ];

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _addWishlistItem() {
    if (_itemController.text.trim().isEmpty) return;
    setState(() {
      _wishlistItems.add({
        'title': _itemController.text.trim(),
        'category': 'General',
        'matchCount': 0,
        'isRadarActive': true,
      });
      _itemController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to Wishlist & Smart Match Radar activated! 📡'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Eco-Wishlist Radar 📡'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.radar_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Automated Match Radar',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Add items you want to swap for. EcoSwap scans new community listings 24/7 and alerts you when a match is found!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Add Item Input Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Vintage Camera, Espresso Machine...',
                    prefixIcon: Icon(Icons.add_shopping_cart_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addWishlistItem,
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text('Active Wishlist Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ..._wishlistItems.map((item) {
            final matches = item['matchCount'] as int;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryContainer,
                    child: const Icon(Icons.stars_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          matches > 0 ? '$matches active matches found nearby! 🔥' : 'Scanning community listings...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: matches > 0 ? FontWeight.bold : FontWeight.normal,
                            color: matches > 0 ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (matches > 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening $matches matched listings! 🔄'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('View', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
