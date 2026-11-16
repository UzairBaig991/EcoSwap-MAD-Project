import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EcoCelebrationDialog extends StatelessWidget {
  final String title;
  final String message;
  final int pointsEarned;
  final double co2SavedKg;

  const EcoCelebrationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.pointsEarned,
    required this.co2SavedKg,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    int pointsEarned = 50,
    double co2SavedKg = 12.5,
  }) {
    showDialog(
      context: context,
      builder: (context) => EcoCelebrationDialog(
        title: title,
        message: message,
        pointsEarned: pointsEarned,
        co2SavedKg: co2SavedKg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.ecoGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatTile('+$pointsEarned Points', Icons.stars_rounded, Colors.amber),
                _buildStatTile('~$co2SavedKg kg CO₂', Icons.eco_rounded, AppColors.primary),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Awesome! 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
        ],
      ),
    );
  }
}
