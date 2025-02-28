import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  List<Map<String, String>> _devices = [];
  bool _isLoading = false;
  bool _scanInProgress = false; // Flag to check scan status
  String _rawNmapOutput = ""; // Variable to store raw Nmap output

  // Function to initialize the app and load saved devices
  @override
  void initState() {
    super.initState();
    _loadSavedDevices();
  }

  // Load devices from SharedPreferences
  Future<void> _loadSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedDevices = prefs.getString('devices');
    if (savedDevices != null) {
      setState(() {
        _devices = List<Map<String, String>>.from(
          json
              .decode(savedDevices)
              .map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  // Save devices to SharedPreferences
  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String devicesJson = json.encode(_devices);
    await prefs.setString('devices', devicesJson);
  }

  // Function to initiate network scan
  Future<void> _runScan() async {
    setState(() {
      _isLoading = true;
      _scanInProgress = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/scan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'target': '192.168.0.1'}), // Example target
      );

      if (response.statusCode == 200) {
        // Get the raw Nmap output
        final List<dynamic> scanResult =
            json.decode(response.body)['scan_result'];

        setState(() {
          _devices = _parseNmapOutput(scanResult); // Parse the result
          _isLoading = false;
        });

        // Save the newly detected devices
        await _saveDevices();
      } else {
        throw Exception(
            "Failed to scan network, Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _devices = [];
        _isLoading = false;
      });
      _showErrorDialog("Scan failed: $e");
    } finally {
      setState(() {
        _scanInProgress = false;
      });
    }
  }

  List<Map<String, String>> _parseNmapOutput(List<dynamic> output) {
    List<Map<String, String>> devices = [];

    for (var deviceInfo in output) {
      String ip = deviceInfo['ip'] ?? "Unknown IP";
      String mac = deviceInfo['mac'] ?? "Unknown MAC";
      String os = deviceInfo['os'] ?? "Unknown OS";
      String openPorts = "No Open Ports";

      if (deviceInfo['open_ports'] != null) {
        if (deviceInfo['open_ports'] is List) {
          openPorts = deviceInfo['open_ports'].join(', ');
        } else {
          openPorts = deviceInfo['open_ports'].toString();
        }
      }

      devices.add({
        "ip": ip,
        "mac": mac,
        "os": os,
        "open_ports": openPorts,
      });
    }

    return devices;
  }

  // Function to get device icon based on OS
  IconData _getDeviceIcon(String os) {
    if (os.contains('Windows')) {
      return Icons.computer;
    } else if (os.contains('Linux')) {
      return Icons.computer;
    } else if (os.contains('Android')) {
      return Icons.phone_android;
    } else if (os.contains('iOS')) {
      return Icons.phone_iphone;
    } else {
      return Icons.devices;
    }
  }

  // Function to build the UI for each device
  Widget _buildDeviceCard(Map<String, String> device) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(_getDeviceIcon(device['os'] ?? ''), color: Colors.blue),
        title: Text(
          "Device IP: ${device['ip']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User-friendly information display
            Text("Latency: ${device['latency']}s"),
            Text("Operating System: ${device['os']}"),
            // Display open ports in a user-friendly way
            Text("Open Ports: ${device['open_ports']}"),
          ],
        ),
        trailing: Icon(Icons.wifi, color: Colors.green),
      ),
    );
  }

  // Function to show error dialog if scan fails
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to handle scan button and UI updates
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scan button
            ElevatedButton(
              onPressed: _isLoading || _scanInProgress ? null : _runScan,
              child: Text(_scanInProgress ? 'Scanning...' : 'Start Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _scanInProgress ? Colors.grey : Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            // Display loading or scan results
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _devices.isEmpty
                        ? Center(child: Text("No devices found."))
                        : ListView.builder(
                            itemCount: _devices.length,
                            itemBuilder: (context, index) =>
                                _buildDeviceCard(_devices[index]),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
