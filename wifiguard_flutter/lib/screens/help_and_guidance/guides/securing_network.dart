import 'package:flutter/material.dart';

class SecuringNetworkScreen extends StatelessWidget {
  const SecuringNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Securing Your Network'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Best Practices for Securing Your Network:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. Use a strong, unique Wi-Fi password and avoid sharing it widely.',
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Enable WPA3 or WPA2 encryption in your router settings.',
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Regularly update your router\'s firmware to patch security vulnerabilities.',
            ),
            SizedBox(height: 8.0),
            Text(
              '4. Turn off remote access to your router unless absolutely necessary.',
            ),
            SizedBox(height: 8.0),
            Text(
              '5. Disable WPS (Wi-Fi Protected Setup) as it can be a security risk.',
            ),
            SizedBox(height: 8.0),
            Text(
              '6. Regularly check for unfamiliar devices on your network using this app.',
            ),
          ],
        ),
      ),
    );
  }
}
