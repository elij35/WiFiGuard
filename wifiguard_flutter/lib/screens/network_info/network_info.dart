import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';

class NetworkInfoScreen extends StatefulWidget {
  const NetworkInfoScreen({super.key});

  @override
  NetworkInfoScreenState createState() => NetworkInfoScreenState();
}

class NetworkInfoScreenState extends State<NetworkInfoScreen> {
  final NetworkService _networkService = NetworkService();

  String _wifiName = 'Unknown';
  String _wifiBSSID = 'Unknown';
  String _wifiIP = 'Unknown';
  String _wifiSignal = 'Unknown';
  String _wifiFrequency = 'Unknown';
  String _wifiSecurity = 'Unknown';

  @override
  void initState() {
    super.initState();
    _fetchNetworkInfo();
  }

  Future<void> _fetchNetworkInfo() async {
    final networkInfo = await _networkService.getNetworkInfo();
    setState(() {
      _wifiName = networkInfo['ssid'] ?? 'Unknown';
      _wifiBSSID = networkInfo['bssid'] ?? 'Unknown';
      _wifiIP = networkInfo['ip'] ?? 'Unknown';
      _wifiSignal = networkInfo['signalStrength'] ?? 'Unknown';
      _wifiFrequency = networkInfo['frequency'] ?? 'Unknown';
      _wifiSecurity = networkInfo['security'] ?? 'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NetworkInfoRow(label: 'SSID', value: _wifiName),
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Signal', value: _wifiSignal),
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'IP Address', value: _wifiIP),
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'MAC Address', value: _wifiBSSID),
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Frequency', value: _wifiFrequency),
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Security Protocol', value: _wifiSecurity),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
