import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../Models/emoji_item.dart';
import '../../Utils/emoji_data.dart';

class DailyAverageMood extends StatefulWidget {
  @override
  _DailyAverageMoodState createState() => _DailyAverageMoodState();
}

class _DailyAverageMoodState extends State<DailyAverageMood> {
  final ScrollController _scrollController = ScrollController();

  // Mapping mood titles to numeric ratings
  final Map<String, int> moodValues = {
    "Terrible": 1,
    "Bad": 2,
    "Neutral": 3,
    "Good": 4,
    "Excellent": 5,
  };

  // Get the correct emoji asset path for a given mood rating
  String _getMoodEmoji(int moodRating) {
    final moodItem = moods.firstWhere(
          (emoji) => moodValues[emoji.title] == moodRating,
      orElse: () => EmojiItem(
        imagePath: 'lib/assets/neutral-face.png',
        title: 'Neutral',
      ),
    );
    return moodItem.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .snapshots(), // Listen for real-time updates
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
            // Calculate the average mood rating for the day
            final moodList = moodData[dateString]!;
            final moodRatings = moodList.map((mood) => moodValues[mood] ?? 3).toList();
            final averageMoodRating = (moodRatings.reduce((a, b) => a + b) / moodRatings.length).round();

            // Find the corresponding emoji
            final averageMoodTitle = moodValues.keys.firstWhere(
                  (key) => moodValues[key] == averageMoodRating,
              orElse: () => 'Neutral',
            );

            return {
              'day': DateFormat('E').format(date),
              'date': DateFormat('dd').format(date),
              'emoji': _getMoodEmoji(averageMoodRating),
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
          'isNextDay': true,
        });

        // Scroll to the right after the widget is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            children: days.map((day) {
              final isToday = day['isToday'];
              final isNextDay = day['isNextDay'] ?? false;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date bubble
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: isToday
                              ? Color(0xFF8B4CFC)
                              : isNextDay
                              ? Colors.grey[300]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: isToday
                                ? Color(0xFF8B4CFC)
                                : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              day['day'], // Day (e.g., "Mon")
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                color: isToday
                                    ? Colors.white
                                    : isNextDay
                                    ? Colors.grey[700]
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              day['date'], // Date (e.g., "12")
                              style: TextStyle(
                                fontFamily: 'Pangram',
                                color: isToday
                                    ? Colors.white
                                    : isNextDay
                                    ? Colors.grey[700]
                                    : Colors.black,
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
                              : isNextDay
                              ? Colors.grey[300]
                              : Colors.white, // Grey for next day
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
