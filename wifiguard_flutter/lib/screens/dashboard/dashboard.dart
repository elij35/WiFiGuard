import 'package:flutter/material.dart';
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
            onPressed: () {},
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
              onTap: () {},
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