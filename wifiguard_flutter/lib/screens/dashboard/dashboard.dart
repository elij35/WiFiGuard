import 'dart:async';

import 'package:WiFiGuard/screens/connected_devices/connected_devices.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_guidance.dart';
import 'package:WiFiGuard/screens/network_info/network_info.dart';
import 'package:WiFiGuard/screens/settings/settings.dart';
import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/widgets/universal_tile_builder.dart';
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

  @override
  void initState() {
    super.initState();
    _loadNetworkData(); // Fetch SSID immediately on app launch
    _requestPermissions(); // Request permissions if necessary
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.locationWhenInUse,
      Permission.notification,
      Permission.storage,
    ];

    for (var permission in permissions) {
      if (await permission.status.isDenied) {
        await permission.request();
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                color: Color(0xff00177c),
                child: ListTile(
                  leading: const Icon(Icons.wifi, color: Colors.white),
                  title: Text(
                    "SSID: $_wifiName",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Connected',
                    style: TextStyle(color: Color(0xff00f16b)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NetworkInfoScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              UniversalBuilder.buildDashboardButton(
                label: 'Network Information',
                icon: Icons.info,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NetworkInfoScreen(),
                    ),
                  );
                },
              ),
              UniversalBuilder.buildDashboardButton(
                label: 'Connected Devices',
                icon: Icons.devices,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectedDevicesScreen(),
                    ),
                  );
                },
              ),
              UniversalBuilder.buildDashboardButton(
                label: 'Help and Info',
                icon: Icons.help,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpAndGuidanceScreen(),
                    ),
                  );
                },
              ),
              UniversalBuilder.buildDashboardButton(
                label: 'Speed Test',
                icon: Icons.speed,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
