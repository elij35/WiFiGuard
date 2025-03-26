import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "";
  static const String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey";

  // Fetch port info (Short & Concise)
  static Future<String> getPortInfo(List<String> ports) async {
    if (ports.isEmpty) return "No open ports detected.";

    String query =
        "For each of these ports: ${ports.join(', ')}, provide a short description (10 words max) and a security risk warning (10 words max). Keep it concise.";

    return _fetchAIResponse(query);
  }

  // Fetch AI response for user questions
  static Future<String> askQuestion(String question) async {
    String query =
        "Answer concisely: $question. Limit response to 2 sentences.";

    return _fetchAIResponse(query);
  }

  // Common AI request function
  static Future<String> _fetchAIResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": query}
              ]
            }
          ]
        }),
      );

      // If the response if successful (200) then return the AI message
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String rawResponse = data['candidates'][0]['content']['parts'][0]['text'].trim();

        // Remove asterisks and unnecessary line breaks
        String cleanedResponse = rawResponse.replaceAll("*", "").trim();

        return cleanedResponse;
      } else {
        return "Failed to get AI response. Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error connecting to AI: $e";
    }
  }
}
