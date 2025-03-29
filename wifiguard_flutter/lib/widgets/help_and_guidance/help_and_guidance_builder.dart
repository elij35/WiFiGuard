import 'package:flutter/material.dart';

class HelpTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget targetPage;

  const HelpTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => targetPage));
        },
      ),
    );
  }
}
