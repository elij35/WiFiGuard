import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/widgets/universal_tile_builder.dart';
import 'package:flutter/material.dart';

class NetworkInfoScreen extends StatefulWidget {
  const NetworkInfoScreen({super.key});

  @override
  NetworkInfoScreenState createState() => NetworkInfoScreenState();
}

class NetworkInfoScreenState extends State<NetworkInfoScreen> {
  final NetworkService _networkService = NetworkService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
      _wifiSignal = _convertSignalToWords(networkInfo['signalStrength']);
      _wifiFrequency = _convertFrequencyToBand(networkInfo['frequency']);
      _wifiSecurity = networkInfo['security'] ?? 'Unknown';
    });
  }

  // Converts signal int to words
  String _convertSignalToWords(String? signalStrength) {
    if (signalStrength == null || signalStrength == 'Unknown') return 'Unknown';
    final strength = int.tryParse(signalStrength) ?? 0;

    if (strength >= -50) {
      return 'Excellent';
    } else if (strength >= -60) {
      return 'Good';
    } else if (strength >= -70) {
      return 'Fair';
    } else {
      return 'Weak';
    }
  }

  // Converts frequency to either 2.4 or 5GHz
  String _convertFrequencyToBand(String? frequency) {
    if (frequency == null || frequency == 'Unknown') return 'Unknown';
    final freq = int.tryParse(frequency.replaceAll(' MHz', '')) ?? 0;

    if (freq < 2500) {
      return '2.4 GHz (Better range, slower speed)';
    } else if (freq > 2500) {
      return '5 GHz (Faster speed, shorter range)';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Information'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _fetchNetworkInfo,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Wi-Fi Details Section
              UniversalBuilder.buildSectionHeader('Wi-Fi Details'),
              UniversalBuilder.buildNetworkInfoCard(
                  Icons.wifi, 'Wi-Fi Name', _wifiName),
              UniversalBuilder.buildNetworkInfoCard(
                  Icons.signal_cellular_alt, 'Signal Strength', _wifiSignal),
              UniversalBuilder.buildNetworkInfoCard(
                  Icons.language, 'IP Address', _wifiIP),
              UniversalBuilder.buildNetworkInfoCard(
                  Icons.devices, 'Router MAC Address', _wifiBSSID),

              const Divider(),

              // Frequency and Security Section
              UniversalBuilder.buildSectionHeader('Network Security'),
              UniversalBuilder.buildNetworkInfoCard(
                  Icons.wifi_tethering, 'Frequency', _wifiFrequency),
              UniversalBuilder.buildSecurityCard(_wifiSecurity),
            ],
          ),
        ),
      ),
    );
  }
}
