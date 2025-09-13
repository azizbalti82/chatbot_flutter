import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'llm_service.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

class GeminiService implements LlmService {
  GeminiService({this.model="gemini-2.0-flash",this.otherApiKey}) {
    if (apiKey.isEmpty) {
      throw Exception("GEMINI_API_KEY is not set in .env");
    }
  }

  String? otherApiKey;
  String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  String model = "";

  @override
  Future<String?> generateResponse({
    required String prompt,
    Map<String, dynamic>? options,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/models/$model:generateContent');
      print(url.path+" apikey:"+apiKey);

      final body = {
        "contents": [
          {"parts": [{"text": prompt}]}
        ]
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': otherApiKey ?? apiKey,
        },
        body: jsonEncode(body),
      );

      // If 200, try to extract content
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List<dynamic>?;

        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]?['content'];
          if (content != null) {
            final parts = content['parts'] as List<dynamic>? ?? [];
            final texts = parts.map((p) => p['text']?.toString() ?? '').join();
            debugPrint("✅ Extracted text: $texts");
            return texts.trim().isEmpty ? null : texts.trim();
          }
        }
        return null;
      }

      // For any non-200 response, just return null
      return null;
    } catch (e) {
      return null;
    }
  }

}
