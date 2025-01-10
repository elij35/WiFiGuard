import 'package:WiFiGuard/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Provide a default themeMode for testing to avoid async dependency.
    await tester.pumpWidget(WiFiGuardApp(themeMode: ThemeMode.light));

    // Verify that some part of the app is built correctly
    expect(find.text('Dashboard'), findsOneWidget);
  });
}