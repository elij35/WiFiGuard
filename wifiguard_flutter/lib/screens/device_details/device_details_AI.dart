import 'package:WiFiGuard/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDetailsAiScreen extends StatefulWidget {
  final List<String> ports;
  final String deviceIp;

  const DeviceDetailsAiScreen(
      {Key? key, required this.ports, required this.deviceIp})
      : super(key: key);

  @override
  _DeviceDetailsAiScreenState createState() => _DeviceDetailsAiScreenState();
}

class _DeviceDetailsAiScreenState extends State<DeviceDetailsAiScreen> {
  List<String> _chatHistory = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // For scrolling to new responses
  final String _prefsKeyPrefix =
      'device_ai_chat'; // Prefix for shared prefs keys

  String get _prefsKey =>
      '${_prefsKeyPrefix}${widget.deviceIp}'; // Creates a unique key for each device

  @override
  void initState() {
    super.initState();
    _loadChatHistory().then((_) {
      if (widget.ports.isNotEmpty && _chatHistory.isEmpty) {
        // Only asks AI about ports if this is a new AI chat for this device (otherwise grabs previous response from shared preferences)
        _askAboutPorts();
      }
    });
  }

  // Loads chat history of the current device from shared preferences
  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList(_prefsKey);
    if (savedHistory != null) {
      setState(() {
        _chatHistory = savedHistory;
      });
    }
  }

  // Saves any AI responses or user messages into shared preferences using the IP address as the custom key
  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _chatHistory);
  }

  // Option in top right of screen to clear the chat history
  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    setState(() {
      _chatHistory = [];
    });
  }

  // Ask about ports for the device clicked on
  void _askAboutPorts() async {
    if (widget.ports.isEmpty) return;

    setState(() => _isLoading = true);
    _chatHistory.add(
        "You:\nTell me what these ports do and their risks when open: \n\n${widget
            .ports.join('\n')}");
    _saveChatHistory();

    // Process each port individually but include all ports in context
    try {
      final response = await GeminiService.getPortInfo(widget.ports);
      setState(() {
        _chatHistory.add("AI:\n$response");
        _saveChatHistory();
      });
    } catch (e) {
      setState(() {
        _chatHistory.add("AI:\nFailed to get port information");
        _saveChatHistory();
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  // Fetch AI response based on user's custom query
  void _fetchAIResponseForQuery() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return; // Don't send empty queries

    setState(() {
      _isLoading = true;
      _chatHistory.add("You:\n$query");
      _searchController.clear();
      _saveChatHistory();
    });

    // Include the entire chat history as context
    String context = _chatHistory.join("\n");
    String response = await GeminiService.askQuestion(
      "Regarding device ${widget.deviceIp}: $query",
      context: context, // Pass the full chat history as context
    );

    setState(() {
      _chatHistory.add("AI:\n$response");
      _isLoading = false;
      _saveChatHistory();
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
      appBar: AppBar(
        title: Text("${widget.deviceIp} Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearChatHistory,
            tooltip: 'Clear chat history',
          ),
        ],
      ),
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
                          children: _chatHistory
                              .map((message) => Card(
                                    elevation: 4,
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

            // Search box for custom AI questions
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Ask about ${widget.deviceIp}",
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
