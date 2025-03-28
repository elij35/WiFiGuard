import 'package:WiFiGuard/screens/device_details/device_details.dart';
import 'package:flutter/material.dart';

Widget buildDeviceCard(BuildContext context, Map<String, String> device) {
  final ports = device['open_ports']?.split(',') ?? [];
  final hasPorts = ports.isNotEmpty;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetailsScreen(device: device),
        ),
      );
    },
    child: Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP Address row
            Row(
              children: [
                const Icon(Icons.lan, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    device['ip'] ?? 'Unknown IP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Device Type
            _buildInfoRow('Type:', device['device_type'] ?? 'Unknown'),

            // OS Info
            _buildInfoRow('OS:', device['os'] ?? 'Unknown'),

            // Ports section
            const SizedBox(height: 8),
            Text(
              'Open Ports:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            if (!hasPorts)
              const Text(
                'No open ports detected',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ports.map((port) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    port.trim(),
                    style: const TextStyle(fontSize: 14),
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

// Filter button (top right of screen)
Widget buildDeviceList(
    BuildContext context,
    List<Map<String, String>> devices,
    String filterType,
    ) {
  final filteredDevices = devices.where((device) {
    return filterType == "All" || device['device_type'] == filterType;
  }).toList();

  return filteredDevices.isEmpty
      ? const Center(
    child: Text(
      'No matching devices found',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  )
      : ListView.separated(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: filteredDevices.length,
    separatorBuilder: (context, index) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      return buildDeviceCard(context, filteredDevices[index]);
    },
  );
}