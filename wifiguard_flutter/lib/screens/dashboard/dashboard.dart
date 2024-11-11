import 'package:flutter/material.dart';
import 'package:guard/screens/help_and_guidance/help_and_guidance.dart';
import 'package:guard/screens/nmap/nmap_screen.dart';
import 'package:guard/screens/network_exposure_check/network_exposure_check_screen.dart';
import 'package:guard/widgets/tile_builder.dart';

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

          //Help and Guidance
          buildTiles(
            title: 'Help and Guidance',
            color: Colors.purple,
            icon: Icons.help,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpAndGuidance()),
              );
            },
          ),
        ],
      ),
    );
  }
}