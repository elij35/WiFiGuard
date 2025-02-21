import 'package:WiFiGuard/screens/dashboard/dashboard.dart';
import 'package:WiFiGuard/services/notification_service.dart';
import 'package:WiFiGuard/services/wifi_monitor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications when app starts
  await NotificationService().initializeNotifications();

  // Load the saved theme mode from shared preferences
  final themeMode = await _loadThemeMode();

  // Start Wi-Fi background scan
  WifiMonitorService().startMonitoring();

  // Run Python server in the background
  _startPythonServer();

  runApp(WiFiGuardApp(themeMode: themeMode));
}

// Asynchronous function to start the Python server
void _startPythonServer() async {
  const platform = MethodChannel('com.example.wifiguard/python');
  try {
    // Start the Python server
    await platform.invokeMethod('startPythonServer');
    print("Python server started successfully");

    // Wait for 2 seconds before checking server status
    await Future.delayed(Duration(seconds: 2));

    final response = await http.get(Uri.parse('http://127.0.0.1:5000'));
    if (response.statusCode == 200) {
      print("Python server is running!");
    } else {
      print("Python server did not start correctly.");
    }
  } catch (e) {
    print("Error starting Python server: $e");
  }
}

// Load the theme mode from SharedPreferences
Future<ThemeMode> _loadThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  return isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

class WiFiGuardApp extends StatelessWidget {
  final ThemeMode themeMode;

  const WiFiGuardApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = ValueNotifier(themeMode);

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
