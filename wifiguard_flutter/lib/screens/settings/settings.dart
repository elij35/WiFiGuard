import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsScreen({super.key, required this.themeModeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;
  bool isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.themeModeNotifier.value == ThemeMode.dark;
  }

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
      widget.themeModeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark or light
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeSwitchColor =
        isDarkTheme ? Color(0xff1ab864) : Color(0xff008f4a);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dark Mode Toggle
          buildSettingTile(
            context,
            title: 'Dark Mode',
            subtitle: 'Toggle between dark and light themes',
            switchValue: isDarkMode,
            onSwitchChanged: _toggleTheme,
            activeColor: activeSwitchColor,
          ),
          const Divider(color: Colors.grey),

          // Notifications Toggle
          buildSettingTile(
            context,
            title: 'Enable Notifications',
            subtitle: 'Receive notifications for network activity',
            switchValue: isNotificationsEnabled,
            onSwitchChanged: (value) {
              setState(() {
                isNotificationsEnabled = value;
              });
            },
            activeColor: activeSwitchColor,
          ),
        ],
      ),
    );
  }
}