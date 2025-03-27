import 'dart:async';

import 'package:WiFiGuard/screens/connected_devices/connected_devices.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_guidance.dart';
import 'package:WiFiGuard/screens/network_info/network_info.dart';
import 'package:WiFiGuard/screens/security_details/security_details.dart';
import 'package:WiFiGuard/screens/settings/settings.dart';
import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/widgets/dashboard_builder.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const DashboardScreen({
    super.key,
    required this.themeModeNotifier,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NetworkService _networkService = NetworkService();

  String _wifiName = 'Unknown';
  int _securityScore = 100;
  bool _hasOpenPorts = false;
  String _wifiSecurity = 'WPA2';

  @override
  void initState() {
    super.initState();
    // Load network data and request permissions
    _loadNetworkData();
    _requestPermissions();
    _calculateSecurityScore();
  }

  // Request permissions (location, notifications, storage)
  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.locationWhenInUse,
      Permission.notification,
      Permission.storage
    ];

    for (var permission in permissions) {
      if (await permission.status.isDenied) {
        await permission.request();
      }
    }
  }

  // Load the Wi-Fi name
  Future<void> _loadNetworkData() async {
    try {
      // Fetch Wi-Fi name
      final wifiName = await _networkService.getNetworkInfo();
      setState(() {
        _wifiName = wifiName['ssid'] ?? 'Unknown';
      });
    } catch (e) {
      print("Error loading network data: $e");
    }
  }

  // Calculate security score based on Wi-Fi security and open ports
  void _calculateSecurityScore() {
    setState(() {
      _securityScore = 100;
      // Subtract points for weaker security or vulnerabilities
      if (_wifiSecurity == 'WEP' || _wifiSecurity == 'Open/No Security')
        _securityScore -= 40;
      if (_hasOpenPorts) _securityScore -= 30;
    });
  }

  // Navigate to Security Details screen when "Improve Security" is clicked
  void _showFixSuggestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecurityDetailsScreen(
          securityScore: _securityScore,
          wifiSecurity: _wifiSecurity,
          hasOpenPorts: _hasOpenPorts,
        ),
      ),
    );
  }

  // Builds the security score card with network information and options to improve security
  Widget _buildSecurityScoreCard() {
    final Color scoreColor = _securityScore >= 80
        ? Colors.green
        : (_securityScore >= 50 ? Colors.orange : Colors.red);
    final String securityLevel = _securityScore >= 80
        ? "Secure"
        : (_securityScore >= 50 ? "Moderate" : "Vulnerable");

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNetworkInfoSection(), // Displays connected Wi-Fi info
            const SizedBox(height: 16),
            _buildSecurityScoreSection(scoreColor, securityLevel), // Displays the security score
            const SizedBox(height: 16),
            _buildSecurityButton(scoreColor), // Button to improve security
          ],
        ),
      ),
    );
  }

  // Displays the Wi-Fi network info (SSID)
  Widget _buildNetworkInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Wi-Fi icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: const Icon(Icons.wifi, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          // Network information (SSID)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Connected Network:",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(_wifiName,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Displays the security score with a circular progress indicator and security level
  Widget _buildSecurityScoreSection(Color scoreColor, String securityLevel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Network Security Score",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                value: _securityScore / 100,
                backgroundColor: Colors.grey.shade200,
                strokeWidth: 12,
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$_securityScore%",
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(securityLevel,
                    style: TextStyle(
                        fontSize: 16,
                        color: scoreColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Button to navigate to the Security Details screen
  Widget _buildSecurityButton(Color scoreColor) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.security),
      label: const Text("Improve Security"),
      onPressed: _showFixSuggestions,
      style: ElevatedButton.styleFrom(
        backgroundColor: scoreColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Settings button to navigate to SettingsScreen
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                      themeModeNotifier: widget.themeModeNotifier),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNetworkData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSecurityScoreCard(), // Displays the security score card
              const SizedBox(height: 20),
              // Dashboard buttons for different actions
              DashboardBuilder.buildDashboardButton(
                  label: 'Network Information',
                  icon: Icons.info,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NetworkInfoScreen()))),
              const SizedBox(height: 8),
              DashboardBuilder.buildDashboardButton(
                  label: 'Connected Devices',
                  icon: Icons.devices,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ConnectedDevicesScreen()))),
              const SizedBox(height: 8),
              DashboardBuilder.buildDashboardButton(
                  label: 'Help and Info',
                  icon: Icons.help,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HelpAndGuidanceScreen()))),
            ],
          ),
        ),
      ),
    );
  }
}
