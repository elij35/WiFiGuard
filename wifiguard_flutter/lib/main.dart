import 'dart:io';

import 'package:WiFiGuard/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeMode = await _loadThemeMode();

  await _copyAndRunPythonScript();

  runApp(WiFiGuardApp(themeMode: themeMode));
}

// Asynchronous function to copy and start the Python server
Future<void> _copyAndRunPythonScript() async {
  try {
    if (!await Permission.storage.isGranted &&
        !await Permission.manageExternalStorage.isGranted) {
      return;
    }

    // Define target directory (Downloads folder)
    final Directory directory = Directory('/storage/emulated/0/Download/');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Define file path
    final String filePath = '${directory.path}/scan.py';

    // Read the Python script from assets (as bytes)
    final ByteData byteData = await rootBundle.load('assets/scan.py');

    // Write the Python script to the shared location
    final File file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    print("Python script copied successfully: $filePath");
  } catch (e) {
    print("Error copying Python script: $e");
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
