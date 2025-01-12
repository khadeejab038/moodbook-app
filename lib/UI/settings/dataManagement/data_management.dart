import 'package:flutter/material.dart';

import '../../../Services/database_services_mood_entries.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data export started!'), backgroundColor: Color(0xFF8B4CFC),),

              );
              Navigator.of(context).pop();
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  // Static method to clear mood logs
  static void clearMoodLogs(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Mood Logs'),
        content: Text('Are you sure you want to clear all mood logs? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel button
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Call the method to delete all mood entries for the user
              try {
                await DatabaseServices.clearAllMoodEntries();
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mood logs cleared!')),);
                Navigator.of(context).pop(); // Close the dialog
              } catch (e) {
                // Handle any errors that occur while deleting mood logs
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to clear mood logs: $e')),);
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

}
