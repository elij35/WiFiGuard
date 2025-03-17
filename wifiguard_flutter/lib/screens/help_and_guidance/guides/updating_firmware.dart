import 'package:flutter/material.dart';

class UpdatingFirmwareScreen extends StatelessWidget {
  const UpdatingFirmwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updating Firmware'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Steps to Update Your Router’s Firmware:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '1. Identify your router model and visit the manufacturer’s website.'),
            SizedBox(height: 8.0),
            Text(
                '2. Look for the latest firmware update for your router model.'),
            SizedBox(height: 8.0),
            Text(
                '3. Download the firmware file and follow the instructions provided.'),
            SizedBox(height: 8.0),
            Text('4. Access your router’s settings via its IP address.'),
            SizedBox(height: 8.0),
            Text(
                '5. Locate the "Firmware Update" or "Software Update" section.'),
            SizedBox(height: 8.0),
            Text('6. Upload the downloaded firmware file and install it.'),
            SizedBox(height: 16.0),
            Text(
              'Tips:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '- Always back up your router settings before updating firmware.\n'
                '- Never turn off your router during an update to prevent corruption.\n'
                '- Set up automatic updates if your router supports it.'),
          ],
        ),
      ),
    );
  }
}
