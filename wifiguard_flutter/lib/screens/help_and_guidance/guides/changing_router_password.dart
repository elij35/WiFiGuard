import 'package:WiFiGuard/widgets/help_and_guidance_builder.dart';
import 'package:flutter/material.dart';

class ChangingRouterPasswordScreen extends StatelessWidget {
  const ChangingRouterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Changing Router Password'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle(
                'Steps to Change Your Router Password:'),
            TileBuilder.buildStepTile(
                '1. Open your web browser and enter your router\'s IP address (e.g., 192.168.1.1).'),
            TileBuilder.buildStepTile(
                '2. Log in with your admin credentials. If you don\'t know them, check the router\'s manual or sticker on the device.'),
            TileBuilder.buildStepTile(
                '3. Navigate to the "Wireless" or "Security" settings.'),
            TileBuilder.buildStepTile(
                '4. Locate the password field (often labeled as "WPA Key" or "Password").'),
            TileBuilder.buildStepTile(
                '5. Enter a new, strong password. Use a mix of letters, numbers, and symbols.'),
            TileBuilder.buildStepTile(
                '6. Save the changes and restart your router if necessary.'),
          ],
        ),
      ),
    );
  }
}
