import 'package:WiFiGuard/services/gemini_service.dart';
import 'package:flutter/material.dart';

class HelpAndGuidanceAIScreen extends StatefulWidget {
  const HelpAndGuidanceAIScreen({Key? key}) : super(key: key);

  @override
  _HelpAndGuidanceAIScreenState createState() =>
      _HelpAndGuidanceAIScreenState();
}

class _HelpAndGuidanceAIScreenState extends State<HelpAndGuidanceAIScreen> {
  String _aiResponse =
      "Ask AI anything about network security and best practices.";
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _fetchAIResponseForQuery() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "Fetching response...";
      _searchController.clear();
    });

    String response = await GeminiService.askQuestion(query);
    setState(() {
      _aiResponse = response;
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
      appBar: AppBar(title: const Text("AI Help & Guidance")),
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
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SelectableText(
                              _aiResponse,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Ask AI about network security or setup",
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
