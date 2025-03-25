import 'package:WiFiGuard/services/notification_service.dart';
import 'package:WiFiGuard/services/wifi_monitor_service.dart';
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
  late bool isMonitoringEnabled;
  late int scanInterval;

  final List<int> scanIntervals = [5, 10, 15, 30, 60]; // Scan interval options in minutes

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
      isMonitoringEnabled = prefs.getBool('isMonitoringEnabled') ?? true;
      scanInterval = prefs.getInt('scanInterval') ?? 15;
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

  void _toggleMonitoring(bool value) async {
    setState(() {
      isMonitoringEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMonitoringEnabled', isMonitoringEnabled);

    if (isMonitoringEnabled) {
      WifiMonitorService().startMonitoring();
    } else {
      WifiMonitorService().stopMonitoring();
    }
  }

  void _updateScanInterval(int? value) async {
    if (value == null) return;

    setState(() {
      scanInterval = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('scanInterval', scanInterval);

    if (isMonitoringEnabled) {
      WifiMonitorService().startMonitoring();
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
            const Divider(color: Colors.grey),
            UniversalBuilder.buildSettingTile(
              title: 'Enable Background Scanning',
              subtitle: 'Continuously monitor your network security',
              switchValue: isMonitoringEnabled,
              onSwitchChanged: _toggleMonitoring,
              activeColor: activeSwitchColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scan Frequency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    value: scanInterval,
                    items: scanIntervals
                        .map((interval) => DropdownMenuItem<int>(
                      value: interval,
                      child: Text('$interval min'),
                    ))
                        .toList(),
                    onChanged: _updateScanInterval,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
