import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "";
  static const String _apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey";

  // Fetch port info (On device_details screen)
  static Future<String> getPortInfo(List<String> ports,
      {String? context}) async {
    if (ports.isEmpty) return "No open ports detected.";

    String query = "For these ports: ${ports.join(', ')}, provide: "
    "1. Short description (5-10 words)"
    "2. Security risk level (Low/Medium/High/Critical)"
    "3. Brief explanation (10 words max)"
    "Then structure them as follows with a line gap between each: "
    "Description: "
    "Risk: "
    "Why it's an issue: ";

    if (context != null) {
      query = "Context:\n$context\n\nQuestion: $query";
    }

    return _fetchAIResponse(query);
  }

  // Fetch AI response for user questions
  static Future<String> askQuestion(String question, {String? context}) async {
    String query = "Question: $question\n\n"
        "Answer concisely (2-3 sentences max) and technically accurate. If it relates to something outside of the networking or computing scope DO NOT answer it.";

    if (context != null) {
      query = "Context:\n$context\n\n$query";
    }

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
        String rawResponse =
            data['candidates'][0]['content']['parts'][0]['text'].trim();

        // Removes asterisks and unnecessary line breaks
        return rawResponse.replaceAll("*", "").trim();
      } else {
        return "Failed to get AI response. Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error connecting to AI: $e";
    }
  }
}
