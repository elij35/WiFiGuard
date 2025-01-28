import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesService {
  final NetworkInfo _networkInfo = NetworkInfo();
  static const platform = MethodChannel('com.example.network/info');

  // Cached data
  static String? cachedWifiName; // Cached Wi-Fi name
  static List<Map<String, String>> cachedDevices = []; // Cached devices list

  // Retrieves the Wi-Fi name (SSID) and caches it
  Future<String> getWifiName() async {
    if (cachedWifiName != null) return cachedWifiName!;

    try {
      cachedWifiName = await _networkInfo.getWifiName() ?? 'Unknown';
    } catch (e) {
      print("Error fetching Wi-Fi name: $e");
      cachedWifiName = 'Unknown';
    }

    return cachedWifiName!;
  }

  // Scans the network for devices and categorises them by their MAC addresses
  Future<List<Map<String, String>>> scanAndCategorizeDevices() async {
    // Return cached devices if they exist
    if (cachedDevices.isNotEmpty) return cachedDevices;

    List<Map<String, String>> devices = [];
    try {
      // Get the device's current IP and network prefix
      String? ipAddress = await _networkInfo.getWifiIP();
      if (ipAddress == null) return devices;

      String networkPrefix =
          ipAddress.substring(0, ipAddress.lastIndexOf('.') + 1);

      // Pings each IP and collects device info
      List<Future> pingFutures = [];
      List<String> activeIps = [];

      for (int i = 1; i < 255; i++) {
        final ip = "$networkPrefix$i";
        pingFutures.add(_pingDevice(ip).then((isActive) {
          if (isActive) {
            activeIps.add(ip); // Add IP to the list of active IPs
          }
        }));
      }

      await Future.wait(pingFutures);

      for (var ip in activeIps) {
        final mac = await _getMacAddressFromBackend(ip) ?? 'Unknown';
        devices.add({
          'ip': ip,
          'mac': mac,
          'status': mac.isNotEmpty ? 'Active' : 'Inactive',
        });
      }

      cachedDevices = devices;
    } catch (e) {
      print("Error scanning network: $e");
    }

    return devices;
  }

  Future<bool> _pingDevice(String ip) async {
    final ping = Ping(ip, count: 1);
    final response = await ping.stream.first;
    return response.response != null;
  }

  // Fetches the MAC address of a given IP address from the backend via platform channel
  Future<String?> _getMacAddressFromBackend(String ipAddr) async {
    try {
      if (ipAddr.isEmpty) return null;

      final macAddress =
          await platform.invokeMethod('getMacAddress', {'ipAddr': ipAddr});
      return macAddress;
    } on PlatformException catch (e) {
      print("Error fetching MAC address for $ipAddr: ${e.message}");
      return null;
    }
  }
}
