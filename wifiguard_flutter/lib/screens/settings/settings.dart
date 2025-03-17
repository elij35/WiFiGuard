import 'package:WiFiGuard/services/notification_service.dart';
import 'package:WiFiGuard/widgets/universal_tile_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const SettingsScreen({super.key, required this.themeModeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkMode; // Stores dark mode preference
  late bool isNotificationsEnabled; // Stores notification preference

  @override
  void initState() {
    super.initState();
    // Set default theme based on system theme if no preference is stored
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the system theme first
    final systemBrightness = MediaQuery.of(context).platformBrightness;
    bool systemIsDarkMode = systemBrightness == Brightness.dark;

    // Retrieve stored preferences
    setState(() {
      isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      // Use saved dark mode preference or system default if not saved
      isDarkMode = prefs.getBool('isDarkMode') ?? systemIsDarkMode;
    });

    // Set themeModeNotifier value based on loaded setting
    widget.themeModeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;

    // Initialize notifications if they are enabled
    if (isNotificationsEnabled) {
      NotificationService().initializeNotifications();
    }
  }

  void _toggleTheme(bool value) async {
    // Switch between dark and light mode
    setState(() {
      isDarkMode = value;
      widget.themeModeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode); // Store preference
  }

  void _toggleNotifications(bool value) async {
    // Enable/Disable notifications
    setState(() {
      isNotificationsEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', isNotificationsEnabled);

    if (isNotificationsEnabled) {
      NotificationService().initializeNotifications();
    } else {
      NotificationService().cancelAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeSwitchColor =
        isDarkTheme ? const Color(0xff1ab864) : const Color(0xff008f4a);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UniversalBuilder.buildSettingTile(
              title: 'Dark Mode',
              subtitle: 'Toggle between dark and light themes',
              switchValue: isDarkMode,
              onSwitchChanged: _toggleTheme,
              activeColor: activeSwitchColor,
            ),
            const Divider(color: Colors.grey),
            UniversalBuilder.buildSettingTile(
              title: 'Enable Notifications',
              subtitle: 'Receive notifications for network activity',
              switchValue: isNotificationsEnabled,
              onSwitchChanged: _toggleNotifications,
              activeColor: activeSwitchColor,
            ),
          ],
        ),
      ),
    );
  }
}
