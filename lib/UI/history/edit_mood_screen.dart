import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/mood_entry.dart';
import '../../Services/database_services_mood_entries.dart';
import '../../Utils/emoji_data.dart';
import '../../Utils/reasons_data.dart';
import '../../Widgets/date_time_picker.dart'; // Import emoji data

class EditMoodScreen extends StatefulWidget {
  final DocumentSnapshot moodEntryDoc;

  EditMoodScreen({required this.moodEntryDoc});

  @override
  _EditMoodScreenState createState() => _EditMoodScreenState();
}

class _EditMoodScreenState extends State<EditMoodScreen> {
  late DateTime selectedDateTime;
  late String selectedMood;
  late int selectedEmojiIndex;
  late TextEditingController notesController;
  late List<String> selectedEmotions;
  late TextEditingController reasonsController;

  @override
  void initState() {
    super.initState();
    final moodEntry = widget.moodEntryDoc.data() as Map<String, dynamic>;

    // Initialize values
    selectedDateTime = (moodEntry['timestamp'] as Timestamp).toDate();
    selectedMood = moodEntry['mood'];
    selectedEmojiIndex = getMoodIndex(selectedMood);

    notesController = TextEditingController(text: moodEntry['notes'] ?? '');
    selectedEmotions = List<String>.from(moodEntry['emotions'] ?? []);
    reasonsController = TextEditingController(
        text: (moodEntry['reasons'] as List<dynamic>).join(', '));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Mood Entry", style: TextStyle(fontFamily: 'Pangram')),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC3FFD4), // First color #C3FFD4
              Color(0xFFCFCCFB), // Second color #CFCCFB
              Color(0xFFEFF9F2), // Third color #EFF9F2
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editable Timestamp
                Text("Timestamp", style: TextStyle(fontFamily: 'Pangram')),
                Row(
                  children: [
                    Text(
                      "${selectedDateTime.toLocal()}".split('.')[0],
                      style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        await selectDateAndTime(
                            context,
                            selectedDateTime,
                                (newDateTime) {
                              setState(() {
                                selectedDateTime = newDateTime;
                              });
                            }
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Editable Mood (Replaced Dropdown with Emoji Picker)
                Text("Mood", style: TextStyle(fontFamily: 'Pangram')),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moods.length, // Using the 'allEmotions' list from emoji_data.dart
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
                Text("Emotions", style: TextStyle(fontFamily: 'Pangram')),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: allEmotions.map((emotion) {
                    final isSelected = selectedEmotions.contains(emotion.title);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            // Remove the emotion and fix commas
                            selectedEmotions.remove(emotion.title);
                          } else {
                            // Add the emotion and fix commas
                            selectedEmotions.add(emotion.title);
                          }
                        });
                      },
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              emotion.imagePath,
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 8),
                            Text(emotion.title),
                          ],
                        ),
                        backgroundColor: isSelected
                            ? Colors.purpleAccent[700] // Darker background when selected
                            : Colors.grey[200], // Lighter background when not selected
                        deleteIcon: isSelected ? Icon(Icons.close) : null,
                        onDeleted: isSelected
                            ? () {
                          setState(() {
                            selectedEmotions.remove(emotion.title);
                          });
                        }
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),

                // Editable Reasons
                Text("Reasons", style: TextStyle(fontFamily: 'Pangram')),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: allReasons.map((reason) {
                    final isSelected = reasonsController.text.contains(reason);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            // Remove the reason and fix commas
                            reasonsController.text = reasonsController.text
                                .replaceAll(RegExp(',?\\b$reason\\b,?'), '')
                                .trim(); // Remove leading/trailing spaces and commas
                          } else {
                            // Add the reason and fix commas
                            reasonsController.text += (reasonsController.text.isEmpty
                                ? ''
                                : ', ') + reason;
                          }
                        });
                      },
                      child: Chip(
                        label: Text(reason),
                        backgroundColor: isSelected
                            ? Colors.purpleAccent[700] // Darker background when selected
                            : Colors.grey[200], // Lighter background when not selected
                        deleteIcon: isSelected ? Icon(Icons.close) : null,
                        onDeleted: isSelected
                            ? () {
                          setState(() {
                            reasonsController.text = reasonsController.text
                                .replaceAll(RegExp(',?\\b$reason\\b,?'), '')
                                .trim();
                          });
                        }
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),

                // Editable Notes
                Text("Notes", style: TextStyle(fontFamily: 'Pangram')),
                TextFormField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Additional details...",
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontFamily: 'Pangram'),
                ),
                SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(), // Discard
                      child: Text("Discard", style: TextStyle(fontFamily: 'Pangram')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedEmotions.isEmpty || reasonsController.text.isEmpty) {
                          // If no emotions or reasons selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select at least one emotion and one reason')),
                          );
                        } else {
                          // Prepare updated data
                          final updatedMoodEntry = MoodEntry(
                            timestamp: selectedDateTime,
                            mood: selectedMood,
                            emotions: selectedEmotions,
                            reasons: reasonsController.text.split(',').map((e) => e.trim()).toList(),
                            notes: notesController.text,
                          );

                          try {
                            // Call the update method from the database service
                            DatabaseServices.updateMoodEntry(
                                widget.moodEntryDoc.id, updatedMoodEntry);

                            // Close the screen
                            Navigator.of(context).pop();
                          } catch (e) {
                            // Handle any errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating entry: $e')),
                            );
                          }
                        }
                      },
                      child: Text("Save", style: TextStyle(fontFamily: 'Pangram')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
