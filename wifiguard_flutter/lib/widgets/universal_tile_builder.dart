import 'package:flutter/material.dart';

class UniversalBuilder {
  // Dashboard Button Builder
  static Widget buildDashboardButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }

  // Network Info Section Header Builder
  static Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Network Info Card Builder
  static Widget buildNetworkInfoCard(
      IconData icon, String label, String value) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }

  // Security Card Builder for Wi-Fi protocols Network Info Screen
  static Widget buildSecurityCard(String security) {
    IconData icon = Icons.lock;
    Color iconColor = Colors.green;
    String statusMessage = "Your network is secure.";

    if (security == 'WEP' || security == 'Open/No Security') {
      icon = Icons.warning_amber_rounded;
      iconColor = Colors.red;
      statusMessage = "Your network is at risk! Consider upgrading to WPA2.";
    } else if (security == 'WPA2') {
      icon = Icons.security;
      iconColor = Colors.blue;
      statusMessage = "Your network is secure.";
    }

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text('Security Protocol: $security'),
        subtitle: Text(statusMessage),
      ),
    );
  }

  // Settings Tile Builder
  static Widget buildSettingTile({
    required String title,
    required String subtitle,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    required Color activeColor,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.settings, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: switchValue,
          onChanged: onSwitchChanged,
          activeColor: activeColor,
        ),
      ),
    );
  }
}
