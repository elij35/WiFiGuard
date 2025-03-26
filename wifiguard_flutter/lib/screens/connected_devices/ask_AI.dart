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

  @override
  void initState() {
    super.initState();
    _fetchAIResponseForPorts();
  }

  void _fetchAIResponseForPorts() async {
    if (widget.ports.isEmpty) return;
    setState(() => _isLoading = true);

    String response = await GeminiService.getPortInfo(widget.ports);
    setState(() {
      _aiResponse = response;
      _isLoading = false;
    });
  }

  void _fetchAIResponseForQuery() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "Fetching response...";
    });

    String response = await GeminiService.askQuestion(query);
    setState(() {
      _aiResponse = response;
      _isLoading = false;
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
            // AI Response Section
            const Text(
              "AI Response:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _aiResponse,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
            ),
            // Search Box
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Ask AI about networking or computing",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _fetchAIResponseForQuery,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (_) => _fetchAIResponseForQuery(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
