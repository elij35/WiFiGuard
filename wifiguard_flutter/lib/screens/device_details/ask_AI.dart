import 'package:WiFiGuard/services/gemini_service.dart';
import 'package:flutter/material.dart';

class AskAIScreen extends StatefulWidget {
  final List<String> ports;

  const AskAIScreen({Key? key, required this.ports}) : super(key: key);

  @override
  _AskAIScreenState createState() => _AskAIScreenState();
}

class _AskAIScreenState extends State<AskAIScreen> {
  String _aiResponse = "Ask AI anything about networking or computing.";
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // For scrolling to new responses

  @override
  void initState() {
    super.initState();
    _fetchAIResponseForPorts(); // Fetch port details when screen loads
  }

  // Fetch AI-generated info about the detected open ports
  void _fetchAIResponseForPorts() async {
    if (widget.ports.isEmpty) return; // No ports, nothing to analyse
    setState(() => _isLoading = true);

    String response = await GeminiService.getPortInfo(widget.ports);
    setState(() {
      _aiResponse = response;
      _isLoading = false;
    });

    _scrollToBottom(); // Scroll down to display new response
  }

  // Fetch AI response based on user's custom query
  void _fetchAIResponseForQuery() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return; // Don't send empty queries

    setState(() {
      _isLoading = true;
      _aiResponse = "Fetching response..."; // Temporary message
      _searchController.clear(); // Clear text field after submitting
    });

    String response = await GeminiService.askQuestion(query);
    setState(() {
      _aiResponse = response;
      _isLoading = false;
    });

    _scrollToBottom(); // Scroll down to new response
  }

  // Automatically scrolls to the bottom when a new response is loaded
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
      appBar: AppBar(title: const Text("Ask AI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Response section header
            const Text(
              "AI Response:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // AI response section body
            Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading spinner
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
                              _aiResponse, // Display AI response here
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // Search box for custom AI questions
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
              onSubmitted: (_) =>
                  _fetchAIResponseForQuery(), // Allows pressing 'Enter' to send
            ),
          ],
        ),
      ),
    );
  }
}
