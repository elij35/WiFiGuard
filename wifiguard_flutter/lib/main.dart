import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard.dart';

void main() {
  runApp(const WiFiGuardApp());
}

class WiFiGuardApp extends StatelessWidget {
  const WiFiGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi Guard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}