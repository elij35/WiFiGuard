import 'package:WiFiGuard/widgets/help_and_guidance_builder.dart';
import 'package:flutter/material.dart';

class RecognisingPhishingAttacks extends StatelessWidget {
  const RecognisingPhishingAttacks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TileBuilder.buildAppBar('Recognising Phishing Attacks'),
      body: TileBuilder.buildBody(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TileBuilder.buildSectionTitle('How to Recognise Phishing Attacks:'),
            TileBuilder.buildStepTile(
                '1. Be cautious of emails or messages requesting personal information.'),
            TileBuilder.buildStepTile(
                '2. Check the sender’s email address for misspellings or suspicious domains.'),
            TileBuilder.buildStepTile(
                '3. Hover over links before clicking to verify their destination.'),
            TileBuilder.buildStepTile(
                '4. Be wary of urgent or threatening language in messages.'),
            TileBuilder.buildStepTile(
                '5. Avoid downloading attachments from unknown sources.'),
          ],
        ),
      ),
    );
  }
}
