import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OfflineBannerWidget extends StatelessWidget {
  final bool isOffline;
  const OfflineBannerWidget({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: AppColors.warning,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'You are offline. Showing cached saved items.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
