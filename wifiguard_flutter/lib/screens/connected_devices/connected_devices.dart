import 'dart:convert';

import 'package:WiFiGuard/widgets/connected_devices_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nmap_scan.dart';
import 'terms_and_conditions.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  List<Map<String, String>> _devices = [];
  bool _isLoading = false;
  bool _scanInProgress = false; // Flag to check scan status
  String _filterType = "All";

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

  Future<void> _runScan() async {
    // Always show the accept terms dialog before scanning
    bool? accepted = await showAcceptTermsDialog(context);
    if (accepted == null || !accepted) {
      return;
    }

    // Proceed with scanning
    setState(() {
      _isLoading = true; // Show loading indicator
      _scanInProgress = true; // Disable the scan button during the scan
    });

    // Parse Nmap output and convert it into a list of device details
    List<Map<String, String>> scanResults = await runScan('192.168.0.0/24');

    setState(() {
      _devices = scanResults;
      _isLoading = false;
      _scanInProgress = false;
    });

    await _saveDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Devices'),
        actions: [
          DropdownButton<String>(
            value: _filterType,
            items: ["All", "PC/Laptop", "Mobile Device", "Apple Device"]
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _filterType = value!;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scan button
            ElevatedButton(
              onPressed: _isLoading || _scanInProgress ? null : _runScan,
              child: Text(_scanInProgress ? 'Scanning...' : 'Start Scan'),
            ),
            SizedBox(height: 20),
            // Display loading or scan results
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _devices.isEmpty
                        ? Center(child: Text("No devices found."))
                        : buildDeviceList(context, _devices, _filterType),
                  ),
          ],
        ),
      ),
    );
  }
}
