import 'package:WiFiGuard/widgets/help_and_guidance_builder.dart';
import 'package:flutter/material.dart';

class UpdatingFirmwareScreen extends StatelessWidget {
  const UpdatingFirmwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Updating Firmware'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle(
                'Steps to Update Your Router’s Firmware:'),
            TileBuilder.buildStepTile(
                '1. Identify your router model and visit the manufacturer’s website.'),
            TileBuilder.buildStepTile(
                '2. Look for the latest firmware update for your router model.'),
            TileBuilder.buildStepTile(
                '3. Download the firmware file and follow the instructions provided.'),
            TileBuilder.buildStepTile(
                '4. Access your router’s settings via its IP address.'),
            TileBuilder.buildStepTile(
                '5. Locate the "Firmware Update" or "Software Update" section.'),
            TileBuilder.buildStepTile(
                '6. Upload the downloaded firmware file and install it.'),
            TileBuilder.buildTipsSection(
              '- Always back up your router settings before updating firmware.\n'
              '- Never turn off your router during an update to prevent corruption.\n'
              '- Set up automatic updates if your router supports it.',
            ),
          ],
        ),
      ),
    );
  }
}
