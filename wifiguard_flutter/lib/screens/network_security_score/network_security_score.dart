import 'package:WiFiGuard/services/network_security_score_service.dart';
import 'package:WiFiGuard/widgets/network_security_builder.dart';
import 'package:flutter/material.dart';

class NetworkSecurityScoreScreen extends StatelessWidget {
  final int securityScore;
  final String wifiSecurity;
  final bool hasOpenPorts;

  const NetworkSecurityScoreScreen({
    super.key,
    required this.securityScore,
    required this.wifiSecurity,
    required this.hasOpenPorts,
  });

  @override
  Widget build(BuildContext context) {
    final NetworkSecurityScoreService securityScoreService =
        NetworkSecurityScoreService();
    final NetworkSecurityScoreBuilder securityBuilder =
        NetworkSecurityScoreBuilder();

    final Color scoreColor = securityScoreService.getScoreColor(securityScore);

    return Scaffold(
      appBar: AppBar(title: const Text('Security Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the main security score
            securityBuilder.buildScoreCard(securityScore, scoreColor),
            const SizedBox(height: 24),

            // List security factors with status and tips
            securityBuilder.buildSecurityFactor(
              "Wi-Fi Security",
              wifiSecurity,
              wifiSecurity == 'WPA2' || wifiSecurity == 'WPA3',
              "Use WPA2/WPA3.",
            ),
            securityBuilder.buildSecurityFactor(
              "Open Ports",
              hasOpenPorts ? "Detected" : "None",
              !hasOpenPorts,
              "Close unnecessary ports.",
            ),
          ],
        ),
      ),
    );
  }
}
