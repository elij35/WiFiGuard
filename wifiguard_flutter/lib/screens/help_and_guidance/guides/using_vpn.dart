import 'package:flutter/material.dart';

class UsingVPNScreen extends StatelessWidget {
  const UsingVPNScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Using VPN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'How to Use a VPN:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. Choose a reliable VPN provider (e.g., NordVPN, ExpressVPN).',
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Download and install the VPN app on your devices.',
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Open the app, log in, and select a server location.',
            ),
            SizedBox(height: 8.0),
            Text(
              '4. Connect to the VPN server to secure your connection.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Benefits of Using a VPN:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Protects your data from hackers on public Wi-Fi.\n'
              '- Hides your IP address and location.\n'
              '- Access geo-restricted content securely.',
            ),
          ],
        ),
      ),
    );
  }
}
