import 'package:WiFiGuard/screens/connected_devices/connected_devices.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_info.dart';
import 'package:WiFiGuard/screens/network_info/network_info.dart';
import 'package:WiFiGuard/screens/settings/settings.dart';
import 'package:WiFiGuard/services/connected_devices_service.dart';
import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';

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
  final ConnectedDevicesService _connectedDevicesService =
      ConnectedDevicesService();

  String _wifiName = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadNetworkData();
  }

  Future<void> _loadNetworkData() async {
    try {
      // Fetch Wi-Fi name
      final wifiName = await _connectedDevicesService.getWifiName();
      setState(() {
        _wifiName = wifiName;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            buildDashboardButton(
              context,
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
            buildDashboardButton(
              context,
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
            buildDashboardButton(
              context,
              label: 'Help and Info',
              icon: Icons.help,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpAndInfoScreen(),
                  ),
                );
              },
            ),
            buildDashboardButton(
              context,
              label: 'Speed Test',
              icon: Icons.speed,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
