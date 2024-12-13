import 'package:flutter/material.dart';

//Dashboard layout
Widget buildDashboardButton(BuildContext context,
    {required String label,
    required IconData icon,
    required VoidCallback onTap}) {
  return Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    ),
  );
}

// Settings layout
Widget buildSettingTile(
  BuildContext context, {
  required String title,
  required String subtitle,
  required bool switchValue,
  required ValueChanged<bool> onSwitchChanged,
  required Color activeColor,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: activeColor,
      ),
    ),
  );
}

//Network info row layout
class NetworkInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const NetworkInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// Connected devices screen for the top header tile displaying Wi-Fi name and device count
Widget buildHeaderTile({
  required BuildContext context,
  required String wifiName,
  required int deviceCount,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: const Color(0xff00177c),
    child: ListTile(
      leading: const Icon(Icons.wifi, color: Colors.white),
      title: Text(
        'SSID: $wifiName',
        style: const TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      subtitle: Text(
        '$deviceCount connected devices',
        style: const TextStyle(color: Color(0xff00f16b)),
      ),
    ),
  );
}

// Connected devices displaying the connected device's information
Widget buildDeviceTile({
  required BuildContext context,
  required String deviceIp,
  required VoidCallback onMoreInfo,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    elevation: 4.0,
    child: ListTile(
      leading: const Icon(Icons.device_hub, color: Colors.teal),
      title: Text(
        'Device IP: $deviceIp',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: ElevatedButton(
        onPressed: onMoreInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        child: const Text('More Info'),
      ),
    ),
  );
}

// Help and info layout
Widget buildHelpTopicCard(
  BuildContext context, {
  required String title,
  required String description,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}