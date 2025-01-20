import 'package:WiFiGuard/services/connected_devices_service.dart';
import 'package:flutter/material.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final ConnectedDevicesService _devicesService = ConnectedDevicesService();

  List<Map<String, String>> _devices = [];
  String _wifiName = 'Unknown';
  bool _isFirstLoad = true; // Ensures the first load is triggered only once
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (_isFirstLoad) {
      _loadDevices();
    } else {
      setState(() {
        _isLoading = false; // Skip loading if already loaded
      });
    }
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wifiName = await _devicesService.getWifiName();
      final devices = await _devicesService.scanAndCategorizeDevices();

      setState(() {
        _wifiName = wifiName;
        _devices = devices;
        _isFirstLoad = false; // Mark the initial load as complete
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading network data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDevices, // Refresh on button press
          ),
        ],
      ),
      body: Column(
        children: [
          // Header displaying Wi-Fi name and connected devices count
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.wifi,
                    size: 24, color: Theme.of(context).primaryColor),
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
          // Device List or Loading Indicator
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? const Center(child: Text('No devices found.'))
                    : ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return Card(
                            child: ListTile(
                              title: Text('IP: ${device['ip']}'),
                              subtitle: Text('MAC: ${device['mac']}'),
                              trailing: const Icon(Icons.device_hub),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
