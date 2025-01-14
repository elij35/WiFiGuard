import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {
  // Location permission handling
  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied) {
    final status = await Permission.location.request();
    if (status.isDenied) {
      // Prompts the user with an explanation
      showPermissionDialog(
        context,
        "Location permission is required for scanning networks.",
        Permission.location,
      );
    } else if (status.isPermanentlyDenied) {
      // Redirect to app settings
      showSettingsDialog(
        context,
        "Location permission is permanently denied. Please enable it in settings.",
      );
    }
  }

  // Notification permission handling
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied) {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Prompt the user with an explanation
      showPermissionDialog(
        context,
        "Notification permission is required to receive alerts.",
        Permission.notification,
      );
    } else if (status.isPermanentlyDenied) {
      // Redirect to app settings
      showSettingsDialog(
        context,
        "Notification permission is permanently denied. Please enable it in settings.",
      );
    }
  }
}

void showPermissionDialog(
    BuildContext context, String message, Permission permission) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              final status =
                  await permission.request(); // Re-request permission
              if (status.isDenied) {
                // Permission is still denied
                showSettingsDialog(
                  context,
                  "You need to enable this permission in the app settings.",
                );
              }
            },
            child: const Text("Retry"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

void showSettingsDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await openAppSettings(); // Open app settings
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}
