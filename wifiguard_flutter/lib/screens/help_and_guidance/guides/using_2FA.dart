import 'package:flutter/material.dart';

class UsingTwoFactorAuthScreen extends StatelessWidget {
  const UsingTwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Using Two-Factor Authentication (2FA)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'How to Enable 2FA for Your Accounts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '1. Go to your account settings on the platform you want to secure.'),
            SizedBox(height: 8.0),
            Text(
                '2. Locate the "Security" or "Two-Factor Authentication" option.'),
            SizedBox(height: 8.0),
            Text(
                '3. Choose a preferred authentication method (e.g., SMS, authenticator app).'),
            SizedBox(height: 8.0),
            Text(
                '4. Follow the instructions to link your account to the 2FA method.'),
            SizedBox(height: 8.0),
            Text('5. Save your backup codes in a secure location.'),
            SizedBox(height: 16.0),
            Text(
              'Tips:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '- Use an authenticator app (like Google Authenticator or Authy) instead of SMS for better security.\n'
                '- Enable 2FA for all important accounts, including email and banking.\n'
                '- Regularly check your account’s security settings for new updates.'),
          ],
        ),
      ),
    );
  }
}
