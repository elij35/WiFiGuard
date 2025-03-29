import 'package:flutter/material.dart';

class SettingsBuilder {
  static Widget buildSettingTile({
    required String title,
    required String subtitle,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    required Color activeColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
