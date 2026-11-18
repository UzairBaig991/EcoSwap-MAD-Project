import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class CarbonCertificateScreen extends ConsumerWidget {
  const CarbonCertificateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Official Carbon Certificate 📜'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.verified_user_rounded, size: 60, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'CERTIFICATE OF ECO IMPACT',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 24, color: AppColors.primary),
                const SizedBox(height: 8),
                const Text(
                  'This certifies that',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'EcoSwap Member',
                  style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'has successfully offset 142 kg of CO₂ emissions and diverted 6 items from landfills through circular community exchanges.',
                  style: TextStyle(color: Colors.black87, fontSize: 13.5, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VERIFIED DATE', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold)),
                        Text('Nov 2026', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, size: 40, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Verified Passport PDF'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carbon Impact Certificate downloaded! 📜'),
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
