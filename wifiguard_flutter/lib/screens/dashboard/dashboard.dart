import 'dart:async';

import 'package:WiFiGuard/screens/connected_devices/connected_devices.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_guidance.dart';
import 'package:WiFiGuard/screens/network_info/network_info.dart';
import 'package:WiFiGuard/screens/network_security_score/network_security_score.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _wifiName = 'Unknown';
  int _securityScore = 100;
  bool _hasOpenPorts = false;
  String _wifiSecurity = 'WPA2';

  @override
  void initState() {
    super.initState();
    _loadData();
    _requestPermissions();
  }

  Future<void> _loadData() async {
    await _loadNetworkData();
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

  // Navigate to Security Details screen when "Improve Security" is pressed
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

  @override
  Widget build(BuildContext context) {
    final Color scoreColor = _securityScore >= 80
        ? Colors.green
        : (_securityScore >= 50 ? Colors.orange : Colors.red);
    final String securityLevel = _securityScore >= 80
        ? "Secure"
        : (_securityScore >= 50 ? "Moderate" : "Vulnerable");

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
        key: _refreshIndicatorKey,
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DashboardBuilder.buildSecurityScoreCard(
              networkInfoSection:
                  DashboardBuilder.buildNetworkInfoSection(_wifiName, context),
              securityScoreSection: DashboardBuilder.buildSecurityScoreSection(
                  _securityScore, scoreColor, securityLevel),
              securityButton: DashboardBuilder.buildSecurityButton(
                  onPressed: _showFixSuggestions, scoreColor: scoreColor),
            ),
            const SizedBox(height: 20),
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
                        builder: (context) => const ConnectedDevicesScreen()))),
            const SizedBox(height: 8),
            DashboardBuilder.buildDashboardButton(
                label: 'Help and Guidance',
                icon: Icons.help,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpAndGuidanceScreen()))),
          ],
        ),
      ),
    );
  }
}
