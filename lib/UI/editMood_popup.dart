import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/mood_entry.dart';
import '../Services/database_services.dart';
import '../Utils/emoji_data.dart';
import '../Widgets/date_time_picker.dart'; // Import emoji data

class EditMoodPopup extends StatefulWidget {
  final DocumentSnapshot moodEntryDoc;

  EditMoodPopup({required this.moodEntryDoc});

  @override
  _EditMoodPopupState createState() => _EditMoodPopupState();
}

class _EditMoodPopupState extends State<EditMoodPopup> {
  late DateTime selectedDateTime;
  late String selectedMood;
  late int selectedEmojiIndex;
  late TextEditingController notesController;
  late TextEditingController emotionsController;
  late TextEditingController reasonsController;

  @override
  void initState() {
    super.initState();
    final moodEntry = widget.moodEntryDoc.data() as Map<String, dynamic>;

    // Initialize the values
    selectedDateTime = (moodEntry['timestamp'] as Timestamp).toDate();
    selectedMood = moodEntry['mood'];
    selectedEmojiIndex = getMoodIndex(selectedMood);

    notesController = TextEditingController(text: moodEntry['notes'] ?? '');
    emotionsController = TextEditingController(
        text: (moodEntry['emotions'] as List<dynamic>).join(', '));
    reasonsController = TextEditingController(
        text: (moodEntry['reasons'] as List<dynamic>).join(', '));
  }

  @override
  Widget build(BuildContext context) {
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
                    await selectDateAndTime(context, selectedDateTime,
                            (newDateTime) {
                          setState(() {
                            selectedDateTime = newDateTime;
                          });
                        });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),

            // Editable Mood (Replaced Dropdown with Emoji Picker)
            Text("Mood"),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moods.length, // Using the 'moods' list from emoji_data.dart
                itemBuilder: (context, index) {
                  final isSelected = selectedEmojiIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = moods[index].title; // Update selected mood title
                        selectedEmojiIndex = index; // Update the selected emoji index
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: isSelected ? 80 : 60,
                      height: isSelected ? 80 : 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ]
                            : [],
                      ),
                      child: Image.asset(
                        moods[index].imagePath, // Displaying the image based on selected mood
                        width: isSelected ? 40 : 30, // Adjust image size based on selection
                        height: isSelected ? 40 : 30,
                      ),
                    ),
                  );
                },
              ),
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
                      emotions: emotionsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                      reasons: reasonsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                      notes: notesController.text,
                    );

                    try {
                      // Call the update method from the database service
                      await DatabaseServices.updateMoodEntry(
                          widget.moodEntryDoc.id, updatedMoodEntry);

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
  }
}

// Helper function to get the mood index based on the current mood string
int getMoodIndex(String mood) {
  switch (mood) {
    case 'Terrible':
      return 0;
    case 'Bad':
      return 1;
    case 'Neutral':
      return 2;
    case 'Good':
      return 3;
    case 'Excellent':
      return 4;
    default:
      return 2; // Default to Neutral if no match
  }
}
