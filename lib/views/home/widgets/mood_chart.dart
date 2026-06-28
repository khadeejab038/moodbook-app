import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../../../models/emoji_item.dart';
import '../../../models/emoji_data.dart';
import '../../widgets/responsive_extension.dart';

class MoodChart extends StatelessWidget {
  String _getMoodEmoji(String mood) {
    final moodItem = moods.firstWhere(
          (emoji) => emoji.title == mood,
      orElse: () => EmojiItem(
        imagePath: 'assets/neutral-face.png',
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

  double _getBarHeight(String mood, BuildContext context) {
    switch (mood) {
      case 'Terrible':
        return context.h(5);
      case 'Bad':
        return context.h(10);
      case 'Neutral':
        return context.h(15);
      case 'Good':
        return context.h(20);
      case 'Excellent':
        return context.h(23.75);
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
        // Query the mood entries, ordered by timestamp in descending order (latest first)
        stream: FirebaseFirestore.instance
            .collection('mood_entries')
            .where('userId', isEqualTo: userId)
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
            padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: context.h(2)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFDED7FA).withOpacity(0.8),
                borderRadius: BorderRadius.circular(context.w(3)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Each slot gets equal width; bars are 60% of slot, giving breathing room
                  final slotWidth = constraints.maxWidth / 5;
                  final barWidth = slotWidth * 0.55;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: context.h(2)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: context.h(1.5), left: context.w(4)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Mood chart",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.w(5),
                                fontFamily: 'Pangram',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            if (index < reversedEntries.length) {
                              final mood = reversedEntries[index]['mood'];
                              final timestamp = reversedEntries[index]['timestamp'];
                              final time = TimeOfDay.fromDateTime(
                                (timestamp as Timestamp).toDate(),
                              ).format(context);
                              final date = DateFormat('MMM dd').format(timestamp.toDate());

                              return SizedBox(
                                width: slotWidth,
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: context.h(25),
                                          width: barWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(barWidth / 2),
                                          ),
                                        ),
                                        Container(
                                          height: _getBarHeight(mood, context),
                                          width: barWidth,
                                          decoration: BoxDecoration(
                                            color: _getMoodColor(mood),
                                            borderRadius: BorderRadius.circular(barWidth / 2),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: _getBarHeight(mood, context) - barWidth,
                                          child: Image.asset(
                                            _getMoodEmoji(mood),
                                            height: barWidth * 1.1,
                                            width: barWidth * 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.h(1)),
                                    Text(
                                      date,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: context.w(2.6),
                                        fontFamily: 'Pangram',
                                      ),
                                    ),
                                    Text(
                                      time,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: context.w(2.6),
                                        fontFamily: 'Pangram',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: slotWidth,
                                child: Column(
                                  children: [
                                    Container(
                                      height: context.h(25),
                                      width: barWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(barWidth / 2),
                                      ),
                                    ),
                                    SizedBox(height: context.h(1)),
                                    Text("", style: TextStyle(fontSize: context.w(2.6))),
                                    Text("", style: TextStyle(fontSize: context.w(2.6))),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        SizedBox(height: context.h(2)),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
  }
}
