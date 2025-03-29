import 'package:flutter/material.dart';

class DashboardBuilder {
  // Dashboard Button Builder
  static Widget buildDashboardButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }

  // Builds the security score card with network information and options to improve security
  static Widget buildSecurityScoreCard({
    required Widget networkInfoSection,
    required Widget securityScoreSection,
    required Widget securityButton,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            networkInfoSection, // Displays connected Wi-Fi info
            const SizedBox(height: 16),
            securityScoreSection, // Displays the security score
            const SizedBox(height: 16),
            securityButton, // Button to improve security
          ],
        ),
      ),
    );
  }

  // Displays the Wi-Fi network info (SSID)
  static Widget buildNetworkInfoSection(String wifiName, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Wi-Fi icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: const Icon(Icons.wifi, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Connected Network:",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(wifiName,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Displays the security score with a circular progress indicator and security level
  static Widget buildSecurityScoreSection(
      int securityScore, Color scoreColor, String securityLevel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                value: securityScore / 100,
                backgroundColor: Colors.grey.shade200,
                strokeWidth: 12,
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$securityScore%",
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(securityLevel,
                    style: TextStyle(
                        fontSize: 16,
                        color: scoreColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Button to navigate to the Security Details screen
  static Widget buildSecurityButton(
      {required VoidCallback onPressed, required Color scoreColor}) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.security),
      label: const Text("Improve Security"),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: scoreColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
