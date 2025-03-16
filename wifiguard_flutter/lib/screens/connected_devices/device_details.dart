import 'package:flutter/material.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> device;

  const DeviceDetailsScreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("IP Address: ${device['ip']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("MAC Address: ${device['mac']}"),
            Text("Device Type: ${device['device_type']}"),
            Text("Operating System: ${device['os']}"),
            SizedBox(height: 20),
            Text("Open Ports:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: (device['open_ports'] is String &&
                      device['open_ports'].isNotEmpty)
                  ? ListView.builder(
                      itemCount: device['open_ports'].length,
                      itemBuilder: (context, index) {
                        var portInfo = device['open_ports'][index];
                        return ListTile(
                          title: Text("Port: ${portInfo['port']}"),
                          subtitle: Text(
                              "Service: ${portInfo['service']} (v${portInfo['version']})"),
                          leading:
                              Icon(Icons.settings_ethernet, color: Colors.blue),
                        );
                      },
                    )
                  : Text("No open ports detected"),
            ),
          ],
        ),
      ),
    );
  }
}
