// File: lib/features/chat/services/chat_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventify_app/constants/api_config.dart';

class ChatService {
  // 1. Function para gisingin ang server (Health Check)
  Future<void> wakeUp() async {
    // Siguraduhing tama ang URL format
    final healthUrl =
        Uri.parse(ApiConfig.baseUrl).replace(path: ApiConfig.healthEndpoint);

    try {
      print("Waking up server at: $healthUrl");
      await http
          .get(healthUrl)
          .timeout(const Duration(seconds: 30)); // 30s Timeout
    } catch (e) {
      print("Wake up error: $e");
    }
  }

  // 2. Function para mag-send ng message sa AI
  Future<String> sendMessage({
    required String message,
    required List<Map<String, dynamic>> history,
    String? userGender,
  }) async {
    // Siguraduhing tama ang URL format
    final chatUrl =
        Uri.parse(ApiConfig.baseUrl).replace(path: ApiConfig.chatEndpoint);

    final Map<String, dynamic> bodyMap = {
      'history': history,
      'message': message,
    };

    if (userGender != null) {
      bodyMap['user_gender'] = userGender;
    }

    try {
      print("Sending message to: $chatUrl");

      final response = await http
          .post(
            chatUrl,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(bodyMap),
          )
          .timeout(const Duration(seconds: 45)); // 45s Timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Connection Error: $e");
      throw Exception(
          'Connection failed. Please check your internet or try again later.');
    }
  }
}
