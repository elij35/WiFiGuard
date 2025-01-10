import 'package:WiFiGuard/widgets/tile_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsScreen({super.key, required this.themeModeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode;
  late bool isNotificationsEnabled;

  @override
  void initState() {
    super.initState();
    // Set the initial theme mode based on the current theme in the app
    isDarkMode = widget.themeModeNotifier.value == ThemeMode.dark;
    _loadSettings();
  }

  // Loads saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      // Load the saved dark mode setting
      isDarkMode = prefs.getBool('isDarkMode') ??
          (widget.themeModeNotifier.value == ThemeMode.dark);
    });
  }

  // Toggles the app theme and saves it
  void _toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
      widget.themeModeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode); // Save the theme preference
  }

  // Toggles notifications and saves the setting
  void _toggleNotifications(bool value) async {
    setState(() {
      isNotificationsEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', isNotificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark or light
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeSwitchColor =
        isDarkTheme ? const Color(0xff1ab864) : const Color(0xff008f4a);

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
            onSwitchChanged: _toggleNotifications,
            activeColor: activeSwitchColor,
          ),
        ],
      ),
    );
  }
}