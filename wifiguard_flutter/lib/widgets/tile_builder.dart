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

//Buttons on the dashboard
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

//Rows on network stats screen
class NetworkInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const NetworkInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

// Helper method to build each switch tile
  Widget buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xff1dfd42),
        // Customize switch active color
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey[700],
      ),
    );
  }
}