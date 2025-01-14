import 'package:flutter/services.dart';

class NetworkService {
  static const MethodChannel _platform =
      MethodChannel('com.example.network/info');

  Future<Map<String, String>> getNetworkInfo() async {
    try {
      final Map<String, String> networkInfo =
          await _platform.invokeMapMethod<String, String>('getNetworkInfo') ??
              {};
      return {
        'ssid': networkInfo['ssid'] ?? 'Unknown',
        'bssid': networkInfo['bssid'] ?? 'Unknown',
        'ip': networkInfo['ip'] ?? 'Unknown',
        'signalStrength': networkInfo['signalStrength'] ?? 'Unknown',
        'frequency': networkInfo['frequency'] ?? 'Unknown',
        'security': networkInfo['security'] ?? 'Unknown',
      };
    } on PlatformException catch (e) {
      print("Failed to get network info: '${e.message}'");
      return {
        'ssid': 'Error',
        'bssid': 'Error',
        'ip': 'Error',
        'signalStrength': 'Error',
        'frequency': 'Error',
        'security': 'Error',
      };
    }
  }
}