import 'package:flutter/material.dart';

class About {
  // Static method to show the custom About dialog
  static void showCustomAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About MoodBook'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Version: 1.0.0'),
              Text('© 2024 MoodBook Inc. All rights reserved.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
