import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class SmartValueEstimatorScreen extends ConsumerStatefulWidget {
  const SmartValueEstimatorScreen({super.key});

  @override
  ConsumerState<SmartValueEstimatorScreen> createState() => _SmartValueEstimatorScreenState();
}

class _SmartValueEstimatorScreenState extends ConsumerState<SmartValueEstimatorScreen> {
  String _selectedCategory = 'Furniture';
  String _selectedCondition = 'Good';
  double _originalPrice = 120.0;

  double get _estimatedSwapValue {
    double factor = 0.6;
    if (_selectedCondition == 'Like New') factor = 0.8;
    if (_selectedCondition == 'Fair') factor = 0.4;
    return _originalPrice * factor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Value Estimator 💎'),
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
            child: Column(
              children: [
                const Icon(Icons.auto_graph_rounded, size: 52, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Estimated Fair Swap Value',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${_estimatedSwapValue.toStringAsFixed(2)} USD',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('High Demand Item 🔥', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Original Purchase Retail Price (\$)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Slider(
            value: _originalPrice,
            min: 10.0,
            max: 1000.0,
            divisions: 99,
            activeColor: AppColors.primary,
            label: '\$${_originalPrice.round()}',
            onChanged: (val) => setState(() => _originalPrice = val),
          ),
          Text('\$${_originalPrice.round()} original cost', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          const Text('Item Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
            items: ['Furniture', 'Clothing', 'Electronics', 'Books', 'Sports'].map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 20),

          const Text('Item Condition Quality', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Fair', label: Text('Fair')),
              ButtonSegment(value: 'Good', label: Text('Good')),
              ButtonSegment(value: 'Like New', label: Text('Like New')),
            ],
            selected: {_selectedCondition},
            onSelectionChanged: (set) => setState(() => _selectedCondition = set.first),
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Apply AI Value Range to Listing'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI Swap Value applied to listing! 💎'),
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
