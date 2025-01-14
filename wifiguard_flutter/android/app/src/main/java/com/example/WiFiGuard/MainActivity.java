package com.example.WiFiGuard;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.net.wifi.ScanResult;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.network/info";
    private static final int REQUEST_LOCATION_PERMISSION = 1;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if ("getNetworkInfo".equals(call.method)) {
                        if (checkPermissions()) {
                            result.success(getNetworkInfo());
                        } else {
                            requestPermissions();
                            result.error("PERMISSION_DENIED", "Location permission is required", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(
                this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSION);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_LOCATION_PERMISSION &&
                grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            // Permission granted; no additional action needed
        }
    }

    private Map<String, String> getNetworkInfo() {
        Map<String, String> networkInfo = new HashMap<>();
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

    private String getSecurityProtocol(WifiManager wifiManager) {
        if (checkPermissions()) {
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
        }
        return "Unknown";
    }

    private String intToIp(int ipAddress) {
        return String.format("%d.%d.%d.%d",
                (ipAddress & 0xFF),
                (ipAddress >> 8 & 0xFF),
                (ipAddress >> 16 & 0xFF),
                (ipAddress >> 24 & 0xFF));
    }
}