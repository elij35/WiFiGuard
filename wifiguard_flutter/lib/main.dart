import 'dart:io';

import 'package:WiFiGuard/screens/dashboard/dashboard.dart';
import 'package:WiFiGuard/services/wifi_monitor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the theme mode based on saved preferences or system default
  final themeMode = await _loadThemeMode();

  // Request storage permissions
  await _requestStoragePermissions();

  // Copy and run the Python script for network scanning
  await _copyAndRunPythonScript();

  // Initialise Wi-Fi monitoring service
  final wifiMonitor = WifiMonitorService();
  wifiMonitor.startForegroundService(); // Start background service
  wifiMonitor.startMonitoring(); // Start periodic monitoring

  runApp(WiFiGuardApp(themeMode: themeMode));
}

// Load the theme mode from SharedPreferences or use system default
Future<ThemeMode> _loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode');

  // Fallback to system theme if no preference is found
  if (isDarkMode == null) {
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  // Return the saved theme mode
  return isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

// Request storage and external storage permissions
Future<void> _requestStoragePermissions() async {
  await [
    Permission.storage, // For file storage access
    Permission.manageExternalStorage, // Android 11+ access to external storage
  ].request();
}

// Copy the Python script to a shared location on the device
Future<void> _copyAndRunPythonScript() async {
  try {
    if (!await Permission.storage.isGranted &&
        !await Permission.manageExternalStorage.isGranted) {
      return; // Exit if permission is not granted
    }

    final Directory directory = Directory('/storage/emulated/0/Download/');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true); // Create directory if not exists
    }

    final String filePath = '${directory.path}/scan.py';
    final ByteData byteData = await rootBundle.load('assets/scan.py');

    final File file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    print("Python script copied successfully: $filePath");
  } catch (e) {
    print("Error copying Python script: $e");
  }
}

// The main application widget
class WiFiGuardApp extends StatelessWidget {
  final ThemeMode themeMode;

  const WiFiGuardApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = ValueNotifier<ThemeMode>(themeMode);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Wi-Fi Guard',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: DashboardScreen(themeModeNotifier: themeModeNotifier),
        );
      },
    );
  }
}
