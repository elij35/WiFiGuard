import 'package:dart_ping/dart_ping.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesService {
  final NetworkInfo _networkInfo = NetworkInfo();

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
      for (int i = 1; i < 255; i++) {
        final ip = "$networkPrefix$i";
        pingFutures.add(_pingDevice(ip).then((isActive) {
          if (isActive) {
            final mac =
                _generateDummyMac(i); // Replace with actual MAC fetching logic
            devices.add({
              'ip': ip,
              'mac': mac,
              'status': 'Active',
            });
          }
        }));
      }

      await Future.wait(pingFutures);
      cachedDevices = devices; // Cache the scanned devices
    } catch (e) {
      print("Error scanning network: $e");
    }

    return devices;
  }

  // Clears the cached data for Wi-Fi name and devices
  void clearCache() {
    cachedWifiName = null;
    cachedDevices = [];
  }

  // Dummy MAC generator (this will be replaced with real MAC fetching)
  String _generateDummyMac(int index) {
    return '00:1A:${index.toRadixString(16).padLeft(2, '0')}:FF:FF:FF';
  }

  // Pings a device and checks if it's active
  Future<bool> _pingDevice(String ip) async {
    final ping = Ping(ip, count: 1);
    final response = await ping.stream.first;
    return response.response != null;
  }
}
