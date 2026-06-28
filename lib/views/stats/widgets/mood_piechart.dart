import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class MoodPieChart extends StatefulWidget {
  @override
  _MoodPieChartState createState() => _MoodPieChartState();
}

class _MoodPieChartState extends State<MoodPieChart> {
  final Map<String, int> moodValues = {
    "Terrible": 1,
    "Bad": 2,
    "Neutral": 3,
    "Good": 4,
    "Excellent": 5,
  };

  String selectedView = 'Today'; // Default view

  Future<Map<String, double>> _fetchMoodData(String period) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case 'This Week':
        startDate = now.subtract(Duration(days: 7));
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'This Year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('mood_entries')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .orderBy('timestamp', descending: false)
        .get();

    final moodCounts = {
      "Terrible": 0.0,
      "Bad": 0.0,
      "Neutral": 0.0,
      "Good": 0.0,
      "Excellent": 0.0,
    };

    for (var entry in querySnapshot.docs) {
      final mood = entry['mood'] as String?;
      if (mood != null && moodCounts.containsKey(mood)) {
        moodCounts[mood] = moodCounts[mood]! + 1;
      }
    }

    final total = moodCounts.values.reduce((a, b) => a + b);
    if (total > 0) {
      moodCounts.updateAll((key, value) => (value / total) * 100);
    }

    return moodCounts;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Column(
      children: [
        // Dropdown for time period selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedView,
              dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              style: AppTextStyles.body.copyWith(color: textColor),
              items: ['Today', 'This Week', 'This Month', 'This Year']
                  .map((view) => DropdownMenuItem(
                value: view,
                child: Text(
                  view,
                  style: AppTextStyles.body.copyWith(color: textColor),
                ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedView = value!;
                });
              },
            ),
          ],
        ),
        FutureBuilder<Map<String, double>>(
          future: _fetchMoodData(selectedView),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            final hasData = data.values.any((val) => val > 0);

            if (!hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No data recorded for this period",
                    style: AppTextStyles.body.copyWith(color: textColor),
                  ),
                ),
              );
            }

            return AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: data.entries
                      .map(
                        (entry) => PieChartSectionData(
                      color: AppColors.forMood(entry.key),
                      value: entry.value,
                      title: entry.value > 0 ? '${entry.key} (${entry.value.toStringAsFixed(1)}%)' : '',
                      radius: 80,
                      titleStyle: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1, 1))
                        ]
                      ),
                    ),
                  )
                      .toList(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 20,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
