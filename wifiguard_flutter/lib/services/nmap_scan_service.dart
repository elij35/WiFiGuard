import 'dart:convert';

import 'package:http/http.dart' as http;

/// Function to run a network scan on the given target IP or range.
/// Returns a list of device details as a list of maps.
Future<List<Map<String, String>>> runScan(String target) async {
  List<Map<String, String>> devices = [];

  // Sending a POST request to the local server to trigger the scan
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/scan'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'target': target}), // Encode the target as JSON
  );

  // If the scan is successful (status code 200), parse the response
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseJson = json.decode(response.body);
    final List<dynamic> scanResult = responseJson['scan_result'] ?? [];

    // Parse the Nmap scan result into a list of device details
    devices = parseNmapOutput(scanResult);
  } else {
    // If the scan fails, throw an exception with the error message
    throw Exception(
        "Failed to scan network, Status code: ${response.statusCode}");
  }

  return devices; // Return the list of devices found during the scan
}

/// Helper function to parse the Nmap output into a list of device details.
/// Each device is represented as a map with keys: 'ip', 'mac', 'device_type', 'os', and 'open_ports'.
List<Map<String, String>> parseNmapOutput(List<dynamic> output) {
  List<Map<String, String>> devices = [];

  // Iterate through each device found in the scan result
  for (var deviceInfo in output) {
    // Extract device information with default fallback values
    String ip = deviceInfo['ip'] ?? "Unknown IP";
    String mac = deviceInfo['mac'] ?? "Unknown MAC";
    String deviceType = deviceInfo['device_type'] ?? "Unknown Device";
    String os = deviceInfo['os'] ?? "Unknown OS";

    // Parse the open ports, handling different data types
    String openPorts = "No Open Ports";
    if (deviceInfo['open_ports'] != null) {
      if (deviceInfo['open_ports'] is List) {
        // If open_ports is a list, join the ports into a string
        openPorts = deviceInfo['open_ports'].join(', ');
      } else if (deviceInfo['open_ports'] is String) {
        // If open_ports is already a string then perfect nothing needs doing
        openPorts = deviceInfo['open_ports'];
      } else {
        // If open_ports is of another type, convert it to string
        openPorts = deviceInfo['open_ports'].toString();
      }
    }

    // Add the parsed device info as a map to the devices list
    devices.add({
      "ip": ip,
      "mac": mac,
      "device_type": deviceType,
      "os": os,
      "open_ports": openPorts,
    });
  }

  return devices; // Return the parsed list of devices
}
