import 'package:flutter/material.dart';

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
          _buildTiles(
            title: 'Nmap Scan',
            color: Colors.blue,
            icon: Icons.network_check,
            onTap: () {},
          ),

          //Shodan Scan
          _buildTiles(
            title: 'Shodan Scan',
            color: Colors.green,
            icon: Icons.security,
            onTap: () {},
          ),

          //IP checker
          _buildTiles(
            title: 'IP Checker',
            color: Colors.orange,
            icon: Icons.public,
            onTap: () {},
          ),

          //Wi-Fi Scanner
          _buildTiles(
            title: 'Wi-Fi Scanner',
            color: Colors.purple,
            icon: Icons.wifi,
            onTap: () {},
          ),

          //Risk Assessment
          _buildTiles(
            title: 'Risk Assessment',
            color: Colors.red,
            icon: Icons.warning,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTiles({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}