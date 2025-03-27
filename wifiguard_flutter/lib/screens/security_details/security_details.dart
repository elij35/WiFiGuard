import 'package:flutter/material.dart';

class SecurityDetailsScreen extends StatelessWidget {
  final int securityScore;
  final String wifiSecurity;
  final bool hasOpenPorts;

  const SecurityDetailsScreen({
    super.key,
    required this.securityScore,
    required this.wifiSecurity,
    required this.hasOpenPorts,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colour based on security score
    Color scoreColor = securityScore >= 80
        ? Colors.green
        : (securityScore >= 50 ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(title: const Text('Security Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the main security score
            _buildScoreCard(scoreColor),
            const SizedBox(height: 24),

            // List security factors with status and tips
            _buildSecurityFactor(
                "Wi-Fi Security",
                wifiSecurity,
                wifiSecurity == 'WPA2' || wifiSecurity == 'WPA3',
                "Use WPA2/WPA3."),
            _buildSecurityFactor(
                "Open Ports",
                hasOpenPorts ? "Detected" : "None",
                !hasOpenPorts,
                "Close unnecessary ports."),
          ],
        ),
      ),
    );
  }

  // Builds the main score display with a circular progress indicator
  Widget _buildScoreCard(Color scoreColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Your Network Security Score",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular progress bar to indicate score visually
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: CircularProgressIndicator(
                      value: securityScore / 100,
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 12,
                      valueColor: AlwaysStoppedAnimation(scoreColor),
                    ),
                  ),
                  // Display percentage score at top of page
                  Column(
                    children: [
                      Text(
                        "$securityScore%",
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Show security level based on score
                      Text(
                        securityScore >= 80
                            ? "Secure"
                            : (securityScore >= 50 ? "Moderate" : "Vulnerable"),
                        style: TextStyle(
                          fontSize: 18,
                          color: scoreColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a security factor card with its status and improvement tip
  Widget _buildSecurityFactor(
      String title, String value, bool isSafe, String tip) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: Icon(isSafe ? Icons.check_circle : Icons.warning,
            color: isSafe ? Colors.green : Colors.red),
      ),
    );
  }
}
