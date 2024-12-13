import 'package:flutter/material.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  final NetworkInfo _networkInfo = NetworkInfo();
  List<Map<String, String>> _devices = [];
  String _wifiName = 'Unknown';

  @override
  void initState() {
    super.initState();
    _scanNetwork();
  }

  Future<void> _scanNetwork() async {
    setState(() {
      _devices = [];
    });

    try {
      // Get device IP and determine network prefix
      String? ipAddress = await _networkInfo.getWifiIP();
      if (ipAddress == null) {
        return;
      }

      // Fetch Wi-Fi details
      final wifiInfo = await _networkInfo.getWifiName();
      _wifiName = wifiInfo ?? 'Unknown';

      // Calculates network prefix, e.g., "192.168.1." to include all networks
      String networkPrefix =
      ipAddress.substring(0, ipAddress.lastIndexOf('.') + 1);

      // for loop to ping each IP in the local network range (1 to 254)
      List<Future> pingFutures = [];
      for (int i = 1; i < 255; i++) {
        final ip = "$networkPrefix$i";
        pingFutures.add(_pingDevice(ip).then((isActive) {
          if (isActive) {
            setState(() {
              _devices.add({'ip': ip, 'status': 'Active'});
            });
          }
        }));
      }

      // Wait for all ping attempts to complete
      await Future.wait(pingFutures);
    } catch (e) {
      print("Error scanning network: $e");
    }
  }

  // Helper function to ping an IP and check if it's active
  Future<bool> _pingDevice(String ip) async {
    final ping = Ping(ip, count: 1);
    final response = await ping.stream.first;
    return response.response != null; // This will return true if a response is received
  }

  //Int to count each device on the network
  int connectedDevicesCount = 0;

  @override
  Widget build(BuildContext context) {
    connectedDevicesCount = _devices.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header information about the Wi-Fi
            Row(
              children: [
                Icon(Icons.wifi, size: 24),
                SizedBox(width: 8),
                Text(
                  'SSID: $_wifiName',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.devices, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$connectedDevicesCount connected devices',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lists the devices connected on the network
            Expanded(
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.device_hub),
                      title: Text(
                        'Device IP: ${device['ip']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // This will navigate to another page to show detailed info of the device clicked on
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('More Info'),
                      ),
                    ),
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