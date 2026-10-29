import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAIService {
  static String? _apiKey;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('openai_api_key');
  }

  static Future<void> setApiKey(String key) async {
    _apiKey = key.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('openai_api_key', _apiKey!);
  }

  static String? get apiKey => _apiKey;

  static Future<String> getEcoBotReply(String userMessage, List<Map<String, String>> history) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _getLocalFallbackReply(userMessage);
    }

    try {
      final url = Uri.parse('https://api.openai.com/v1/chat/completions');

      final messages = [
        {
          'role': 'system',
          'content': 'You are EcoBot, an expert, friendly AI assistant for EcoSwap, a hyperlocal sustainable marketplace mobile app. You help users with recycling tips, carbon footprint calculations, swapping items, app navigation, and general eco-friendly advice.'
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
          'max_tokens': 300,
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
    if (q.contains('co2') || q.contains('carbon') || q.contains('saved')) {
      return '🌿 Based on your activity, you have saved approximately 142 kg of CO₂ emissions this month! That is equivalent to planting 6 mature trees.';
    } else if (q.contains('swap') || q.contains('how')) {
      return '🔄 To swap an item: 1. Tap "Post New Item" in the bottom bar. 2. Upload photos and set type to "Swap". 3. Browse nearby listings and chat with owners to propose a direct item trade!';
    } else if (q.contains('free') || q.contains('nearby')) {
      return '📍 You can find free items by tapping the Explore tab and selecting the "Free" filter chip or switching to the Map view to see items within your radius!';
    } else if (q.contains('point') || q.contains('score')) {
      return '⭐ You earn 50 Eco Points for every completed swap or giveaway! Points help you rank up on the City Leaderboard and unlock Eco Champion badges.';
    } else {
      return '🌱 EcoSwap empowers local communities to reuse items, reduce landfill waste, and track real-time carbon savings. (Tip: Enter your OpenAI API key in EcoBot settings for live GPT-3.5 AI answers to any question!)';
    }
  }
}
