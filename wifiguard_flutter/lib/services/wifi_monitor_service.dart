import 'dart:async';

import 'package:WiFiGuard/services/network_info_service.dart';
import 'package:WiFiGuard/services/notification_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WifiMonitorService {
  final NetworkService _networkService = NetworkService();
  final NotificationService _notificationService = NotificationService();

  // Timer for periodic scanning
  Timer? _timer;

  // Track the monitoring state
  bool _isMonitoring = false;

  // Starts network monitoring with a periodic scan
  Future<void> startMonitoring() async {
    // Prevent starting multiple monitoring tasks
    if (_isMonitoring) {
      return;
    }

    // Load preferences
    final prefs = await SharedPreferences.getInstance();
    bool isMonitoringEnabled = prefs.getBool('isMonitoringEnabled') ?? true;
    int scanInterval =
        prefs.getInt('scanInterval') ?? 15; // Default is 15 minutes

    // If monitoring is disabled, stop any existing monitoring
    if (!isMonitoringEnabled) {
      stopMonitoring();
      return;
    }

    // Mark monitoring as active
    _isMonitoring = true;

    // Cancel any existing timer before starting a new one
    stopMonitoring();

    // Start periodic network scans
    _timer = Timer.periodic(Duration(minutes: scanInterval), (timer) async {
      await _checkNetworkSecurity();
    });

    // Perform an initial scan immediately when monitoring starts
    await _checkNetworkSecurity();
  }

  // Stops the monitoring process and cancels the timer
  void stopMonitoring() {
    _timer?.cancel();
    _isMonitoring = false; // Reset the monitoring state
  }

  // Starts a foreground service to notify the user that monitoring is active
  Future<void> startForegroundService() async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'WiFiGuard Running',
      notificationText: 'Monitoring your Wi-Fi security in the background.',
    );
  }

  // Checks the current network security and sends a notification if insecure
  Future<void> _checkNetworkSecurity() async {
    // Get current network info
    final networkInfo = await _networkService.getNetworkInfo();
    String security = networkInfo['security'] ?? 'Unknown';

    // Check if notifications are enabled in preferences
    final prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;

    // Exit if notifications are disabled
    if (!notificationsEnabled) return;

    // Alert user if the network is insecure
    if (security == 'WEP' || security == 'Open/No Security') {
      await _notificationService.showNotification(
        'Warning: Insecure Wi-Fi Detected',
        'Your current network uses $security security. Consider switching to a more secure network.',
      );
    }
  }
}
