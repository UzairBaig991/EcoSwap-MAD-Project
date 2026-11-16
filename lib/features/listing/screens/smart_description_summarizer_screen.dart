import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class SmartDescriptionSummarizerScreen extends ConsumerStatefulWidget {
  const SmartDescriptionSummarizerScreen({super.key});

  @override
  ConsumerState<SmartDescriptionSummarizerScreen> createState() => _SmartDescriptionSummarizerScreenState();
}

class _SmartDescriptionSummarizerScreenState extends ConsumerState<SmartDescriptionSummarizerScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _generatedSummary = '';
  final List<String> _hashtags = ['#ZeroWaste', '#PreLoved', '#EcoSwap', '#CircularLiving', '#SustainableChoice'];

  void _generateSummary() {
    if (_inputController.text.trim().isEmpty) return;
    setState(() {
      _generatedSummary = '✨ AI Summary: High quality pre-loved item in great condition. Ready for a sustainable new home! Diverts ~12.5kg CO₂ emissions.';
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Description Summarizer 🪄'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'AI Listing Description Magic',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Paste raw details about your item and AI will generate an attractive, concise description with eco hashtags.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'e.g. Wooden study chair bought 1 year ago, minor scratches on legs, sturdy frame...',
              prefixIcon: Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.auto_fix_high_rounded),
            label: const Text('Generate AI Description'),
            onPressed: _generateSummary,
          ),
          const SizedBox(height: 24),

          if (_generatedSummary.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: Text(
                _generatedSummary,
                style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Suggested Eco Hashtags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _hashtags.map((tag) => Chip(
                label: Text(tag, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                backgroundColor: AppColors.primaryContainer,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
