import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoItemInspectorScreen extends ConsumerStatefulWidget {
  const EcoItemInspectorScreen({super.key});

  @override
  ConsumerState<EcoItemInspectorScreen> createState() => _EcoItemInspectorScreenState();
}

class _EcoItemInspectorScreenState extends ConsumerState<EcoItemInspectorScreen> {
  double _widthCm = 45.0;
  double _heightCm = 60.0;
  double _depthCm = 30.0;
  double _weightKg = 4.5;

  double get _volumeCubicMeters => (_widthCm * _heightCm * _depthCm) / 1000000;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco AR Item Inspector 📐'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.camera_enhance_rounded, size: 64, color: Colors.white38),
                Positioned(
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.view_in_ar_rounded, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text('AR Measurement Grid Active', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Item Dimension Sliders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          Text('Width: ${_widthCm.round()} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _widthCm,
            min: 10.0,
            max: 200.0,
            divisions: 190,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _widthCm = val),
          ),

          Text('Height: ${_heightCm.round()} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _heightCm,
            min: 10.0,
            max: 200.0,
            divisions: 190,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _heightCm = val),
          ),

          Text('Depth: ${_depthCm.round()} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _depthCm,
            min: 10.0,
            max: 200.0,
            divisions: 190,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _depthCm = val),
          ),

          Text('Weight Estimate: ${_weightKg.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _weightKg,
            min: 0.5,
            max: 50.0,
            divisions: 99,
            activeColor: AppColors.secondary,
            onChanged: (val) => setState(() => _weightKg = val),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estimated Volume:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${_volumeCubicMeters.toStringAsFixed(3)} m³', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Attach Dimensions to Listing'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dimensions attached to item listing! 📐'),
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
