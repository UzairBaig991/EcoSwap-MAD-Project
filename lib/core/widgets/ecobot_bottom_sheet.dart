import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../network/openai_service.dart';

class EcoBotBottomSheet extends ConsumerStatefulWidget {
  const EcoBotBottomSheet({super.key});

  @override
  ConsumerState<EcoBotBottomSheet> createState() => _EcoBotBottomSheetState();
}

class _EcoBotBottomSheetState extends ConsumerState<EcoBotBottomSheet> {
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'text': 'Hello! I am EcoBot 🤖, your AI sustainability & swap assistant. Ask me anything about recycling, carbon footprints, or using EcoSwap!'
    }
  ];

  bool _isTyping = false;

  final List<String> _quickPrompts = [
    'How much CO₂ have I saved?',
    'How do I swap an item?',
    'Where are nearby free items?',
    'What are Eco Points?',
  ];

  @override
  void initState() {
    super.initState();
    OpenAIService.init();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _handleUserQuery(String query) async {
    if (query.trim().isEmpty || _isTyping) return;

    final userText = query.trim();
    _queryController.clear();

    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _isTyping = true;
    });

    try {
      final reply = await OpenAIService.getEcoBotReply(userText, _messages);
      if (!mounted) return;
      setState(() {
        _messages.add({'sender': 'bot', 'text': reply});
        _isTyping = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': '🌱 I encountered a network issue, but I am still here to help with your sustainability goals!'
        });
        _isTyping = false;
      });
    }
  }

  void _showApiKeyDialog() {
    final TextEditingController keyController = TextEditingController(text: OpenAIService.apiKey ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configure OpenAI API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your OpenAI API Key to enable live GPT-3.5 AI responses for any question:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'OpenAI API Key',
                hintText: 'sk-...',
                prefixIcon: Icon(Icons.key_rounded),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await OpenAIService.setApiKey(keyController.text.trim());
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('OpenAI API Key saved successfully! 🔑'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Save Key'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle & Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: AppColors.impactGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EcoBot AI Assistant',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    OpenAIService.apiKey != null && OpenAIService.apiKey!.isNotEmpty
                        ? 'Powered by OpenAI GPT-3.5 ⚡'
                        : 'Smart Offline Mode (Tap key for OpenAI)',
                    style: TextStyle(fontSize: 11.5, color: theme.colorScheme.primary),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.key_rounded),
                tooltip: 'Configure OpenAI API Key',
                onPressed: _showApiKeyDialog,
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 24),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isBot = msg['sender'] == 'bot';

                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isBot ? theme.colorScheme.surfaceContainerHighest : AppColors.primary,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
                        bottomRight: !isBot ? const Radius.circular(0) : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isBot ? theme.textTheme.bodyLarge?.color : Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isTyping) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('EcoBot is thinking...', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],

          // Quick Prompt Chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _quickPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 11.5)),
                    backgroundColor: AppColors.primaryContainer,
                    onPressed: () => _handleUserQuery(prompt),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Input Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _queryController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _handleUserQuery,
                  decoration: InputDecoration(
                    hintText: 'Ask EcoBot anything...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  onPressed: () => _handleUserQuery(_queryController.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
