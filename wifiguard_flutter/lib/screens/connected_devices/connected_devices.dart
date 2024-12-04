import 'package:flutter/material.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    // Front end hard coded IP Addresses to show how it will look once backend is created
    final List<Map<String, String>> connectedDevices = [
      {'ip': '192.168.0.13'},
      {'ip': '192.168.0.14'},
      {'ip': '192.168.0.15'},
      {'ip': '192.168.0.16'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header information about the Wi-Fi the user is currently connected to
            Row(
              children: const [
                Icon(Icons.wifi, size: 24),
                SizedBox(width: 8),
                Text(
                  'Android Wifi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.devices, size: 20),
                SizedBox(width: 8),
                Text(
                  '4 connected devices',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of connected devices on the network
            Expanded(
              child: ListView.builder(
                itemCount: connectedDevices.length,
                itemBuilder: (context, index) {
                  final device = connectedDevices[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.device_hub),
                      title: Text(
                        'IP: ${device['ip']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Here it will navigate to the specific device the user clicks on to more info
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