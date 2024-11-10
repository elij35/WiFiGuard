import 'package:flutter/material.dart';

class PublicWiFiRisks extends StatelessWidget {
  const PublicWiFiRisks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Risks of Public Wi-Fi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Data Interception',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Public Wi-Fi networks often lack strong encryption, allowing attackers to intercept data being transmitted.',
            ),
            SizedBox(height: 20),
            Text(
              'Man-in-the-Middle (MITM) Attacks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Attackers can insert themselves between your device and the Wi-Fi access point, intercepting communication.',
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}
