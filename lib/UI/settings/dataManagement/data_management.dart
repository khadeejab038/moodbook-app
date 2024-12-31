import 'package:flutter/material.dart';

class DataManagement {
  // Static method to handle data export functionality
  static void exportData(BuildContext context) {
    // Implement data export functionality
    // Example: Show a dialog to confirm export
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Data'),
        content: Text('Are you sure you want to export your data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle export logic here
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data export started!')),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  // Static method to clear mood logs
  static void clearMoodLogs(BuildContext context) {
    // Implement clearing mood logs
    // Example: Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Mood Logs'),
        content: Text('Are you sure you want to clear all mood logs? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle clear mood logs logic here
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mood logs cleared!')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
