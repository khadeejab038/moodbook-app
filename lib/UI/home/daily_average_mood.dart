import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../Models/emoji_item.dart';
import '../../Utils/emoji_data.dart'; // Import your emoji data

class DailyAverageMood extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  // Get the correct emoji asset path for a given mood title
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

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Process mood entries
        final moodEntries = snapshot.data!.docs;
        Map<String, List<String>> moodData = {};

        // Group by date and collect mood titles
        for (var entry in moodEntries) {
          final timestamp = (entry['timestamp'] as Timestamp).toDate();
          final date = DateFormat('yyyy-MM-dd').format(timestamp);
          final mood = entry['mood'] as String;
          moodData.putIfAbsent(date, () => []).add(mood);
        }

        // Generate the past 14 days
        final today = DateTime.now();
        List<Map<String, dynamic>> days = List.generate(14, (index) {
          final date = today.subtract(Duration(days: 13 - index));
          final dateString = DateFormat('yyyy-MM-dd').format(date);

          if (moodData.containsKey(dateString)) {
            // Get the most frequent mood of the day
            final moodList = moodData[dateString]!;
            final moodCount = Map.fromIterable(
              moodList,
              key: (m) => m,
              value: (m) => moodList.where((item) => item == m).length,
            );
            final overallMood = moodCount.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key;

            return {
              'day': DateFormat('E').format(date),
              'date': DateFormat('dd').format(date),
              'emoji': _getMoodEmoji(overallMood),
              'isToday': index == 13,
            };
          }

          return {
            'day': DateFormat('E').format(date),
            'date': DateFormat('dd').format(date),
            'emoji': '', // No emoji for this day
            'isToday': index == 13,
          };
        });

        // Add the "next day" column
        days.add({
          'day': DateFormat('E').format(today.add(Duration(days: 1))),
          'date': DateFormat('dd').format(today.add(Duration(days: 1))),
          'emoji': '', // No emoji for the next day
          'isToday': false,
        });

        // Scroll to the latest date
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            children: days.map((day) {
              final isToday = day['isToday'];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.topCenter, // Aligns content to the top
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Prevents stretching of the Column
                    children: [
                      // Date bubble
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: isToday ? Color(0xFF8B4CFC) : Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: isToday ? Color(0xFF8B4CFC) : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              day['day'], // Day (e.g., "Mon")
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                color: isToday ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              day['date'], // Date (e.g., "12")
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                color: isToday ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5), // Space between date bubble and emoji
                      // Emoji or transparent placeholder
                      day['emoji'].isNotEmpty
                          ? Container(
                        height: 45, // Size for emoji space
                        width: 45,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Color(0xFF8B4CFC)
                              : Colors.white, // Purple only for today
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              day['emoji'],
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      )
                          : Container(
                        height: 45, // Transparent placeholder of same size as emoji
                        width: 45,
                        color: Colors.transparent, // Ensures space is reserved
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
