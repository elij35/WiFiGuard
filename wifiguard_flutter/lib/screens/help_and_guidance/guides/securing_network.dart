import 'package:WiFiGuard/widgets/help_and_guidance/help_and_guidance_guides_builder.dart';
import 'package:flutter/material.dart';

class SecuringNetworkScreen extends StatelessWidget {
  const SecuringNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Securing Your Network'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle(
                'Best Practices for Securing Your Network:'),
            TileBuilder.buildStepTile(
                '1. Use a strong, unique Wi-Fi password and avoid sharing it widely.'),
            TileBuilder.buildStepTile(
                '2. Enable WPA3 or WPA2 encryption in your router settings.'),
            TileBuilder.buildStepTile(
                '3. Regularly update your router\'s firmware to patch security vulnerabilities.'),
            TileBuilder.buildStepTile(
                '4. Turn off remote access to your router unless absolutely necessary.'),
            TileBuilder.buildStepTile(
                '5. Disable WPS (Wi-Fi Protected Setup) as it can be a security risk.'),
            TileBuilder.buildStepTile(
                '6. Regularly check for unfamiliar devices on your network using this app.'),
          ],
        ),
      ),
    );
  }
}
