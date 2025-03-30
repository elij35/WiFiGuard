import 'package:WiFiGuard/screens/device_details/device_details.dart';
import 'package:flutter/material.dart';

class ConnectedDevicesBuilder extends StatelessWidget {
  // Widget parameters
  final bool isLoading; // Shows loading indicator when true
  final bool scanInProgress; // Disables scan button when true
  final List<Map<String, String>> devices; // List of devices to display
  final VoidCallback onScanPressed; // Callback for scan button press

  const ConnectedDevicesBuilder({
    super.key,
    required this.isLoading,
    required this.scanInProgress,
    required this.devices,
    required this.onScanPressed,
  });

  // Returns an icon based on device type
  IconData _getDeviceIcon(String? deviceType) {
    switch (deviceType?.toLowerCase()) {
      case 'pc/laptop':
        return Icons.laptop;
      case 'mobile device':
        return Icons.smartphone;
      case 'apple device':
        return Icons.phone_iphone;
      case 'router':
        return Icons.router;
      case 'iot device':
        return Icons.smart_toy;
      case 'gaming console':
        return Icons.sports_esports;
      default:
        return Icons.devices_other;
    }
  }

  // Builds a card widget for each device
  Widget _buildDeviceCard(BuildContext context, Map<String, String> device) {
    // Parse open ports from comma-separated string to list
    final ports = device['open_ports']?.split(', ') ?? [];
    final hasPorts = ports.isNotEmpty;

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading:
            Icon(_getDeviceIcon(device['device_type']), color: Colors.blue),
        title: Text(
          device['ip'] ?? 'Unknown IP',
          // Show IP address or unknown if IP wasn't found (very unlikely)
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Device Type: ${device['device_type'] ?? 'Unknown'}'),
            const SizedBox(height: 10),
            Text('OS: ${device['os'] ?? 'Unknown'}'),
            const SizedBox(height: 10),
            Text(
              'Open Ports: \n${hasPorts ? ports.join('\n') : 'None'}',
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: () {
          // Navigate to device details screen when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DeviceDetailsScreen(device: device, knownPorts: ports),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Scan button - disabled during loading or active scan
          ElevatedButton(
            onPressed: isLoading || scanInProgress ? null : onScanPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(scanInProgress ? 'Scanning...' : 'Start Scan'),
          ),
          const SizedBox(height: 20),

          // Conditional rendering based on loading state
          isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loader
              : Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemCount: devices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _buildDeviceCard(context, devices[index]);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
