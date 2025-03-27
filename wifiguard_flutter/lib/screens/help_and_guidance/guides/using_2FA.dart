import 'package:WiFiGuard/widgets/help_and_guidance_builder.dart';
import 'package:flutter/material.dart';

class UsingTwoFactorAuthScreen extends StatelessWidget {
  const UsingTwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Using Two-Factor Authentication (2FA)'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle(
                'How to Enable 2FA for Your Accounts:'),
            TileBuilder.buildStepTile(
                '1. Go to your account settings on the platform you want to secure.'),
            TileBuilder.buildStepTile(
                '2. Locate the "Security" or "Two-Factor Authentication" option.'),
            TileBuilder.buildStepTile(
                '3. Choose a preferred authentication method (e.g., SMS, authenticator app).'),
            TileBuilder.buildStepTile(
                '4. Follow the instructions to link your account to the 2FA method.'),
            TileBuilder.buildStepTile(
                '5. Save your backup codes in a secure location.'),
          ],
        ),
      ),
    );
  }
}
