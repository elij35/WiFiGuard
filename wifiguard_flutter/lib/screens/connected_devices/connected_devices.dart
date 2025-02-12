import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  String _scanResult = '';

  Future<void> _runScan(String target) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/scan'), // Connect to local backend
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'target': target}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _scanResult = json.decode(response.body)['scan_result'];
      });
    } else {
      setState(() {
        _scanResult = 'Failed to scan target';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Vulnerability Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _runScan('192.168.0.1'),
              child: Text('Start Scan'),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(_scanResult))),
          ],
        ),
      ),
    );
  }
}
