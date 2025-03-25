import 'dart:async';

import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/services/notification_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WifiMonitorService {
  final NetworkService _networkService = NetworkService();
  final NotificationService _notificationService = NotificationService();
  Timer? _timer;

  Future<void> startMonitoring() async {
    final prefs = await SharedPreferences.getInstance();
    bool isMonitoringEnabled = prefs.getBool('isMonitoringEnabled') ?? true;
    int scanInterval = prefs.getInt('scanInterval') ?? 15; // Set the default is 15 min

    if (!isMonitoringEnabled) {
      stopMonitoring();
      return;
    }

    // Ensure previous timer is cleared before starting a new one
    stopMonitoring();

    // Start periodic network scans
    _timer = Timer.periodic(Duration(minutes: scanInterval), (timer) async {
      await _checkNetworkSecurity();
    });

    _checkNetworkSecurity(); // Initial scan when monitoring starts
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  // Sends a notification to say background monitoring has been enabled
  Future<void> startForegroundService() async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'WiFiGuard Running',
      notificationText: 'Monitoring your Wi-Fi security in the background.',
    );
  }

  Future<void> _checkNetworkSecurity() async {
    final networkInfo = await _networkService.getNetworkInfo();
    String security = networkInfo['security'] ?? 'Unknown';

    // Check if notifications are enabled
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;

    if (!notificationsEnabled) return; // Exit if notifications are disabled

    // Alert the user if the network is insecure
    if (security == 'WEP' || security == 'Open/No Security') {
      await _notificationService.showNotification(
        '⚠️ Insecure Wi-Fi Detected',
        'Your current network uses $security security. Consider switching to a more secure network.',
      );
    }
  }
}
