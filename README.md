# Wi-Fi Guard

Wi-Fi Guard is a Flutter-based Android application that improves home network security by 
scanning for vulnerabilities, listing connected devices, and offering AI-generated security 
recommendations. It is designed with non-technical users in mind, so it prioritises clarity, simplicity, 
and quick security fixes.

## Features

### Core Features

- **Connected Devices Scanner**
  - Scans your local Wi-Fi network and lists all connected devices.
  - Displays IP address, MAC address, device type, and risk indicators.
  - Allows users to label or flag suspicious devices.

- **Network Information Dashboard**
  - Displays key details about your network:
    - SSID
    - Signal strength
    - Encryption protocol (e.g., WPA2/WEP)
    - IP/Subnet data

- **AI Vulnerability Explanations**
  - Uses Gemini API to explain open ports or network risks in plain English.
  - Built-in assistant for general network security queries.

- **Security Alerts**
  - Warns users about:
    - Weak encryption
    - Public/open networks
    - Common vulnerabilities like port 22/3389 exposure

- **Dark/Light Mode**
  - Change the UI using shared preferences for persistent styling.

- **Offline Scan History**
  - View results from previous scans stored locally.

---

### Planned Features

- **Speed Test**
  - Measure download/upload/ping directly in-app.

- **Cloud Sync (Optional)**
  - Future support for encrypted scan history sync across devices.

- **Advanced CVE Lookup**
  - Match detected services against real-world vulnerabilities.

---
## Demo

[![Demo](https://img.youtube.com/vi/p-osD8AzM0U/0.jpg)](https://www.youtube.com/watch?v=p-osD8AzM0U)

---
## User Guide

### 1. Installation & Setup

#### Requirements
- Android 10 (API 29) or newer
- Internet connection (for AI explanations)
- Development tools needed to build APK:
  - [Python 3.8+](https://www.python.org/downloads/release/python-380)
  - [Flutter SDK 3.27+](https://docs.flutter.dev/release/archive)
  - [Java JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
  - [Android Studio](https://developer.android.com/studio)


#### Build Instructions
```
git clone https://github.com/elij35/WiFiGuard
cd WiFiGuard
flutter build apk
flutter install
```

- On app launch grant permissions when prompted:
   - **Location access** (required for Wi-Fi scanning on Android 12+)
   - **Storage access** (to store scan results)

- Accept terms of service — you must have permission to scan any network.

---

### Dashboard Overview

The Dashboard is the main screen and control center of the app.

- **Status Tile** – Shows if you're connected to Wi-Fi.
- **Navigation Tiles**:
  - Connected Devices
  - Network Info
  - Help & Guidance
  - Settings

---

### Running a Scan

1. Tap the **Scan** button on **Connected Devices Screen**.
2. Wait ~25 seconds for the scan to complete.
3. View results in **Connected Devices**.

Results include:
- IP address
- MAC address
- Device type (PC, IoT, etc.)
- Open ports

---

### Device Details

Tap on any device in the **Connected Devices** screen to view:
- Detected ports
- Risk score
- AI vulnerability explanation powered by Gemini

---

### Network Information

Access the **Network Info** screen to see:
- Your current SSID
- Encryption type (e.g., WPA2, WEP)
- Subnet IP
- Security tips

Warnings appear for:
- Unsecured networks
- Weak encryption (e.g. WEP)

---

### AI Security Assistant

You can ask questions using the Gemini AI integration.

1. Go to **Help & Guidance**.
2. Use the **AI Query Box** to ask:
   - “What does port 3389 do?”
   - “Is WEP encryption safe?”

You’ll receive easy-to-understand advice with context-specific examples.

---

### Scan History

Wi-Fi Guard saves previous scans locally.

- Open **Connected Devices** → tap the clock icon.
- View past results including device risks.
- Useful for identifying new or suspicious devices.

---

### Settings Menu

Customise the app experience from the **Settings** screen:
- Toggle **Dark / Light Theme**
- Enable/Disable **Notifications**
- Enable **Background Scanning**
- Clear scan history

All preferences are stored locally using Android's SharedPreferences.

---

### Privacy & Legal

- All scan data remains **local only** (never uploaded)
- No personally identifiable information (PII) is collected
- Scanning is **legally restricted to networks you own or manage**
- You must agree to terms before any scan is allowed

---

### Troubleshooting

| Issue | Fix |
|-------|-----|
| No devices found | Make sure you're connected to Wi-Fi and granted location permission. |
| AI not responding | Check internet connection or Gemini API usage limits. |
| Long scan time | Move closer to router or switch to 5GHz if available. |
| Notifications not working | Check Android notification permissions in system settings or on the settings page. |

---
