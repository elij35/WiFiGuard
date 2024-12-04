import 'package:flutter/material.dart';
import 'package:guard/widgets/tile_builder.dart';

class NetworkInfoScreen extends StatelessWidget {
  const NetworkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NetworkInfoRow(label: 'SSID', value: 'Android Wifi'),
            //WiFi broadcast name
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Signal', value: 'Signal Strength'),
            // Signal strength
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'IP Address', value: '192.168.0.12'),
            //IP Address
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'MAC Address', value: 'A2:1E:EE:A3:FF:C1'),
            //MAC Address
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Frequency', value: '5 GHz'),
            // Frequency
            const Divider(color: Colors.grey),
            NetworkInfoRow(label: 'Security Protocol', value: 'WPA2-Personal'),
            // Security Protocol
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}