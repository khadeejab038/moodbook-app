import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/mood_entry.dart';
import '../Services/database_services.dart';

void showEditMoodPopup(BuildContext context, DocumentSnapshot moodEntryDoc) {
  // Retrieve the mood entry data and the ID from the DocumentSnapshot
  final moodEntry = moodEntryDoc.data() as Map<String, dynamic>;
  final String moodEntryId = moodEntryDoc.id; // Get the document ID

  DateTime selectedDateTime = (moodEntry['timestamp'] as Timestamp).toDate(); // Convert Firestore Timestamp to DateTime

  // Controller for the notes field
  final TextEditingController notesController = TextEditingController(
    text: moodEntry['notes'] ?? '', // Default to empty string if notes is null
  );

  print('Current notes before editing: ${moodEntry['notes']}'); // Debugging line

  String selectedMood = moodEntry['mood']; // Currently selected mood

  // Function to select date and time
  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.isAfter(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Future dates and times are not allowed."),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          selectedDateTime = combinedDateTime;
        }
      }
    }
  }

  // Show the popup
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Edit Mood Entry",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Timestamp (display only, not editable)
              Text(
                "Timestamp: ${selectedDateTime.toLocal()}".split('.')[0],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),

              // Mood (display only, not editable)
              Text("Mood: $selectedMood", style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),

              // Emotions (display only, not editable)
              Text(
                "Emotions: ${(moodEntry['emotions'] as List<dynamic>).join(', ')}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),

              // Reasons (display only, not editable)
              Text(
                "Reasons: ${(moodEntry['reasons'] as List<dynamic>).join(', ')}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),

              // Notes (editable)
              Text("Notes"),
              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Additional details...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), // Discard
                    child: Text("Discard"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Prepare updated data with only notes updated
                      final updatedMoodEntry = MoodEntry(
                        timestamp: selectedDateTime,
                        mood: selectedMood,
                        emotions: List<String>.from(moodEntry['emotions'] ?? []),
                        reasons: List<String>.from(moodEntry['reasons'] ?? []),
                        notes: notesController.text,
                      );

                      try {
                        // Print the mood entry ID for debugging
                        print("####################Mood Entry ID: $moodEntryId");

                        // Call the update method from your database service
                        await DatabaseServices.updateMoodEntry(moodEntryId, updatedMoodEntry);

                        // Close the popup
                        Navigator.of(context).pop();
                      } catch (e) {
                        // Handle any errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating entry: $e')),
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
