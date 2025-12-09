// File: lib/features/chat/services/chat_service.dart (FINAL WORKING API CODE)

import 'dart:async'; // Para sa Timeout
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventify_app/constants/api_config.dart'; // ✅ Ating API Config

class ChatService {
  Future<void> wakeUp() async {
    final healthUrl =
        ApiConfig.baseUrl + ApiConfig.healthEndpoint; // 🚨 FIXED URL
    try {
      await http
          .get(Uri.parse(healthUrl))
          .timeout(ApiConfig.connectionTimeout); // ✅ Gumamit ng Duration
    } catch (e) {
      // Ignore error, server might be asleep
    }
  }

  Future<String> sendMessage(
      {required String message,
      required List<Map<String, dynamic>> history}) async {
    final chatUrl = ApiConfig.baseUrl + ApiConfig.chatEndpoint; // 🚨 FIXED URL

    final response = await http
        .post(
          Uri.parse(chatUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'history': history,
            'message': message,
          }),
        )
        .timeout(ApiConfig.connectionTimeout); // ✅ Gumamit ng Duration

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] as String;
    } else {
      // 🚨 Para makita mo ang server error status code
      throw Exception('Failed to load response: ${response.statusCode}');
    }
  }
}
