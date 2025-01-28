import 'package:WiFiGuard/services/connected_devices_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final ConnectedDevicesService _devicesService = ConnectedDevicesService();

  List<Map<String, String>> _devices = [];
  String _wifiName = 'Unknown';
  bool _isLoading = true;
  bool _hasScannedBefore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    await _checkScanStatus();
    if (_hasScannedBefore) {
      await _loadCachedDevices();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkScanStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasScannedBefore = prefs.getBool('hasScannedBefore') ?? false;
    });
  }

  Future<void> _loadCachedDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedDevicesString = prefs.getString('cachedDevices') ?? '[]';
      final List<dynamic> cachedDevicesJson = jsonDecode(cachedDevicesString);

      final List<Map<String, String>> cachedDevices =
          cachedDevicesJson.map((e) => Map<String, String>.from(e)).toList();

      final wifiName = await _devicesService.getWifiName();
      setState(() {
        _wifiName = wifiName;
        _devices = cachedDevices;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading cached devices: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runNetworkScan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wifiName = await _devicesService.getWifiName();
      final devices = await _devicesService.scanAndCategorizeDevices();

      setState(() {
        _wifiName = wifiName;
        _devices = devices;
        _isLoading = false;
        _hasScannedBefore = true;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('hasScannedBefore', true);
      prefs.setString('cachedDevices', jsonEncode(devices));
    } catch (e) {
      print("Error running network scan: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showWarningDialogs() async {
    final firstWarning = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Network Scan Warning'),
        content: const Text(
          'Scanning your network may take a few moments. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );

    if (firstWarning == true) {
      final secondWarning = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Scan'),
          content: const Text(
            'Are you sure you want to scan your network? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (secondWarning == true) {
        await _runNetworkScan();
      }
    }
  }

  @override
  Widget build(BuildContext context, {String? subtitle}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkTheme
        ? Theme.of(context).colorScheme.secondary // Bright color for dark theme
        : Theme.of(context)
            .primaryColor; // Default primary color for light theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
        actions: [
          if (_hasScannedBefore)
            IconButton(
              icon: Icon(Icons.refresh, color: iconColor),
              onPressed: () => _showWarningDialogs(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasScannedBefore
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.wifi, size: 24, color: iconColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Connected to: $_wifiName (${_devices.length} devices)',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: _devices.isEmpty
                          ? const Center(child: Text('No devices found.'))
                          : ListView.builder(
                              itemCount: _devices.length,
                              itemBuilder: (context, index) {
                                final device = _devices[index];
                                return Card(
                                  child: ListTile(
                                    title: Text('IP: ${device['ip']}'),
                                    subtitle: Text('MAC: ${device['mac']}'),
                                    trailing: Icon(Icons.device_hub,
                                        color: iconColor),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () => _showWarningDialogs(),
                    child: const Text('Start Network Scan'),
                  ),
                ),
    );
  }
}
