import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsScreen({Key? key, required this.themeModeNotifier})
      : super(key: key);

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
    // Determine if the current theme is dark or light
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Adjust the green color dynamically
    final activeSwitchColor =
        isDarkTheme ? Color(0xff1ab864) : Color(0xff008f4a);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: _toggleTheme,
            activeColor: activeSwitchColor, // Use dynamically set color
          ),
          const Divider(color: Colors.grey),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                isNotificationsEnabled = value;
              });
            },
            activeColor: activeSwitchColor, // Use dynamically set color
          ),
        ],
      ),
    );
  }
}