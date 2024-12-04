import 'package:flutter/material.dart';
import 'package:guard/screens/help_and_guidance/guidance/public_wifi_risks.dart';
import 'package:guard/widgets/tile_builder.dart';

class HelpAndInfoScreen extends StatelessWidget {
  const HelpAndInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Guidance'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildHelpTopicCard(
            context,
            title: 'Risks of Public Wi-Fi',
            description:
                'Learn about the dangers of using public Wi-Fi networks and how to protect yourself.',
            color: Colors.blue.shade100,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PublicWiFiRisks()),
              );
            },
          ),
        ],
      ),
    );
  }
}