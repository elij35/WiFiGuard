import 'package:flutter/material.dart';

class NetworkSecurityScoreService {
  // Calculates the security score based on Wi-Fi security and open ports
  int calculateSecurityScore(String wifiSecurity, bool hasOpenPorts) {
    int securityScore = 100;

    // Subtract points for weaker security or open ports
    if (wifiSecurity == 'WEP' || wifiSecurity == 'Open/No Security') {
      securityScore -= 60;
    }
    if (hasOpenPorts) securityScore -= 40;
    return securityScore;
  }

  // Determines colour based on the security score
  Color getScoreColor(int securityScore) {
    return securityScore >= 80
        ? Colors.green
        : (securityScore >= 50 ? Colors.orange : Colors.red);
  }

  // Gets security level text based on score
  String getSecurityLevel(int securityScore) {
    return securityScore >= 80
        ? "Secure"
        : (securityScore >= 50 ? "Moderate" : "Vulnerable");
  }
}
