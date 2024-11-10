import 'package:flutter/material.dart';

//Import helpers
import '../../widgets/tile_builder.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi Guard Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[

          //NMAP Scan
          buildTiles(
            title: 'Nmap Scan',
            color: Colors.blue,
            icon: Icons.network_check,
            onTap: () {},
          ),

          //Shodan Scan
          buildTiles(
            title: 'Shodan Scan',
            color: Colors.green,
            icon: Icons.security,
            onTap: () {},
          ),

          //IP checker
          buildTiles(
            title: 'IP Checker',
            color: Colors.orange,
            icon: Icons.public,
            onTap: () {},
          ),

          //Wi-Fi Scanner
          buildTiles(
            title: 'Wi-Fi Scanner',
            color: Colors.purple,
            icon: Icons.wifi,
            onTap: () {},
          ),

          //Risk Assessment
          buildTiles(
            title: 'Risk Assessment',
            color: Colors.red,
            icon: Icons.warning,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}