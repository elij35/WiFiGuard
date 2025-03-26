import 'dart:convert';

import 'package:WiFiGuard/screens/connected_devices/device_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  ConnectedDevicesScreenState createState() => ConnectedDevicesScreenState();
}

class ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  List<Map<String, String>> _devices = [];
  bool _isLoading = false;
  bool _scanInProgress = false; // Flag to check scan status
  String _filterType = "All";

  // Function to initialize the app and load saved devices
  @override
  void initState() {
    super.initState();
    _loadSavedDevices();
  }

  // Load devices from SharedPreferences
  Future<void> _loadSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedDevices = prefs.getString('devices');
    if (savedDevices != null) {
      setState(() {
        _devices = List<Map<String, String>>.from(
          json
              .decode(savedDevices)
              .map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  // Save devices to SharedPreferences
  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String devicesJson = json.encode(_devices);
    await prefs.setString('devices', devicesJson);
  }

  Future<bool?> _showAcceptTermsDialog() async {
    bool isChecked = false;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing without action
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Accept Terms & Conditions"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Before scanning, you must agree to the following terms:\n\n"
                      "I confirm that I am scanning a network that I own or have permission to scan.\n"
                      "I understand that unauthorised scanning is illegal and against policy.\n"
                      "I accept full responsibility for using Wi-Fi Guard ethically.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text("I accept the terms and conditions."),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User declines
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isChecked
                      ? () {
                          Navigator.of(context).pop(true); // User accepts
                        }
                      : null, // Disable until checkbox is checked
                  child: Text("Accept & Scan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _runScan() async {
    // Always show the accept terms dialog before scanning
    bool? accepted = await _showAcceptTermsDialog();
    if (accepted == null || !accepted) {
      return; // User did not accept, exit the function
    }

    // Proceed with scanning
    setState(() {
      _isLoading = true; // Show loading indicator
      _scanInProgress = true; // Disable the scan button during the scan
    });

    try {
      // Make a POST request to the Python backend server
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/scan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'target': '192.168.0.0/24' // Network range to scan
        }),
      );

      // Check if the response from the server is successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response from the server
        final Map<String, dynamic> responseJson = json.decode(response.body);
        // Extract the scan results from the 'scan_result' field in the response
        final List<dynamic> scanResult = responseJson['scan_result'] ?? [];

        setState(() {
          // Parse the scan result to extract device details
          _devices = _parseNmapOutput(scanResult);
          // Sort the devices by their IP addresses
          _devices.sort((a, b) => a['ip']!.compareTo(b['ip']!));
          // Set loading state to false as the scan is complete
          _isLoading = false;
        });

        // Save the detected devices to SharedPreferences for persistence
        await _saveDevices();
      } else {
        // Throw an exception if the server response is not successful
        throw Exception(
            "Failed to scan network, Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors during the scan (e.g., network issues, server errors)
      print("Error during scan: $e"); // Log the error for debugging
      setState(() {
        _devices = []; // Clear any existing devices in case of error
        _isLoading = false; // Reset loading state
      });
    } finally {
      // Set the scanning flag to false to re-enable the scan button after the process ends
      setState(() {
        _scanInProgress = false;
      });
    }
  }

// Parse Nmap output and convert it into a list of device details
  List<Map<String, String>> _parseNmapOutput(List<dynamic> output) {
    List<Map<String, String>> devices = [];

    // Iterate through each device in the scan result
    for (var deviceInfo in output) {
      // Safely extract device information with fallback default values
      String ip = deviceInfo['ip'] ?? "Unknown IP";
      String mac = deviceInfo['mac'] ?? "Unknown MAC";
      String deviceType = deviceInfo['device_type'] ?? "Unknown Device";
      String os = deviceInfo['os'] ?? "Unknown OS";

      // Handle 'open_ports' field, which is expected to be a list
      String openPorts = "No Open Ports";
      if (deviceInfo['open_ports'] != null) {
        if (deviceInfo['open_ports'] is List) {
          // If 'open_ports' is a list, join the ports into a comma-separated string
          openPorts = deviceInfo['open_ports'].join(', ');
        } else if (deviceInfo['open_ports'] is String) {
          // If 'open_ports' is already a string, use it directly
          openPorts = deviceInfo['open_ports'];
        } else {
          // If 'open_ports' is of another type, convert it to a string
          openPorts = deviceInfo['open_ports'].toString();
        }
      }

      // Add the parsed device details to the devices list
      devices.add({
        "ip": ip,
        "mac": mac,
        "device_type": deviceType,
        "os": os,
        "open_ports": openPorts,
      });
    }

    // Return the list of parsed devices
    return devices;
  }

  // Function to build the UI for each device
  Widget _buildDeviceCard(Map<String, String> device) {
    return GestureDetector(
      onTap: () {
        // Navigate to the DeviceDetailsScreen and pass the selected device details
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Devices'),
        actions: [
          DropdownButton<String>(
            value: _filterType,
            items: ["All", "PC/Laptop", "Mobile Device", "Apple Device"]
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _filterType = value!;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scan button
            ElevatedButton(
              onPressed: _isLoading || _scanInProgress ? null : _runScan,
              child: Text(_scanInProgress ? 'Scanning...' : 'Start Scan'),
            ),
            SizedBox(height: 20),
            // Display loading or scan results
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _devices.isEmpty
                        ? Center(child: Text("No devices found."))
                        : ListView.builder(
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                              if (_filterType == "All" ||
                                  _devices[index]['device_type'] ==
                                      _filterType) {
                                return _buildDeviceCard(_devices[index]);
                              }
                              return SizedBox.shrink();
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
