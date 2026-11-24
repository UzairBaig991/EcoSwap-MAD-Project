import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class QuietHoursSchedulerScreen extends ConsumerStatefulWidget {
  const QuietHoursSchedulerScreen({super.key});

  @override
  ConsumerState<QuietHoursSchedulerScreen> createState() => _QuietHoursSchedulerScreenState();
}

class _QuietHoursSchedulerScreenState extends ConsumerState<QuietHoursSchedulerScreen> {
  bool _quietHoursEnabled = true;
  TimeOfDay _startTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Quiet Hours 🌙'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: const Column(
              children: [
                Icon(Icons.bedtime_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text(
                  'Distraction-Free Quiet Schedule',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Silence chat alerts and swap notifications during night time or work hours so EcoSwap never disturbs you.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          SwitchListTile(
            value: _quietHoursEnabled,
            title: const Text('Enable Daily Quiet Hours Schedule'),
            subtitle: const Text('Automatically mutes push alerts between set hours'),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _quietHoursEnabled = val),
          ),
          const SizedBox(height: 16),

          if (_quietHoursEnabled) ...[
            ListTile(
              leading: const Icon(Icons.access_time_rounded, color: AppColors.primary),
              title: const Text('Quiet Hours Start'),
              trailing: Text(_startTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _startTime);
                if (picked != null) setState(() => _startTime = picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined, color: AppColors.secondary),
              title: const Text('Quiet Hours End'),
              trailing: Text(_endTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _endTime);
                if (picked != null) setState(() => _endTime = picked);
              },
            ),
          ],
          const SizedBox(height: 28),

          ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Quiet Schedule Settings'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiet hours schedule saved! Enjoy peaceful notification management. 🌙'),
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
