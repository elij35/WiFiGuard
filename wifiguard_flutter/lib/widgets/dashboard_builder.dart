import 'package:flutter/material.dart';

class DashboardBuilder {
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
}
