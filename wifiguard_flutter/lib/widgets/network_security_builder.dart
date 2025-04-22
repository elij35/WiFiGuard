import 'package:WiFiGuard/services/network_security_score_service.dart';
import 'package:flutter/material.dart';

class NetworkSecurityScoreBuilder {
  final NetworkSecurityScoreService _scoreService =
      NetworkSecurityScoreService();

  // Builds the main score display with a circular progress indicator
  Widget buildScoreCard(int securityScore, Color scoreColor) {
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
                      // Use actual method call to get label
                      Text(
                        _scoreService.getSecurityLevel(securityScore),
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
  Widget buildSecurityFactor(
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
