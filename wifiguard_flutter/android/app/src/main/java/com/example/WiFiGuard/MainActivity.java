package com.example.WiFiGuard;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.chaquo.python.Python;
import com.chaquo.python.android.AndroidPlatform;

import android.util.Log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.*;

import android.net.wifi.ScanResult;

public class MainActivity extends FlutterActivity {
    private static final String NETWORK_CHANNEL = "com.example.network/info";
    private static final String PYTHON_CHANNEL = "com.example.wifiguard/python";
    private static final int REQUEST_LOCATION_PERMISSION = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize Python runtime if not already started
        if (!Python.isStarted()) {
            Python.start(new AndroidPlatform(this));
        }

        // Check both location and notification permissions on startup
        if (!checkPermissions() || !checkNotificationPermissions()) {
            requestPermissions();
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Channel for retrieving network information
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), NETWORK_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if ("getNetworkInfo".equals(call.method)) {
                        if (checkPermissions() && checkNotificationPermissions()) {
                            result.success(getNetworkInfo());
                        } else {
                            // Requests location and/or notification permissions to get network info
                            requestPermissions();
                            result.error("PERMISSION_DENIED", "Location and Notification permissions are required", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                });

        // Channel for starting the Python server
        new MethodChannel(getFlutterEngine().getDartExecutor(), PYTHON_CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if ("startPythonServer".equals(call.method)) {
                        // Start Python server in a separate thread
                        new Thread(() -> {
                            try {
                                // Call the Python script using Chaquopy
                                Python py = Python.getInstance();
                                py.getModule("scan").callAttr("run_flask_server");  // Directly call the function in the Python script
                                Log.d("Python", "Python server started");

                                result.success("Python server started");
                            } catch (Exception e) {
                                Log.e("Python", "Error starting server", e);
                                result.error("PYTHON_ERROR", "Error starting Python server: " + e.getMessage(), null);
                            }
                        }).start();
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    // Checks if location permissions are granted
    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED;
    }

    // Checks if notifications are granted
    private boolean checkNotificationPermissions() {
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
        return notificationManager.areNotificationsEnabled();
    }

    // Method to request location permissions if they aren't granted
    private void requestPermissions() {
        ActivityCompat.requestPermissions(
                this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSION);
    }

    // Method to retrieve network information
    private Map<String, String> getNetworkInfo() {
        Map<String, String> networkInfo = new HashMap<>();

        if (!checkPermissions()) {
            Log.e("MainActivity", "Location permission not granted");
            return networkInfo;
        }

        WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        if (wifiManager != null) {
            WifiInfo wifiInfo = wifiManager.getConnectionInfo();
            if (wifiInfo != null) {
                networkInfo.put("ssid", wifiInfo.getSSID() != null ? wifiInfo.getSSID() : "Unknown");
                networkInfo.put("bssid", wifiInfo.getBSSID() != null ? wifiInfo.getBSSID() : "Unknown");
                networkInfo.put("ip", intToIp(wifiInfo.getIpAddress()));
                networkInfo.put("signalStrength", String.valueOf(wifiInfo.getRssi()));
                networkInfo.put("frequency", wifiInfo.getFrequency() > 0 ? wifiInfo.getFrequency() + " MHz" : "Unknown");
                networkInfo.put("security", getSecurityProtocol(wifiManager));
            }
        }
        return networkInfo;
    }

    // Method to determine the security protocol of the current Wi-Fi network
    private String getSecurityProtocol(WifiManager wifiManager) {
        if (!checkPermissions()) {
            return "Unknown";
        }

        List<ScanResult> scanResults = wifiManager.getScanResults();
        WifiInfo currentConnection = wifiManager.getConnectionInfo();

        for (ScanResult result : scanResults) {
            if (currentConnection.getSSID().equals("\"" + result.SSID + "\"")) {
                String capabilities = result.capabilities;
                if (capabilities.contains("WPA3")) return "WPA3";
                if (capabilities.contains("WPA2")) return "WPA2";
                if (capabilities.contains("WEP")) return "WEP";
                return "Open/No Security";
            }
        }
        return "Unknown";
    }

    // Method to convert an integer IP address to a human-readable string format
    private String intToIp(int ipAddress) {
        return String.format("%d.%d.%d.%d",
                (ipAddress & 0xFF),
                (ipAddress >> 8 & 0xFF),
                (ipAddress >> 16 & 0xFF),
                (ipAddress >> 24 & 0xFF));
    }
}
