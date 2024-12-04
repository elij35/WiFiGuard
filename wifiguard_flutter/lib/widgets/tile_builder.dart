import 'package:flutter/material.dart';

// Tiles used on help and guidance pages (list format)
Widget buildHelpTopicCard(
  BuildContext context, {
  required String title,
  required String description,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDashboardButton(BuildContext context,
    {required String label,
    required IconData icon,
    required VoidCallback onTap}) {
  return Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    ),
  );
}