package com.example.guard;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import android.net.wifi.ScanResult;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.network/info";
    private static final int REQUEST_LOCATION_PERMISSION = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getNetworkInfo")) {
                                if (checkPermissions()) {
                                    Map<String, String> networkInfo = getNetworkInfo();
                                    result.success(networkInfo);
                                } else {
                                    requestPermissions();
                                    result.error("PERMISSION_DENIED", "Location permission is required", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    // Checking all permissions
    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSION);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_LOCATION_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, do nothing; Flutter will handle subsequent requests
            }
        }
    }

    //Detecting the network information on the network information screen
    private Map<String, String> getNetworkInfo() {
        Map<String, String> networkInfo = new HashMap<>();
        WifiManager wifiManager = (WifiManager) getSystemService(Context.WIFI_SERVICE);

        if (wifiManager != null) {
            WifiInfo wifiInfo = wifiManager.getConnectionInfo();

            if (wifiInfo != null) {
                String ssid = wifiInfo.getSSID();
                String bssid = wifiInfo.getBSSID();
                int ipAddress = wifiInfo.getIpAddress();
                int signalStrength = wifiInfo.getRssi();
                int frequency = wifiInfo.getFrequency();

                Log.d("NetworkInfo", "SSID: " + ssid);
                Log.d("NetworkInfo", "BSSID: " + bssid);
                Log.d("NetworkInfo", "IP: " + intToIp(ipAddress));
                Log.d("NetworkInfo", "Signal Strength (RSSI): " + signalStrength);
                Log.d("NetworkInfo", "Frequency: " + frequency);

                networkInfo.put("ssid", ssid != null ? ssid : "Unknown");
                networkInfo.put("bssid", bssid != null ? bssid : "Unknown");
                networkInfo.put("ip", intToIp(ipAddress));
                networkInfo.put("signalStrength", String.valueOf(signalStrength));
                networkInfo.put("frequency", frequency > 0 ? frequency + " MHz" : "Unknown");
                networkInfo.put("security", getSecurityProtocol(wifiManager));
            } else {
                Log.d("NetworkInfo", "WifiInfo is null");
            }
        } else {
            Log.d("NetworkInfo", "WifiManager is null");
        }

        return networkInfo;
    }

    // Get Security Protocol
    @SuppressWarnings("deprecation")
    private String getSecurityProtocol(WifiManager wifiManager) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            List<ScanResult> scanResults = wifiManager.getScanResults();

            for (ScanResult result : scanResults) {
                if (wifiManager.getConnectionInfo().getSSID().equals("\"" + result.SSID + "\"")) {
                    String capabilities = result.capabilities;
                    if (capabilities.contains("WPA3")) {
                        return "WPA3";
                    } else if (capabilities.contains("WPA2")) {
                        return "WPA2";
                    } else if (capabilities.contains("WEP")) {
                        return "WEP";
                    } else {
                        return "Open/No Security";
                    }
                }
            }
        }
        return "Unknown";
    }

    // Convert integer IP address to string format
    private String intToIp(int ipAddress) {
        return String.format("%d.%d.%d.%d",
                (ipAddress & 0xFF),
                (ipAddress >> 8 & 0xFF),
                (ipAddress >> 16 & 0xFF),
                (ipAddress >> 24 & 0xFF));
    }
}