import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class SmartExchangePlannerScreen extends ConsumerStatefulWidget {
  const SmartExchangePlannerScreen({super.key});

  @override
  ConsumerState<SmartExchangePlannerScreen> createState() => _SmartExchangePlannerScreenState();
}

class _SmartExchangePlannerScreenState extends ConsumerState<SmartExchangePlannerScreen> {
  String _selectedLocation = 'City Central Library Public Lobby';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);

  final List<String> _publicLocations = [
    'City Central Library Public Lobby',
    'Greenwich Park Main Entrance',
    'Metro Station Community Square',
    'University Student Union Cafe',
  ];

  void _confirmExchange() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exchange Planned! 🤝'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('A secure exchange session has been scheduled with meeting checklists and QR code verification.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.qr_code_2_rounded, size: 80, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text('Scan to Confirm Exchange', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exchange successfully saved to calendar! 🌱'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Done'),
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
        title: const Text('Smart Exchange Planner 🗓️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Plan a Safe Public Exchange',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Select a mutually agreed public meeting location, date, and time to complete your swap safely.',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Public Meeting Location Selection
          const Text('Public Meeting Location', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined)),
            items: _publicLocations.map((loc) {
              return DropdownMenuItem(value: loc, child: Text(loc));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedLocation = val);
            },
          ),
          const SizedBox(height: 20),

          // Date & Time
          const Text('Meeting Date & Time', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (date != null) setState(() => _selectedDate = date);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.access_time_rounded, size: 18),
                  label: Text(_selectedTime.format(context)),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (time != null) setState(() => _selectedTime = time);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Exchange Checklist
          const Text('Exchange Safety Checklist', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CheckboxListTile(
            title: const Text('Meet in a well-lit public location'),
            value: true,
            onChanged: (_) {},
          ),
          CheckboxListTile(
            title: const Text('Inspect the item thoroughly before confirming'),
            value: true,
            onChanged: (_) {},
          ),
          CheckboxListTile(
            title: const Text('Generate QR verification code upon meeting'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded),
            label: const Text('Confirm Exchange Session'),
            onPressed: _confirmExchange,
          ),
        ],
      ),
    );
  }
}
