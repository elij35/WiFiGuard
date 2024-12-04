import 'package:flutter/material.dart';
import 'package:guard/screens/connected_devices/connected_devices.dart';
import 'package:guard/screens/help_and_guidance/help_and_info.dart';
import 'package:guard/screens/network_info/network_info.dart';
import 'package:guard/screens/settings/settings.dart';
import 'package:guard/widgets/tile_builder.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                  builder: (context) => const SettingsScreen(),
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
              color: Colors.blue,
              child: ListTile(
                leading: const Icon(Icons.wifi, color: Colors.white),
                title: const Text(
                  'Android Wifi',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Connected',
                  style: TextStyle(color: Colors.green),
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