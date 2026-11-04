import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAIService {
  static String? _apiKey;

  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _apiKey = prefs.getString('openai_api_key');
    } catch (_) {}
  }

  static Future<void> setApiKey(String key) async {
    _apiKey = key.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('openai_api_key', _apiKey!);
    } catch (_) {}
  }

  static String? get apiKey => _apiKey;

  static Future<String> getEcoBotReply(String userMessage, List<Map<String, String>> history) async {
    // Always load fresh API key from SharedPreferences to ensure instant recognition
    try {
      final prefs = await SharedPreferences.getInstance();
      _apiKey = prefs.getString('openai_api_key');
    } catch (_) {}

    if (_apiKey == null || _apiKey!.trim().isEmpty) {
      return _getLocalFallbackReply(userMessage);
    }

    try {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');

      final messages = [
        {
          'role': 'system',
          'content': 'You are EcoBot, an expert, friendly AI assistant for EcoSwap, a hyperlocal sustainable marketplace mobile app. You help users with recycling tips, carbon footprint calculations, swapping items, app navigation, and general eco-friendly advice. Always answer any question asked by the user directly and helpfully.'
        },
        ...history.map((m) => {
          'role': m['sender'] == 'user' ? 'user' : 'assistant',
          'content': m['text'] ?? ''
        }),
        {
          'role': 'user',
          'content': userMessage
        }
      ];

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'max_tokens': 400,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'].toString().trim();
        return reply;
      } else {
        return _getLocalFallbackReply(userMessage);
      }
    } catch (_) {
      return _getLocalFallbackReply(userMessage);
    }
  }

  static String _getLocalFallbackReply(String query) {
    final q = query.toLowerCase();
    if (q.contains('how are you') || q.contains('hello') || q.contains('hi') || q.contains('hey')) {
      return 'Hello! I am doing great and ready to help you with anything related to sustainable living, recycling, or EcoSwap! How can I assist you today? 🌿';
    } else if (q.contains('who are you') || q.contains('what are you')) {
      return 'I am EcoBot 🤖, your AI sustainability and swap assistant for EcoSwap. I can help you with recycling tips, carbon footprint tracking, finding nearby items, and general questions!';
    } else if (q.contains('new') || q.contains('how to use') || q.contains('app') || q.contains('start')) {
      return 'Welcome to EcoSwap! 🎉 To get started: 1. Explore nearby free or swap items on the Home tab. 2. Tap "Post New Item" to list anything you want to give away or trade. 3. Use the Chat tab to talk with local neighbors and complete sustainable swaps!';
    } else if (q.contains('co2') || q.contains('carbon') || q.contains('saved')) {
      return '🌿 Based on your activity, you have saved approximately 142 kg of CO₂ emissions this month! That is equivalent to planting 6 mature trees.';
    } else if (q.contains('swap') && (q.contains('how') || q.contains('item'))) {
      return '🔄 To swap an item: 1. Tap "Post New Item" in the bottom bar. 2. Upload photos and set type to "Swap". 3. Browse nearby listings and chat with owners to propose a direct item trade!';
    } else if (q.contains('free') || q.contains('nearby') || q.contains('find')) {
      return '📍 You can find free items by tapping the Explore tab and selecting the "Free" filter chip or switching to the Map view to see items within your radius!';
    } else if (q.contains('point') || q.contains('score')) {
      return '⭐ You earn 50 Eco Points for every completed swap or giveaway! Points help you rank up on the City Leaderboard and unlock Eco Champion badges.';
    } else {
      return '🌱 Regarding "$query": EcoSwap and sustainable living practices encourage reducing waste, reusing materials, and building community connections. Feel free to ask about recycling, swapping, carbon credits, or any other topic! (Tip: If your OpenAI API key was not recognized, please tap the 🔑 key icon in the top right to re-enter and save your key).';
    }
  }
}
