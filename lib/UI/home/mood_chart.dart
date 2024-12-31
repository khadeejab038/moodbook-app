import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../Models/emoji_item.dart';
import '../../Utils/emoji_data.dart';

class MoodChart extends StatelessWidget {
  String _getMoodEmoji(String mood) {
    final moodItem = moods.firstWhere(
          (emoji) => emoji.title == mood,
      orElse: () => EmojiItem(
        imagePath: 'lib/assets/neutral-face.png',
        title: 'Neutral',
      ), // Default emoji
    );
    return moodItem.imagePath;
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Terrible':
        return Colors.red.withOpacity(0.8);
      case 'Bad':
        return Colors.orange.withOpacity(0.8);
      case 'Neutral':
        return Colors.yellow.withOpacity(0.8);
      case 'Good':
        return Colors.lightBlue.withOpacity(0.8);
      case 'Excellent':
        return Colors.green.withOpacity(0.8);
      default:
        return Colors.grey.withOpacity(0.8);
    }
  }

  double _getBarHeight(String mood) {
    switch (mood) {
      case 'Terrible':
        return 40.0;
      case 'Bad':
        return 80.0;
      case 'Neutral':
        return 120.0;
      case 'Good':
        return 160.0;
      case 'Excellent':
        return 190.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        // Query the mood entries, ordered by timestamp in descending order (latest first)
        stream: FirebaseFirestore.instance
            .collection('mood_entries')
            .orderBy('timestamp', descending: true) // Fetch latest entries first
            .limit(5) // Limit to the 5 most recent entries
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No mood entries available.'));
          }

          final moodEntries = snapshot.data!.docs;

          // Reverse the list to display oldest to newest
          final reversedEntries = moodEntries.reversed.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFDED7FA).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mood chart",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Pangram',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      reversedEntries.length.clamp(0, 5),
                          (index) {
                        final mood = reversedEntries[index]['mood'];
                        final timestamp = reversedEntries[index]['timestamp'];
                        final time = TimeOfDay.fromDateTime(
                          (timestamp as Timestamp).toDate(),
                        ).format(context);
                        final date =
                        DateFormat('MMM dd').format(timestamp.toDate());

                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                // The background bar
                                Container(
                                  height: 200,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                // The colored fill bar
                                Container(
                                  height: _getBarHeight(mood),
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: _getMoodColor(mood),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                // The image positioned just above the colored fill bar
                                Positioned(
                                  bottom: _getBarHeight(mood) - 30,
                                  child: Image.asset(
                                    _getMoodEmoji(mood),
                                    height: 33,
                                    width: 33,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Display the date
                            Text(
                              date,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Pangram',
                              ),
                            ),
                            // Display the time
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Pangram',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
