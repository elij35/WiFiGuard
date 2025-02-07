import 'dart:async';
import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/services/notification_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WifiMonitorService {
  final NetworkService _networkService = NetworkService();
  final NotificationService _notificationService = NotificationService();
  Timer? _timer;

  void startMonitoring() {
    // Run the check every 15 minutes
    _timer = Timer.periodic(const Duration(minutes: 15), (timer) async {
      await _checkNetworkSecurity();
    });

    _checkNetworkSecurity(); // Check immediately on startup
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  Future<void> startForegroundService() async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'WiFiGuard Running',
      notificationText: 'Monitoring your Wi-Fi security in the background.',
    );
  }

  Future<void> _checkNetworkSecurity() async {
    final networkInfo = await _networkService.getNetworkInfo();
    String security = networkInfo['security'] ?? 'Unknown';

    // Check if notifications are enabled in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;

    if (!notificationsEnabled) return; // Don't send notification if disabled

    if (security == 'WEP' || security == 'Open/No Security') {
      await _notificationService.showNotification(
        '⚠️ Insecure Wi-Fi Detected',
        'Your current network is using $security security. Consider switching to a more secure network.',
      );
    }
  }
}
