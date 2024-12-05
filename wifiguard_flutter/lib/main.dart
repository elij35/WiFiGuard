import 'package:flutter/material.dart';
import 'package:guard/screens/dashboard/dashboard.dart';

void main() {
  runApp(WiFiGuardApp());
}

class WiFiGuardApp extends StatelessWidget {
  // Centralized theme mode state
  final ValueNotifier<ThemeMode> themeModeNotifier =
  ValueNotifier(ThemeMode.light);

  WiFiGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
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