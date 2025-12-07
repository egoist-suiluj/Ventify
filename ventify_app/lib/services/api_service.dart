// File: lib/services/api_service.dart

import 'dart:convert';
import 'dart:developer'; // Para makita natin ang logs sa debug console
import 'package:http/http.dart' as http;
import 'package:ventify_app/constants/api_config.dart';

class ApiService {
  // Function para mag-send ng message kay Ventify
  Future<String> sendMessage({
    required String message,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chatEndpoint}');

      log('Sending message to: $url'); // Debug log

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message, 'history': history}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Pasensya na, hindi ko naintindihan.';
      } else {
        log('Error Status: ${response.statusCode}');
        log('Error Body: ${response.body}');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Connection Error: $e');
      throw Exception('Failed to connect to Ventify. Check your internet.');
    }
  }

  // Pang-check kung gising ang server
  Future<bool> checkHealth() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.healthEndpoint}');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      log('Health Check Failed: $e');
      return false;
    }
  }
}
