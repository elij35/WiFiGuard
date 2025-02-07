import 'package:WiFiGuard/services/notification_service.dart';
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
    isDarkMode = widget.themeModeNotifier.value == ThemeMode.dark;
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled =
          prefs.getBool('notificationsEnabled') ?? true; // Default to true
      isDarkMode = prefs.getBool('isDarkMode') ?? isDarkMode;
    });

    // Initialize notifications if they are enabled
    if (isNotificationsEnabled) {
      NotificationService().initializeNotifications();
    }
  }

  // Toggle theme mode
  void _toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
      widget.themeModeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Toggle notifications
  void _toggleNotifications(bool value) async {
    setState(() {
      isNotificationsEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', isNotificationsEnabled);

    if (isNotificationsEnabled) {
      NotificationService().initializeNotifications(); // Enable notifications
    } else {
      NotificationService().cancelAllNotifications(); // Disable notifications
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeSwitchColor =
        isDarkTheme ? const Color(0xff1ab864) : const Color(0xff008f4a);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildSettingTile(
            context,
            title: 'Dark Mode',
            subtitle: 'Toggle between dark and light themes',
            switchValue: isDarkMode,
            onSwitchChanged: _toggleTheme,
            activeColor: activeSwitchColor,
          ),
          const Divider(color: Colors.grey),
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
