import 'package:WiFiGuard/services/gemini_service.dart';
import 'package:flutter/material.dart';

class HelpAndGuidanceAIScreen extends StatefulWidget {
  const HelpAndGuidanceAIScreen({Key? key}) : super(key: key);

  @override
  _HelpAndGuidanceAIScreenState createState() =>
      _HelpAndGuidanceAIScreenState();
}

class _HelpAndGuidanceAIScreenState extends State<HelpAndGuidanceAIScreen> {
  List<String> _chatHistory = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatHistory.add(
        "AI: \nAsk me anything about network security and best practices.");
  }

  void _fetchAIResponseForQuery() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _chatHistory.add("You: \n$query");
      _searchController.clear();
    });

    String context = _chatHistory.join("\n");
    String response = await GeminiService.askQuestion(query, context: context);

    setState(() {
      _chatHistory.add("AI: \n$response");
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Help and Guidance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI Response:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Scrollbar(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _chatHistory
                              .map((message) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SelectableText(
                                        message,
                                        style: const TextStyle(
                                            fontSize: 16, height: 1.5),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Ask AI about networking or computing",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _fetchAIResponseForQuery,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _fetchAIResponseForQuery(),
            ),
          ],
        ),
      ),
    );
  }
}
