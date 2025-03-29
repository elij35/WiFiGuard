import 'package:WiFiGuard/screens/help_and_guidance/guides/changing_router_password.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/recognising_phishing_attacks.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/securing_network.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/updating_firmware.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/using_2fa.dart';
import 'package:WiFiGuard/screens/help_and_guidance/guides/using_vpn.dart';
import 'package:WiFiGuard/screens/help_and_guidance/help_and_guidance_ai.dart';
import 'package:WiFiGuard/widgets/help_and_guidance/help_and_guidance_builder.dart';
import 'package:flutter/material.dart';

class HelpAndGuidanceScreen extends StatelessWidget {
  const HelpAndGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help and Guidance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  HelpTileWidget(
                    icon: Icons.router,
                    title: 'Changing Router Password',
                    description:
                        'Learn how to update your router\'s password securely.',
                    targetPage: const ChangingRouterPasswordScreen(),
                  ),
                  HelpTileWidget(
                    icon: Icons.security,
                    title: 'Securing Your Network',
                    description:
                        'Best practices for ensuring a secure network.',
                    targetPage: const SecuringNetworkScreen(),
                  ),
                  HelpTileWidget(
                    icon: Icons.vpn_lock,
                    title: 'Using VPN',
                    description:
                        'How to use a VPN to secure your internet activity.',
                    targetPage: const UsingVPNScreen(),
                  ),
                  HelpTileWidget(
                    icon: Icons.phonelink_lock,
                    title: 'Recognising Phishing Attacks',
                    description: 'How to identify and avoid phishing scams.',
                    targetPage: const RecognisingPhishingAttacks(),
                  ),
                  HelpTileWidget(
                    icon: Icons.system_update,
                    title: 'Updating Firmware',
                    description:
                        'Steps to keep your router firmware up to date.',
                    targetPage: const UpdatingFirmwareScreen(),
                  ),
                  HelpTileWidget(
                    icon: Icons.verified_user,
                    title: 'Using Two-Factor Authentication',
                    description:
                        'How to set up and use 2FA for extra security.',
                    targetPage: const UsingTwoFactorAuthScreen(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpAndGuidanceAIScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Need Help? Click here to ask AI"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
