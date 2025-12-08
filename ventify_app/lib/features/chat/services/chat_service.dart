// File: lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventify_app/constants/api_config.dart';

class ChatService {
  // 1. WAKE UP FUNCTION (Ito ang kulang kaya nag-e-error)
  Future<bool> wakeUp() async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthEndpoint}');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 2. SEND MESSAGE FUNCTION
  Future<String> sendMessage({
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chatEndpoint}');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': message,
              'history': history,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to get response');
      }
    } catch (e) {
      throw Exception('Connection error');
    }
  }
}
