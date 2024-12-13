import 'package:WiFiGuard/services/connected_devices_service.dart';
import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final ConnectedDevicesService _connectedDevicesService =
      ConnectedDevicesService();

  List<Map<String, String>> _devices = [];
  String _wifiName = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadNetworkData();
  }

  Future<void> _loadNetworkData() async {
    try {
      // Fetch Wi-Fi name
      final wifiName = await _connectedDevicesService.getWifiName();
      setState(() {
        _wifiName = wifiName;
      });

      // Fetch connected devices
      final devices = await _connectedDevicesService.scanNetwork();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      print("Error loading network data: $e");
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
            onPressed: _loadNetworkData, // Refresh the network data
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header tile displaying Wi-Fi name and connected devices count
            buildHeaderTile(
              context: context,
              wifiName: _wifiName,
              deviceCount: _devices.length,
            ),
            // List of connected devices
            Expanded(
              child: _devices.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return buildDeviceTile(
                          context: context,
                          deviceIp: device['ip'] ?? 'Unknown',
                          onMoreInfo: () {
                            // Handle more info button tap
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}