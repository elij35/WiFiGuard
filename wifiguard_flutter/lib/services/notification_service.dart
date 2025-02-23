import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Flutter Local Notifications plugin instance
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initializes notifications when the service is created
  NotificationService() {
    initializeNotifications();
  }

  // Initializes the notification settings
  Future<void> initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    // Initialize the plugin with settings
    await _notificationsPlugin.initialize(initSettings);
  }

  // Displays a notification with the given title and body
  Future<void> showNotification(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();

    // Check if notifications are enabled in user preferences
    bool isEnabled =
        prefs.getBool('notificationsEnabled') ?? true; // Default to enabled

    if (!isEnabled) return; // Exit if notifications are disabled

    // Notification details for Android
    const androidDetails = AndroidNotificationDetails(
      'wifi_guard_channel', // Unique channel ID
      'Wi-Fi Guard', // Channel name
      channelDescription: 'Notifications for Wi-Fi Guard',
      importance: Importance.max, // High importance
      priority: Priority.high, // High priority for immediate delivery
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Show the notification
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  // Cancels all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
