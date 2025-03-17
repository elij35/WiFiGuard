import 'package:WiFiGuard/screens/help_and_guidance/guides/changing_router_password.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/recognising_phishing_attacks.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/securing_network.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/using_2FA.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/using_vpn.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/updating_firmware.dart';
import 'package:flutter/material.dart';

class HelpAndGuidanceScreen extends StatelessWidget {
  const HelpAndGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Guidance')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTile(
            context,
            icon: Icons.router,
            title: 'Changing Router Password',
            description: 'Learn how to update your router\'s password securely.',
            targetPage: const ChangingRouterPasswordScreen(),
          ),
          _buildTile(
            context,
            icon: Icons.security,
            title: 'Securing Your Network',
            description: 'Best practices for ensuring a secure network.',
            targetPage: const SecuringNetworkScreen(),
          ),
          _buildTile(
            context,
            icon: Icons.vpn_lock,
            title: 'Using VPN',
            description: 'How to use a VPN to secure your internet activity.',
            targetPage: const UsingVPNScreen(),
          ),
          _buildTile(
            context,
            icon: Icons.phonelink_lock,
            title: 'Recognising Phishing Attacks',
            description: 'How to identify and avoid phishing scams.',
            targetPage: const RecognisingPhishingAttacks(),
          ),
          _buildTile(
            context,
            icon: Icons.system_update,
            title: 'Updating Firmware',
            description: 'Steps to keep your router firmware up to date.',
            targetPage: const UpdatingFirmwareScreen(),
          ),
          _buildTile(
            context,
            icon: Icons.verified_user,
            title: 'Using Two-Factor Authentication',
            description: 'How to set up and use 2FA for extra security.',
            targetPage: const UsingTwoFactorAuthScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required String title,
        required String description,
        required Widget targetPage}) {
    Color iconColor = Theme.of(context).colorScheme.onSurface; // Auto-adjust for dark/light mode

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward, color: iconColor),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => targetPage));
        },
      ),
    );
  }
}
