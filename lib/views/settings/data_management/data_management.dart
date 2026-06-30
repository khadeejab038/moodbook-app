import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/database/mood_entry_database.dart';
import '../../../controllers/mood_entry_controller.dart';
import '../../../models/mood_entry.dart';
import '../../widgets/snack_bar_helper.dart';
import '../../../../utils/error_parser.dart';

class DataManagement {
  // Convert mood entries to standard CSV format
  static String _convertEntriesToCsv(List<MoodEntry> entries) {
    List<String> rows = [
      'Date,Time,Mood,Emotions,Reasons,Notes'
    ];
    for (var entry in entries) {
      final date = DateFormat('yyyy-MM-dd').format(entry.getTimestamp);
      final time = DateFormat('HH:mm').format(entry.getTimestamp);
      final mood = entry.getMood;
      
      // Escape fields by placing in double quotes and escaping inner quotes
      final emotions = '"${entry.getEmotions.join(', ').replaceAll('"', '""')}"';
      final reasons = '"${entry.getReasons.join(', ').replaceAll('"', '""')}"';
      final notes = '"${(entry.getNotes ?? '').replaceAll('\n', ' ').replaceAll('"', '""')}"';
      
      rows.add('$date,$time,$mood,$emotions,$reasons,$notes');
    }
    return rows.join('\n');
  }

  // Static method to handle data export functionality
  static void exportData(BuildContext pageContext) {
    // Show confirmation dialog
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Are you sure you want to export all your mood logs in a CSV file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close confirmation dialog

              // Show loading spinner dialog using mounted parent pageContext
              showDialog(
                context: pageContext,
                barrierDismissible: false,
                builder: (spinnerContext) => const Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(child: CircularProgressIndicator()),
                ),
              );

              try {
                // Fetch all mood entries
                final List<MoodEntry> entries = await MoodEntryDatabase.fetchMoodEntries();

                if (!pageContext.mounted) return;

                if (entries.isEmpty) {
                  Navigator.of(pageContext).pop(); // Close spinner dialog
                  showSnackBar(pageContext, 'No mood logs available to export.');
                  return;
                }

                // Serialize to CSV
                final csvData = _convertEntriesToCsv(entries);

                // Get local directory for saving
                final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/moodbook_mood_logs.csv');

                // Write CSV file
                await file.writeAsString(csvData);

                if (pageContext.mounted) {
                  Navigator.of(pageContext).pop(); // Close spinner dialog
                  showSnackBar(pageContext, 'Data successfully exported to: ${file.path}');
                }
              } catch (e) {
                if (pageContext.mounted) {
                  Navigator.of(pageContext).pop(); // Close spinner dialog
                  showSnackBar(pageContext, ErrorParser.getFriendlyMessage(e));
                }
              }
            },
            child: const Text('Export'),
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

                if (pageContext.mounted) {
                  // Clear memory cache in MoodEntryController using pageContext
                  final moodProvider = Provider.of<MoodEntryController>(pageContext, listen: false);
                  moodProvider.clear();
                  moodProvider.clearRecentlyUsed();

                  Navigator.of(pageContext).pop(); // Close the spinner dialog
                  showSnackBar(pageContext, 'Mood logs cleared successfully!');
                }
              } catch (e) {
                if (pageContext.mounted) {
                  Navigator.of(pageContext).pop(); // Close the spinner dialog
                  showSnackBar(pageContext, ErrorParser.getFriendlyMessage(e));
                }
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

}
