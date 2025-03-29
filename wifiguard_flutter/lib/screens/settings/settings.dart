import 'package:WiFiGuard/services/notification_service.dart';
import 'package:WiFiGuard/services/wifi_monitor_service.dart';
import 'package:WiFiGuard/widgets/settings_builder.dart';
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
  late bool isMonitoringEnabled;
  late int scanInterval;

  // Scan interval options in minutes
  final List<int> scanIntervals = [
    360, // 6 hours
    720, // 12 hours
    1440, // 1 day
    10080, // 1 week
    43200, // 1 month
  ];

  // Loads settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Get system theme preference
    final systemBrightness = MediaQuery.of(context).platformBrightness;
    bool systemIsDarkMode = systemBrightness == Brightness.dark;

    // Load settings from SharedPreferences
    setState(() {
      isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      isDarkMode = prefs.getBool('isDarkMode') ?? systemIsDarkMode;
      isMonitoringEnabled = prefs.getBool('isMonitoringEnabled') ?? false;
      scanInterval = prefs.getInt('scanInterval') ?? 1440; // Default to 1 day
    });

    // Set the theme mode based on loaded settings
    widget.themeModeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;

    // Initialise notifications if enabled
    if (isNotificationsEnabled) {
      NotificationService().initialiseNotifications();
    }
  }

  // Helper function to convert minutes to human-readable format
  String _formatInterval(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60} hour${minutes ~/ 60 == 1 ? '' : 's'}';
    } else if (minutes == 1440) {
      return '1 day';
    } else if (minutes == 10080) {
      return '1 week';
    } else if (minutes == 43200) {
      return '1 month';
    } else {
      return '${minutes ~/ 1440} days';
    }
  }

  // Toggle theme between light and dark
  void _toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
      widget.themeModeNotifier.value =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    // Save theme mode preference
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Toggles notifications
  void _toggleNotifications(bool value) async {
    setState(() {
      isNotificationsEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', isNotificationsEnabled);

    if (isNotificationsEnabled) {
      NotificationService().initialiseNotifications();
    } else {
      NotificationService().cancelAllNotifications();
    }
  }

  // Toggles background network monitoring
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

  // Updates the scan interval
  void _updateScanInterval(int? value) async {
    if (value == null || value == scanInterval) return;

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
  void initState() {
    super.initState();

    // Default values before loading from SharedPreferences
    isDarkMode = true;
    isNotificationsEnabled = true;
    isMonitoringEnabled = false;
    scanInterval = 1440; // Default to 1 day
    _loadSettings();
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
            // Dark Mode Toggle
            _buildSettingTile(
              title: 'Dark Mode',
              subtitle: 'Toggle between dark and light themes',
              switchValue: isDarkMode,
              onSwitchChanged: _toggleTheme,
              activeColor: activeSwitchColor,
            ),
            const Divider(color: Colors.grey),

            // Notifications Toggle
            _buildSettingTile(
              title: 'Enable Notifications',
              subtitle: 'Receive notifications for network activity',
              switchValue: isNotificationsEnabled,
              onSwitchChanged: _toggleNotifications,
              activeColor: activeSwitchColor,
            ),
            const Divider(color: Colors.grey),

            // Background Scanning Toggle
            _buildSettingTile(
              title: 'Background Scanning',
              subtitle: 'Continuous network security monitoring',
              switchValue: isMonitoringEnabled,
              onSwitchChanged: _toggleMonitoring,
              activeColor: activeSwitchColor,
            ),

            // Scan Interval Dropdown
            if (isMonitoringEnabled) ...[
              _buildScanIntervalDropdown(),
            ],

            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Builds a setting tile with a switch
  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool switchValue,
    required ValueChanged<bool> onSwitchChanged,
    required Color activeColor,
  }) {
    return SettingsBuilder.buildSettingTile(
      title: title,
      subtitle: subtitle,
      switchValue: switchValue,
      onSwitchChanged: onSwitchChanged,
      activeColor: activeColor,
    );
  }

  // Builds the scan interval dropdown
  Widget _buildScanIntervalDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scan Frequency',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              DropdownButton<int>(
                value: scanInterval,
                items: scanIntervals
                    .map((interval) => DropdownMenuItem<int>(
                          value: interval,
                          child: Text(
                            _formatInterval(interval),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: _updateScanInterval,
                underline: Container(),
                borderRadius: BorderRadius.circular(8),
                dropdownColor: Theme.of(context).cardColor,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
