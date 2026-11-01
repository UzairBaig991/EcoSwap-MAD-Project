import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CarbonOffsetPledgeScreen extends ConsumerStatefulWidget {
  const CarbonOffsetPledgeScreen({super.key});

  @override
  ConsumerState<CarbonOffsetPledgeScreen> createState() => _CarbonOffsetPledgeScreenState();
}

class _CarbonOffsetPledgeScreenState extends ConsumerState<CarbonOffsetPledgeScreen> {
  double _transportKm = 15.0;
  double _electricityKwh = 250.0;
  int _treesPledged = 5;

  double get _totalCo2Tons {
    final transportEmission = _transportKm * 0.21 * 365 / 1000;
    final electricityEmission = _electricityKwh * 0.45 * 12 / 1000;
    return transportEmission + electricityEmission;
  }

  void _submitPledge() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pledge Recorded! 🌳'),
        content: Text('Thank you! You have pledged to plant $_treesPledged trees and offset ${_totalCo2Tons.toStringAsFixed(2)} tons of carbon. You unlocked the "Master Reforester 🌳" badge!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carbon offset pledge successfully saved! 🌱'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Awesome'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Offset & Tree Pledge 🌳'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Icon(Icons.forest_rounded, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Estimated Annual Footprint',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_totalCo2Tons.toStringAsFixed(2)} Tons CO₂',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Offset needed: ${(_totalCo2Tons * 25).round()} trees',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Daily Commute / Transport (km / day)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Slider(
            value: _transportKm,
            min: 1.0,
            max: 100.0,
            divisions: 99,
            activeColor: AppColors.primary,
            label: '${_transportKm.round()} km',
            onChanged: (val) => setState(() => _transportKm = val),
          ),
          Text('${_transportKm.round()} km daily average', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          const Text('Monthly Electricity Usage (kWh)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Slider(
            value: _electricityKwh,
            min: 50.0,
            max: 1000.0,
            divisions: 19,
            activeColor: AppColors.primary,
            label: '${_electricityKwh.round()} kWh',
            onChanged: (val) => setState(() => _electricityKwh = val),
          ),
          Text('${_electricityKwh.round()} kWh monthly average', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          const Text('Trees to Pledge Planting', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 32, color: AppColors.primary),
                onPressed: () {
                  if (_treesPledged > 1) setState(() => _treesPledged--);
                },
              ),
              const SizedBox(width: 16),
              Text('$_treesPledged Trees', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, size: 32, color: AppColors.primary),
                onPressed: () => setState(() => _treesPledged++),
              ),
            ],
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Make Green Carbon Pledge'),
            onPressed: _submitPledge,
          ),
        ],
      ),
    );
  }
}
