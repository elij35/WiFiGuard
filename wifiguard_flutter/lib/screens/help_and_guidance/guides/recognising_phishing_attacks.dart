import 'package:flutter/material.dart';

class RecognisingPhishingAttacks extends StatelessWidget {
  const RecognisingPhishingAttacks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognising Phishing Attacks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'How to Recognise Phishing Attacks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '1. Be cautious of emails or messages requesting personal information.'),
            SizedBox(height: 8.0),
            Text(
                '2. Check the sender’s email address for misspellings or suspicious domains.'),
            SizedBox(height: 8.0),
            Text(
                '3. Hover over links before clicking to verify their destination.'),
            SizedBox(height: 8.0),
            Text('4. Be wary of urgent or threatening language in messages.'),
            SizedBox(height: 8.0),
            Text('5. Avoid downloading attachments from unknown sources.'),
            SizedBox(height: 16.0),
            Text(
              'Tips:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
                '- Always verify requests for sensitive information directly with the company.\n'
                '- Use email filtering tools to reduce spam and phishing attempts.\n'
                '- Enable two-factor authentication for added security.'),
          ],
        ),
      ),
    );
  }
}
