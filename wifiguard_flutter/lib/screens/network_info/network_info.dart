import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:WiFiGuard/widgets/tile_builder.dart';

class NetworkInfoScreen extends StatefulWidget {
  const NetworkInfoScreen({super.key});

  @override
  NetworkInfoScreenState createState() => NetworkInfoScreenState();
}

class NetworkInfoScreenState extends State<NetworkInfoScreen> {
  static const platform = MethodChannel('com.example.network/info');

  String _wifiName = 'Unknown';
  String _wifiBSSID = 'Unknown';
  String _wifiIP = 'Unknown';
  String _wifiSignal = 'Unknown';
  String _wifiFrequency = 'Unknown';
  String _wifiSecurity = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getNetworkInfo();
  }

  Future<void> _getNetworkInfo() async {
    try {
      final Map<String, String> networkInfo =
          await platform.invokeMapMethod<String, String>('getNetworkInfo') ??
              {};

      print('Fetched Network Info: $networkInfo'); // Debug log

      setState(() {
        _wifiName = networkInfo['ssid'] ?? 'Unknown';
        _wifiBSSID = networkInfo['bssid'] ?? 'Unknown';
        _wifiIP = networkInfo['ip'] ?? 'Unknown';
        _wifiSignal = networkInfo['signalStrength'] ?? 'Unknown';
        _wifiFrequency = networkInfo['frequency'] ?? 'Unknown';
        _wifiSecurity = networkInfo['security'] ?? 'Unknown';
      });
    } on PlatformException catch (e) {
      print("Failed to get network info: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NetworkInfoRow(
                label: 'SSID', value: _wifiName), //WiFi broadcast name
            const Divider(color: Colors.grey),
            NetworkInfoRow(
                label: 'Signal', value: _wifiSignal), // Signal strength
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'IP Address', value: _wifiIP), //IP Address
            const Divider(color: Colors.grey),
            NetworkInfoRow(
                label: 'MAC Address', value: _wifiBSSID), //MAC Address
            const Divider(color: Colors.grey),
            NetworkInfoRow(
                label: 'Frequency', value: _wifiFrequency), // Frequency
            const Divider(color: Colors.grey),
            NetworkInfoRow(
                label: 'Security Protocol',
                value: _wifiSecurity), // Security Protocol
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}