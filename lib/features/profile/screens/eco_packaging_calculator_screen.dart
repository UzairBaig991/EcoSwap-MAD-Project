import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoPackagingCalculatorScreen extends ConsumerStatefulWidget {
  const EcoPackagingCalculatorScreen({super.key});

  @override
  ConsumerState<EcoPackagingCalculatorScreen> createState() => _EcoPackagingCalculatorScreenState();
}

class _EcoPackagingCalculatorScreenState extends ConsumerState<EcoPackagingCalculatorScreen> {
  int _itemCount = 5;
  String _packagingType = 'Reusable Cloth Wrap (Furoshiki)';

  double get _plasticSavedGrams => _itemCount * 120.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zero-Waste Packaging Hub 📦'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.takeout_dining_rounded, size: 52, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Single-Use Plastic Avoided',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_plasticSavedGrams.round()} Grams Plastic',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Equivalent to 24 single-use plastic bags prevented!', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Total Swaps Completed with Zero Plastic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 32, color: AppColors.primary),
                onPressed: () {
                  if (_itemCount > 1) setState(() => _itemCount--);
                },
              ),
              const SizedBox(width: 16),
              Text('$_itemCount Swaps', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, size: 32, color: AppColors.primary),
                onPressed: () => setState(() => _itemCount++),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text('Preferred Eco Packaging Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _packagingType,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.inventory_2_outlined)),
            items: [
              'Reusable Cloth Wrap (Furoshiki)',
              '100% Recycled Cardboard Box',
              'Compostable Plant-Based Mailer',
              'No Outer Packaging (Direct Handshake)',
            ].map((p) {
              return DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _packagingType = val);
            },
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Log Zero-Waste Packaging Pledge'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Zero-waste packaging pledge logged! Earn +50 bonus Eco Points. 🎁'),
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
