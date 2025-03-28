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

  // Function to load saved devices and check python server status
  @override
  void initState() {
    super.initState();
    _loadSavedDevices();
    _checkServerStatus();
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
      switch (_filterType) {
        case "PC/Laptop":
          return type.contains('pc') || type.contains('laptop');
        case "Mobile Device":
          return type.contains('mobile');
        case "Apple Device":
          return type.contains('apple');
        default:
          return true;
      }
    }).toList();
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
      body: ConnectedDevicesBuilder(
        isLoading: _isLoading,
        scanInProgress: _scanInProgress,
        devices: _getFilteredDevices(),
        onScanPressed: _runScan,
      ),
    );
  }
}
