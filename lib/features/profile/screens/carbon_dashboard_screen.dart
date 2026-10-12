import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/carbon_calculator.dart';
import '../../../core/utils/formatters.dart';
import '../../auth/providers/auth_provider.dart';

class CarbonDashboardScreen extends ConsumerWidget {
  const CarbonDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserModelProvider).asData?.value;
    final totalCo2 = user?.totalCo2Saved ?? 0.0;

    final trees = CarbonCalculator.calculateTreeEquivalent(totalCo2);
    final carKm = CarbonCalculator.calculateCarKmAvoided(totalCo2);
    final charges = CarbonCalculator.calculateSmartphoneCharges(totalCo2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Carbon Footprint Impact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main CO2 Highlight Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.eco_rounded, size: 56, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    AppFormatters.formatCo2(totalCo2),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Emissions Avoided Through EcoSwap',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Real-World Equivalents Header
            Text(
              'Your Environmental Equivalents',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Equivalent 1: Trees Planted
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.park_rounded, color: AppColors.primary, size: 28),
                ),
                title: Text(
                  '${trees.toStringAsFixed(1)} Trees Planted',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Annual carbon absorption of mature trees'),
              ),
            ),
            const SizedBox(height: 12),

            // Equivalent 2: Car Driving Avoided
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_car_rounded, color: AppColors.secondary, size: 28),
                ),
                title: Text(
                  '${carKm.toStringAsFixed(0)} km Car Driving Avoided',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Gasoline passenger vehicle tailpipe emissions'),
              ),
            ),
            const SizedBox(height: 12),

            // Equivalent 3: Phone Charges
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.battery_charging_full_rounded, color: AppColors.tertiary, size: 28),
                ),
                title: Text(
                  '${AppFormatters.formatDistance(charges.toDouble()).replaceAll(' away', '')} Phone Charges',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Equivalent electricity consumption saved'),
              ),
            ),
            const SizedBox(height: 28),

            // Category Benchmark Guide Table
            Text(
              'Category Emission Benchmarks',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'How much CO₂ you save when reusing items in each category:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: CarbonCalculator.categoryFactors.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.co2BadgeBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '~${entry.value} kg CO₂',
                            style: const TextStyle(
                              color: AppColors.co2Green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
