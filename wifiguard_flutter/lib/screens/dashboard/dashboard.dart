import 'package:WiFiGuard/screens/connected_devices/connected_devices.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_info.dart';
import 'package:WiFiGuard/screens/network_info/network_info.dart';
import 'package:WiFiGuard/screens/settings/settings.dart';
import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const DashboardScreen({super.key, required this.themeModeNotifier});

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
                  builder: (context) =>
                      SettingsScreen(themeModeNotifier: themeModeNotifier),
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
                title: const Text(
                  'Android Wifi',
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