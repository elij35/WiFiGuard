import 'package:flutter/material.dart';
import 'package:guard/widgets/tile_builder.dart';
import 'package:guard/screens/settings/settings.dart';
import 'package:guard/screens/help_and_guidance/help_and_info.dart';

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
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            buildDashboardButton(
              context,
              label: 'Network Information',
              icon: Icons.info,
              onTap: () {},
            ),
            buildDashboardButton(
              context,
              label: 'Connected Devices',
              icon: Icons.devices,
              onTap: () {},
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