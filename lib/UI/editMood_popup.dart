import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/mood_entry.dart';
import '../Services/database_services.dart';
import '../Widgets/date_time_picker.dart';

void showEditMoodPopup(BuildContext context, DocumentSnapshot moodEntryDoc) {
  // Retrieve the mood entry data and the ID from the DocumentSnapshot
  final moodEntry = moodEntryDoc.data() as Map<String, dynamic>;
  final String moodEntryId = moodEntryDoc.id; // Get the document ID

  DateTime selectedDateTime = (moodEntry['timestamp'] as Timestamp).toDate(); // Convert Firestore Timestamp to DateTime

  // Controllers for the fields
  final TextEditingController notesController = TextEditingController(
    text: moodEntry['notes'] ?? '', // Default to empty string if notes is null
  );

  final TextEditingController emotionsController = TextEditingController(
    text: (moodEntry['emotions'] as List<dynamic>).join(', '), // Joining emotions list
  );

  final TextEditingController reasonsController = TextEditingController(
    text: (moodEntry['reasons'] as List<dynamic>).join(', '), // Joining reasons list
  );

  String selectedMood = moodEntry['mood']; // Currently selected mood


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

              // Editable Timestamp
              Text("Timestamp"),
              Row(
                children: [
                  Text(
                    "${selectedDateTime.toLocal()}".split('.')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await selectDateAndTime(context, selectedDateTime, (newDateTime) {
                        selectedDateTime = newDateTime;  // Update selectedDateTime after picking
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Editable Mood
              Text("Mood"),
              DropdownButton<String>(
                value: selectedMood,
                onChanged: (String? newMood) {
                  if (newMood != null) {
                    selectedMood = newMood;
                  }
                },
                items: ['Terrible', 'Bad', 'Neutral', 'Good', 'Excellent'].map((String mood) {
                  return DropdownMenuItem<String>(
                    value: mood,
                    child: Text(mood),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),

              // Editable Emotions
              Text("Emotions (comma separated)"),
              TextFormField(
                controller: emotionsController,
                decoration: InputDecoration(
                  hintText: "Enter emotions...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Editable Reasons
              Text("Reasons (comma separated)"),
              TextFormField(
                controller: reasonsController,
                decoration: InputDecoration(
                  hintText: "Enter reasons...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Editable Notes
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
                      // Prepare updated data
                      final updatedMoodEntry = MoodEntry(
                        timestamp: selectedDateTime,
                        mood: selectedMood,
                        emotions: emotionsController.text.split(',').map((e) => e.trim()).toList(),
                        reasons: reasonsController.text.split(',').map((e) => e.trim()).toList(),
                        notes: notesController.text,
                      );

                      try {
                        // Call the update method from the database service
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
