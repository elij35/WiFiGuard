import 'package:flutter/material.dart';

//Dashboard layout
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

// Settings layout
Widget buildSettingTile(
  BuildContext context, {
  required String title,
  required String subtitle,
  required bool switchValue,
  required ValueChanged<bool> onSwitchChanged,
  required Color activeColor,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: activeColor,
      ),
    ),
  );
}
