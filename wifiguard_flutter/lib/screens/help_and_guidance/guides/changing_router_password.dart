import 'package:flutter/material.dart';

class ChangingRouterPasswordScreen extends StatelessWidget {
  const ChangingRouterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changing Router Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Steps to Change Your Router Password:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '1. Open your web browser and enter your router\'s IP address (e.g., 192.168.1.1).',
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Log in with your admin credentials. If you don\'t know them, check the router\'s manual or sticker on the device.',
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Navigate to the "Wireless" or "Security" settings.',
            ),
            SizedBox(height: 8.0),
            Text(
              '4. Locate the password field (often labeled as "WPA Key" or "Password").',
            ),
            SizedBox(height: 8.0),
            Text(
              '5. Enter a new, strong password. Use a mix of letters, numbers, and symbols.',
            ),
            SizedBox(height: 8.0),
            Text(
              '6. Save the changes and restart your router if necessary.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Tips:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Avoid using easily guessed passwords like "password123".\n'
              '- Update your password regularly to enhance security.\n'
              '- Use a password manager to keep track of your passwords securely.',
            ),
          ],
        ),
      ),
    );
  }
}
