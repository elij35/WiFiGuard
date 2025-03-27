import 'package:WiFiGuard/screens/device_details/device_details.dart';
import 'package:flutter/material.dart';

Widget buildDeviceCard(BuildContext context, Map<String, String> device) {
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
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.devices, color: Colors.blue),
        title: Text(
          "Device IP: ${device['ip']}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Device Type: ${device['device_type']}"),
            SizedBox(height: 8),
            Text("Operating System: ${device['os']}"),
            SizedBox(height: 8),
            Text("Open Ports: ${device['open_ports']}"),
          ],
        ),
        trailing: Icon(Icons.wifi, color: Colors.green),
      ),
    ),
  );
}

Widget buildDeviceList(BuildContext context, List<Map<String, String>> devices,
    String filterType) {
  return ListView.builder(
    itemCount: devices.length,
    itemBuilder: (context, index) {
      if (filterType == "All" || devices[index]['device_type'] == filterType) {
        return buildDeviceCard(context, devices[index]);
      }
      return SizedBox.shrink();
    },
  );
}
