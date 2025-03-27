import 'package:WiFiGuard/widgets/help_and_guidance/help_and_guidance_guides_builder.dart';
import 'package:flutter/material.dart';

class UsingVPNScreen extends StatelessWidget {
  const UsingVPNScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Using VPN'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle('How to Use a VPN:'),
            TileBuilder.buildStepTile(
                '1. Choose a reliable VPN provider (e.g., NordVPN, ExpressVPN).'),
            TileBuilder.buildStepTile(
                '2. Download and install the VPN app on your devices.'),
            TileBuilder.buildStepTile(
                '3. Open the app, log in, and select a server location.'),
            TileBuilder.buildStepTile(
                '4. Connect to the VPN server to secure your connection.'),
            TileBuilder.buildSectionTitle('Benefits of Using a VPN:'),
            TileBuilder.buildStepTile(
                '- Protects your data from hackers on public Wi-Fi.'),
            TileBuilder.buildStepTile('- Hides your IP address and location.'),
            TileBuilder.buildStepTile(
                '- Access geo-restricted content securely.'),
          ],
        ),
      ),
    );
  }
}
