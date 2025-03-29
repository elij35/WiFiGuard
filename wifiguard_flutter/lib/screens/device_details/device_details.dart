import 'package:WiFiGuard/screens/device_details/device_details_AI.dart';
import 'package:WiFiGuard/widgets/device_details_builder.dart';
import 'package:flutter/material.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final Map<String, String>
      device; // String for the device data structure (includes info about the device from nmap scan - IP address, MAC address, OS, etc)
  final List<String>
      knownPorts; // The open ports of the device sent from connected devices builder

  const DeviceDetailsScreen({
    super.key,
    required this.device,
    required this.knownPorts,
  });

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
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
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
                    builder: (context) => DeviceDetailsAiScreen(
                      ports: knownPorts,
                      deviceIp: device['ip'] ?? 'Unknown',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
