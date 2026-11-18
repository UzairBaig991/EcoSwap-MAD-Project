import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class EcoHandoffChecklistScreen extends ConsumerStatefulWidget {
  const EcoHandoffChecklistScreen({super.key});

  @override
  ConsumerState<EcoHandoffChecklistScreen> createState() => _EcoHandoffChecklistScreenState();
}

class _EcoHandoffChecklistScreenState extends ConsumerState<EcoHandoffChecklistScreen> {
  bool _step1Checked = false;
  bool _step2Checked = false;
  bool _step3Checked = false;
  bool _step4Checked = false;

  bool get _isAllCompleted => _step1Checked && _step2Checked && _step3Checked && _step4Checked;

  void _completeHandoff() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Handoff Verified! 🤝'),
        content: const Text('Congratulations! Both swappers verified the item condition and completed the zero-waste exchange. +50 Eco Points awarded!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item exchange verified & carbon points recorded! 🌱'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Finish'),
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
        title: const Text('Zero-Waste Handoff Checklist 📋'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.ecoGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.fact_check_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Exchange Protocol',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Complete these 4 verification steps with your swap partner at the public meeting location.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          CheckboxListTile(
            value: _step1Checked,
            title: const Text('1. Meet in a public, well-lit safe area'),
            subtitle: const Text('Public library, community center, or eco-hub'),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _step1Checked = val ?? false),
          ),
          CheckboxListTile(
            value: _step2Checked,
            title: const Text('2. Inspect physical item condition'),
            subtitle: const Text('Ensure item matches description and photos'),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _step2Checked = val ?? false),
          ),
          CheckboxListTile(
            value: _step3Checked,
            title: const Text('3. Verify plastic-free eco packaging'),
            subtitle: const Text('Direct handshake or reusable cloth wrap'),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _step3Checked = val ?? false),
          ),
          CheckboxListTile(
            value: _step4Checked,
            title: const Text('4. Scan QR Handoff Verification Code'),
            subtitle: const Text('Confirm physical exchange on mobile'),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _step4Checked = val ?? false),
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Finalize Verified Exchange'),
            onPressed: _isAllCompleted ? _completeHandoff : null,
          ),
        ],
      ),
    );
  }
}
