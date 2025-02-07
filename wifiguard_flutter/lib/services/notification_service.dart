import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    bool isEnabled =
        prefs.getBool('notificationsEnabled') ?? true; // Correct preference key

    if (!isEnabled)
      return; // Don't send notification if notifications are disabled

    const androidDetails = AndroidNotificationDetails(
      'wifi_guard_channel',
      'Wi-Fi Guard',
      channelDescription: 'Notifications for Wi-Fi Guard',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
