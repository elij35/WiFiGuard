import 'package:flutter/services.dart';

class NmapService {
  static const platform = MethodChannel('com.example.network/info');

  Future<String> runNmapScan(String subnet) async {
    try {
      final String result =
          await platform.invokeMethod('runNmapScan', {'targetIp': subnet});
      return result;
    } on PlatformException catch (e) {
      return "Failed to run Nmap: ${e.message}";
    }
  }
}
