import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Function to request location and notification permissions
Future<void> requestPermissions(BuildContext context) async {
  // Check and request location permission
  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied) {
    final status = await Permission.location.request();
    if (status.isDenied) {
      // Show explanation dialog if permission is denied
      showPermissionDialog(
        context,
        "Location permission is required for scanning networks.",
        Permission.location,
      );
    } else if (status.isPermanentlyDenied) {
      // Show settings dialog if permission is permanently denied
      showSettingsDialog(
        context,
        "Location permission is permanently denied. Please enable it in settings.",
      );
    }
  }

  // Check and request notification permission
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied) {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Show explanation dialog if permission is denied
      showPermissionDialog(
        context,
        "Notification permission is required to receive alerts.",
        Permission.notification,
      );
    } else if (status.isPermanentlyDenied) {
      // Show settings dialog if permission is permanently denied
      showSettingsDialog(
        context,
        "Notification permission is permanently denied. Please enable it in settings.",
      );
    }
  }
}

// Displays a dialog asking the user to grant the requested permission
void showPermissionDialog(
    BuildContext context, String message, Permission permission) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          // Retry button to request permission again
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              final status =
                  await permission.request(); // Re-request permission
              if (status.isDenied) {
                // If still denied, prompt user to enable it manually
                showSettingsDialog(
                  context,
                  "You need to enable this permission in the app settings.",
                );
              }
            },
            child: const Text("Retry"),
          ),
          // Cancel button to close the dialog
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

// Displays a dialog instructing the user to enable permissions in settings
void showSettingsDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Permission Required"),
        content: Text(message),
        actions: [
          // Opens the app settings where users can manually enable permissions
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await openAppSettings(); // Open app settings
            },
            child: const Text("Open Settings"),
          ),
          // Cancel button to dismiss the dialog
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
