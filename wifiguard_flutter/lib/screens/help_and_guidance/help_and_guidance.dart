import 'package:WiFiGuard/screens/help_and_guidance/guides/changing_router_password.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/securing_network.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/using_vpn.dart';
import 'package:flutter/material.dart';

class HelpAndGuidanceScreen extends StatelessWidget {
  const HelpAndGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Guidance'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTile(
            context,
            icon: Icons.router,
            title: 'Changing Router Password',
            description:
                'Learn how to update your router\'s password securely.',
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
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required Widget targetPage}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkTheme
        ? Theme.of(context).colorScheme.secondary // Bright for dark theme
        : Theme.of(context).primaryColor; // Default for light theme

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => targetPage));
        },
      ),
    );
  }
}
