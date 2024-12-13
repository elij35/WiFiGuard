import 'package:dart_ping/dart_ping.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ConnectedDevicesService {
  final NetworkInfo _networkInfo = NetworkInfo();

  // Scans the network and returns a list of connected devices
  Future<List<Map<String, String>>> scanNetwork() async {
    List<Map<String, String>> devices = [];

    try {
      // Get device IP and determine network prefix
      String? ipAddress = await _networkInfo.getWifiIP();
      if (ipAddress == null) return devices;

      // Calculates network prefix, e.g., "192.168.1." to include all networks
      String networkPrefix =
          ipAddress.substring(0, ipAddress.lastIndexOf('.') + 1);

      // Ping each IP in the local network range (1 to 254)
      List<Future> pingFutures = [];
      for (int i = 1; i < 255; i++) {
        final ip = "$networkPrefix$i";
        pingFutures.add(_pingDevice(ip).then((isActive) {
          if (isActive) {
            devices.add({'ip': ip, 'status': 'Active'});
          }
        }));
      }

      // Wait for all ping attempts to complete
      await Future.wait(pingFutures);
    } catch (e) {
      print("Error scanning network: $e");
    }
    return devices;
  }

  // Function that pings an IP and check if it's active
  Future<bool> _pingDevice(String ip) async {
    final ping = Ping(ip, count: 1);
    final response = await ping.stream.first;
    return response.response != null;
  }

  // Fetches the current Wi-Fi name (SSID).
  Future<String> getWifiName() async {
    try {
      return await _networkInfo.getWifiName() ?? 'Unknown';
    } catch (e) {
      print("Error fetching Wi-Fi name: $e");
      return 'Unknown';
    }
  }
}