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
}
