import 'package:flutter/material.dart';

Future<bool?> showAcceptTermsDialog(BuildContext context) async {
  bool isChecked = false;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevent closing without action
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Accept Terms & Conditions"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Before scanning, you must agree to the following terms:\n\n"
                    "I confirm that I am scanning a network that I own or have permission to scan.\n"
                    "I understand that unauthorised scanning is illegal and against policy.\n"
                    "I accept full responsibility for using Wi-Fi Guard ethically.",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text("I accept the terms and conditions."),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User declines
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isChecked
                    ? () {
                        Navigator.of(context).pop(true); // User accepts
                      }
                    : null, // Disable until checkbox is checked
                child: Text("Accept & Scan"),
              ),
            ],
          );
        },
      );
    },
  );
}
