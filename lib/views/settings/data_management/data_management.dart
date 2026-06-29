import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/database/mood_entry_database.dart';
import '../../../controllers/mood_entry_controller.dart';
import '../../widgets/snack_bar_helper.dart';

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
              showSnackBar(context, 'Data export started!');
              Navigator.of(context).pop();
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  // Static method to clear mood logs
  static void clearMoodLogs(BuildContext pageContext) {
    // Show confirmation dialog
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Mood Logs'),
        content: const Text('Are you sure you want to clear all mood logs? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), // Cancel button
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close confirmation dialog

              // Show loading spinner dialog using the parent (mounted) pageContext
              showDialog(
                context: pageContext,
                barrierDismissible: false,
                builder: (spinnerContext) => const Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(child: CircularProgressIndicator()),
                ),
              );

              // Call the method to delete all mood entries for the user
              try {
                await MoodEntryDatabase.clearAllMoodEntries();

                // Clear memory cache in MoodEntryController using pageContext
                final moodProvider = Provider.of<MoodEntryController>(pageContext, listen: false);
                moodProvider.clear();
                moodProvider.clearRecentlyUsed();

                Navigator.of(pageContext).pop(); // Close the spinner dialog
                showSnackBar(pageContext, 'Mood logs cleared successfully!');
              } catch (e) {
                Navigator.of(pageContext).pop(); // Close the spinner dialog
                showSnackBar(pageContext, 'Failed to clear mood logs: $e');
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

}
