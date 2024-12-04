import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (value) {
            },
          ),

          const Divider(color: Colors.grey),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: false,
            onChanged: (value) {
            },
          ),
        ],
      ),
    );
  }
}