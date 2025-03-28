import 'package:WiFiGuard/screens/device_details/device_details_AI.dart';
import 'package:WiFiGuard/widgets/device_details_builder.dart';
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
        child: ListView(
          children: [
            // Shows general device details
            _buildDeviceInfo(),

            // Displays open ports with an option to ask AI
            _buildOpenPortsSection(context),
          ],
        ),
      ),
    );
  }

  // Builds the section displaying the basic device information
  Widget _buildDeviceInfo() {
    return Column(
      children: [
        // Reusable widget for device details with icon, title, value, and description
        DeviceDetailsBuilder(
          icon: Icons.device_hub,
          title: "Device Type",
          value: device['device_type'] ?? "Unknown",
          description: "The type of device connected to your Wi-Fi.",
        ),
        DeviceDetailsBuilder(
          icon: Icons.language,
          title: "IP Address",
          value: device['ip'] ?? "Unknown",
          description: "The unique address assigned to this device.",
        ),
        DeviceDetailsBuilder(
          icon: Icons.memory,
          title: "MAC Address",
          value: device['mac'] ?? "Unknown",
          description: "A unique ID assigned to the device's network hardware.",
        ),
        DeviceDetailsBuilder(
          icon: Icons.computer,
          title: "Operating System",
          value: device['os'] ?? "Unknown",
          description: "The system software running on the device.",
        ),
      ],
    );
  }

  // Builds the open ports section for the device
  Widget _buildOpenPortsSection(BuildContext context) {
    // Convert open ports from device data to a list of strings
    List<String> knownPorts = (device['open_ports'] is List)
        ? List<String>.from(device['open_ports'])
        : (device['open_ports'] is String)
            ? (device['open_ports'] as String).split(',')
            : [];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.security, color: Colors.red),
            title: const Text("Open Ports",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: knownPorts.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: knownPorts
                        .map((port) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(port.trim()),
                            ))
                        .toList(),
                  )
                : const Text("No open ports detected. Your device is safe."),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to AskAI screen with open ports passed as arguments
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AskAIScreen(ports: knownPorts),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Need Help? Click here to ask AI"),
            ),
          ),
        ],
      ),
    );
  }
}
