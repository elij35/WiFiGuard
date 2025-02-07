import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/services/notification_service.dart';
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

    // Send notification if the network is insecure
    if (_wifiSecurity == 'WEP' || _wifiSecurity == 'Open/No Security') {
      final notificationService = NotificationService();
      await notificationService.showNotification(
        '⚠️ Insecure Wi-Fi Detected',
        'Your current network is using $_wifiSecurity security.',
      );
    }
  }

  void _sendInsecureNetworkNotification() {
    NotificationService().showNotification(
      'Insecure Wi-Fi Detected',
      'The connected network $_wifiName uses $_wifiSecurity, which is insecure!',
    );
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
      return '2.4 GHz';
    } else if (freq > 2500) {
      return '5 GHz';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger the RefreshIndicator
              _refreshIndicatorKey.currentState?.show();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _fetchNetworkInfo,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Wi-Fi Details Section
              _buildSectionHeader('Wi-Fi Details'),
              _buildInfoRow(Icons.wifi, 'Wi-Fi Name', _wifiName),
              _buildInfoRow(
                  Icons.signal_cellular_alt, 'Signal Strength', _wifiSignal),
              _buildInfoRow(Icons.language, 'IP Address', _wifiIP),
              _buildInfoRow(Icons.devices, 'Wi-Fi MAC Address', _wifiBSSID),

              const SizedBox(height: 16.0),

              // Frequency and Security Section
              _buildSectionHeader('Network Security'),
              _buildInfoRow(Icons.wifi_tethering, 'Frequency', _wifiFrequency),
              _buildInfoRow(
                Icons.security,
                'Security Protocol',
                _wifiSecurity,
                subtitle: _getSecurityExplanation(_wifiSecurity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {String? subtitle}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkTheme
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).primaryColor;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(label),
        subtitle: subtitle != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              )
            : Text(value),
      ),
    );
  }

  String? _getSecurityExplanation(String security) {
    switch (security) {
      case 'WPA3':
        return 'Very secure, no action required';
      case 'WPA2':
        return 'Secure, no action required';
      case 'WEP':
        return 'WEP is outdated and insecure. Upgrade your router settings.';
      case 'Open/No Security':
        return 'This network is not secure. Strongly recommended to add a password to the network!';
      default:
        return null;
    }
  }
}
