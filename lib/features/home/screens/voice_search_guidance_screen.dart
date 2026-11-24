import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class VoiceSearchGuidanceScreen extends ConsumerStatefulWidget {
  const VoiceSearchGuidanceScreen({super.key});

  @override
  ConsumerState<VoiceSearchGuidanceScreen> createState() => _VoiceSearchGuidanceScreenState();
}

class _VoiceSearchGuidanceScreenState extends ConsumerState<VoiceSearchGuidanceScreen> {
  bool _isListening = false;
  String _recognizedText = 'Listening... Say "Find free acoustic guitar nearby"';

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _recognizedText = '🎙️ "Looking for free vintage cameras within 5 km..."';
      } else {
        _recognizedText = 'Voice Search Ready. Tap mic to speak!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Search & Guidance 🎙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.darkShadeGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.cardShadingShadows,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isListening ? AppColors.amberGradient : AppColors.ecoGradient,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.amber : AppColors.primaryLight).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(_isListening ? Icons.mic_rounded : Icons.mic_none_rounded, size: 56, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _recognizedText,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Voice Command Examples', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          _buildExampleTile(theme, '"Find free wooden chairs near me"', 'Searches local free category listings'),
          _buildExampleTile(theme, '"Show nearby e-waste recycling hubs"', 'Opens recycling drop-off map'),
          _buildExampleTile(theme, '"Open my carbon passport certificate"', 'Launches impact passport screen'),
        ],
      ),
    );
  }

  Widget _buildExampleTile(ThemeData theme, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadingShadows,
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.record_voice_over_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
