import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

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

  // Calculate mood color based on average mood value
  Color _getMoodColor(int? moodValue, bool isDark) {
    switch (moodValue) {
      case 1:
        return AppColors.moodTerrible;
      case 2:
        return AppColors.moodBad;
      case 3:
        return AppColors.moodNeutral;
      case 4:
        return AppColors.moodGood;
      case 5:
        return AppColors.moodExcellent;
      default:
        return isDark ? Colors.grey.shade800 : Colors.grey.shade300;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load heatmap: ${snapshot.error}',
                style: AppTextStyles.body.copyWith(color: textColor),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Prepare data
        final moodEntries = snapshot.data!.docs;
        Map<String, List<String>> moodData = {};

        for (var entry in moodEntries) {
          final data = entry.data() as Map<String, dynamic>?;
          if (data == null) continue;

          final rawTimestamp = data['timestamp'];
          DateTime parsedTime = DateTime.now();
          if (rawTimestamp is Timestamp) {
            parsedTime = rawTimestamp.toDate();
          }

          final date = DateFormat('yyyy-MM-dd').format(parsedTime);
          final mood = data['mood'] as String? ?? 'Neutral';
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
                    ? (isDark ? Colors.grey.shade900 : Colors.grey.shade200)
                    : _getMoodColor(averageMoodValue, isDark),
                borderRadius: BorderRadius.circular(15.0),
              ),
              height: 40.0,
              width: 40.0,
              child: Center(
                child: Text(
                  "${currentDate.day}",
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 12,
                    color: isFutureDate
                        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
                        : averageMoodValue != null
                        ? Colors.white
                        : (isDark ? Colors.grey.shade400 : Colors.black54),
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
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  "${DateFormat('MMMM yyyy').format(_currentMonth)}",
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: textColor),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Heatmap
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: heatmapSquares,
              ),
            ),
          ],
        );
      },
    );
  }
}
