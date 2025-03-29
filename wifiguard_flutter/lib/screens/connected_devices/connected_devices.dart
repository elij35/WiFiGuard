import 'dart:async';
import 'dart:convert';

import 'package:WiFiGuard/screens/connected_devices/terms_and_conditions.dart';
import 'package:WiFiGuard/services/nmap_scan_service.dart';
import 'package:WiFiGuard/widgets/connected_devices_builder.dart';
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
  bool _serverAvailable = false;
  String _filterType = "All";
  final List<String> _availableFilters = [
    "All",
    "PC/Laptop",
    "Mobile Device",
    "Apple Device",
    "Router",
    "IoT Device",
    "Unknown"
  ];

  // Function to load saved devices and check python server status
  @override
  void initState() {
    super.initState();
    _loadSavedDevices();
    _checkServerStatus();
  }

  // Helper function to sort IP addresses numerically
  int _compareIpAddresses(String ip1, String ip2) {
    try {
      List<int> parts1 = ip1.split('.').map((part) => int.parse(part)).toList();
      List<int> parts2 = ip2.split('.').map((part) => int.parse(part)).toList();

      for (int i = 0; i < 4; i++) {
        if (parts1[i] < parts2[i]) return -1;
        if (parts1[i] > parts2[i]) return 1;
      }
      return 0;
    } catch (e) {
      return ip1
          .compareTo(ip2); // Fallback to string comparison if parsing fails
    }
  }

  Future<void> _checkServerStatus() async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost:5000/alive"))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        setState(() => _serverAvailable = true);
        return;
      }
    } catch (e) {
      setState(() => _serverAvailable = false);
      debugPrint('Server check error: $e');
    }
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
        // Sort devices by IP address
        _devices.sort((a, b) => _compareIpAddresses(
              a['ip'] ?? '0.0.0.0',
              b['ip'] ?? '0.0.0.0',
            ));
      });
    }
  }

  // Save devices to SharedPreferences
  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String devicesJson = json.encode(_devices);
    await prefs.setString('devices', devicesJson);
  }

  // Function to run the nmap scan
  Future<void> _runScan() async {
    //Checks if server is running
    if (!_serverAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local server is not available')),
      );
      return;
    }

    // Makes the user accept terms and conditions before scanning starts
    bool? accepted = await showAcceptTermsDialog(context);
    if (accepted == null || !accepted) return;

    setState(() {
      _isLoading = true;
      _scanInProgress = true;
    });

    try {
      // Tries to run the scan by sending request to nmap service
      List<Map<String, String>> scanResults = await runScan('192.168.0.0/24');
      // Sort the scan results by IP address
      scanResults.sort((a, b) => _compareIpAddresses(
            a['ip'] ?? '0.0.0.0',
            b['ip'] ?? '0.0.0.0',
          ));
      setState(() {
        _devices = scanResults;
      });
      await _saveDevices();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scan failed: ${e.toString()}')),
      );
    } finally {
      // Once scan has completed or failed set loading and scan status back to false
      setState(() {
        _isLoading = false;
        _scanInProgress = false;
      });
    }
  }

  // Gets the devices chosen in the filter (in top right)
  List<Map<String, String>> _getFilteredDevices() {
    if (_filterType == "All") return _devices;

    return _devices.where((device) {
      final type = device['device_type']?.toLowerCase() ?? '';
      final os = device['os']?.toLowerCase() ?? '';

      switch (_filterType) {
        case "PC/Laptop":
          return type.contains('pc') ||
              type.contains('laptop') ||
              os.contains('windows') ||
              os.contains('macos') ||
              os.contains('linux');
        case "Mobile Device":
          return type.contains('mobile') ||
              os.contains('android') ||
              os.contains('ios');
        case "Apple Device":
          return type.contains('apple') ||
              os.contains('macos') ||
              os.contains('ios');
        case "Router":
          return type.contains('router') ||
              os.contains('router') ||
              device['ip']?.startsWith('192.168.1.1') == true;
        case "IoT Device":
          return type.contains('iot') ||
              type.contains('smart') ||
              type.contains('printer') ||
              type.contains('camera');
        case "Unknown":
          return type.isEmpty ||
              device['device_type'] == null ||
              device['device_type']!.toLowerCase() == 'unknown';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
        actions: [
          DropdownButton<String>(
            value: _filterType,
            items: _availableFilters.map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _filterType = value!;
              });
            },
          ),
        ],
      ),
      body: ConnectedDevicesBuilder(
        isLoading: _isLoading,
        scanInProgress: _scanInProgress,
        devices: _getFilteredDevices(),
        onScanPressed: _runScan,
      ),
    );
  }
}
