import 'package:flutter/material.dart';

class NetworkInfoBuilder {
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
}
