import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MoodHeatmap extends StatefulWidget {
  @override
  _MoodHeatmapState createState() => _MoodHeatmapState();
}

class _MoodHeatmapState extends State<MoodHeatmap> {
  final Map<String, int> moodValues = {
    "Terrible": 1,
    "Bad": 2,
    "Neutral": 3,
    "Good": 4,
    "Excellent": 5,
  };

  DateTime _currentMonth = DateTime.now();

  // Calculate mood color based on mood value
  Color _getMoodColor(int? moodValue) {
    switch (moodValue) {
      case 1:
        return Colors.red[300]!;
      case 2:
        return Colors.orange[200]!;
      case 3:
        return Colors.yellow[300]!;
      case 4:
        return Colors.lightGreen[200]!;
      case 5:
        return Colors.green[300]!;
      default:
        return Colors.grey[300]!; // No data
    }
  }

  // Navigate between months
  void _changeMonth(int increment) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + increment,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Prepare data
        final moodEntries = snapshot.data!.docs;
        Map<String, List<String>> moodData = {};

        for (var entry in moodEntries) {
          final timestamp = (entry['timestamp'] as Timestamp).toDate();
          final date = DateFormat('yyyy-MM-dd').format(timestamp);
          final mood = entry['mood'] as String;
          moodData.putIfAbsent(date, () => []).add(mood);
        }

        // Generate heatmap for the current month
        final startOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
        final daysInMonth =
            DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

        List<Widget> heatmapSquares = [];
        for (int i = 0; i < daysInMonth; i++) {
          final currentDate = startOfMonth.add(Duration(days: i));
          final dateString = DateFormat('yyyy-MM-dd').format(currentDate);

          // Determine if the date is in the future
          final isFutureDate = currentDate.isAfter(DateTime.now());

          // Calculate average mood value for the day
          final moodsForDay = moodData[dateString] ?? [];
          int? averageMoodValue;
          if (moodsForDay.isNotEmpty) {
            final moodRatings =
            moodsForDay.map((mood) => moodValues[mood] ?? 3).toList();
            averageMoodValue = (moodRatings.reduce((a, b) => a + b) /
                moodRatings.length)
                .round();
          }

          heatmapSquares.add(
            Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isFutureDate
                    ? Colors.grey[300]!
                    : _getMoodColor(averageMoodValue),
                borderRadius: BorderRadius.circular(15.0),
              ),
              height: 40.0,
              width: 40.0,
              child: Center(
                child: Text(
                  "${currentDate.day}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFutureDate
                        ? Colors.grey[100]
                        : averageMoodValue != null
                        ? Colors.white
                        : Colors.black38,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  "${DateFormat('MMMM yyyy').format(_currentMonth)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Heatmap
            Wrap(
              children: heatmapSquares,
            ),
          ],
        );
      },
    );
  }
}
