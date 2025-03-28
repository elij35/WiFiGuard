import 'package:WiFiGuard/services/gemini_service.dart';
import 'package:flutter/material.dart';

class DeviceDetailsAiScreen extends StatefulWidget {
  final List<String> ports;

  const DeviceDetailsAiScreen({Key? key, required this.ports}) : super(key: key);

  @override
  _DeviceDetailsAiScreenState createState() => _DeviceDetailsAiScreenState();
}

class _DeviceDetailsAiScreenState extends State<DeviceDetailsAiScreen> {
  List<String> _chatHistory = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // For scrolling to new responses

  @override
  void initState() {
    super.initState();
    if (widget.ports.isNotEmpty) {
      _chatHistory.add("List of open ports:\n${widget.ports.join('\n')}");
      _fetchAIResponseForPorts();
    }
  }

  // Fetch AI-generated info about the detected open ports
  void _fetchAIResponseForPorts() async {
    if (widget.ports.isEmpty) return; // No ports, nothing to analyse
    setState(() => _isLoading = true);

    String context = _chatHistory.join("\n");
    String response = await GeminiService.getPortInfo(widget.ports, context: context);

    setState(() {
      _chatHistory.add("AI:\n$response");
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
      _chatHistory.add("You:\n$query");
      _searchController.clear();
    });

    String context = _chatHistory.join("\n");
    String response = await GeminiService.askQuestion(query.trim(), context: context);

    setState(() {
      _chatHistory.add("AI:\n$response");
      _isLoading = false;
    });

    _scrollToBottom(); // Scroll down to new response
  }

  // Automatically scrolls to the bottom when a new response is loaded
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Details AI")),
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
                  ? const Center(child: CircularProgressIndicator())
                  : Scrollbar(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _chatHistory.map((message) => Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SelectableText(
                          message,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    )).toList(),
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
