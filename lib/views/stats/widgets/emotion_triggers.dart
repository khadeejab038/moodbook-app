import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class EmotionTriggersInsight extends StatefulWidget {
  @override
  _EmotionTriggersInsightState createState() => _EmotionTriggersInsightState();
}

class _EmotionTriggersInsightState extends State<EmotionTriggersInsight> {
  Map<String, Map<String, int>> emotionReasonCorrelation = {};
  String selectedRange = "Today"; // Default selection
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmotionTriggersData("Today");
  }

  // Fetch data from Firestore for the selected date range
  Future<void> _fetchEmotionTriggersData(String range) async {
    setState(() {
      _isLoading = true;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Calculate the start date based on the selected range
    DateTime startDate;
    if (range == "Today") {
      startDate = DateTime.now();
    } else if (range == "This Week") {
      startDate = DateTime.now().subtract(Duration(days: 7));
    } else if (range == "This Month") {
      startDate = DateTime.now().subtract(Duration(days: 30));
    } else { // "This Year"
      startDate = DateTime.now().subtract(Duration(days: 365));
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .get();

      Map<String, Map<String, int>> emotionReasonMap = {};

      for (var entry in snapshot.docs) {
        final emotions = List<String>.from(entry['emotions'] ?? []);
        final reasons = List<String>.from(entry['reasons'] ?? []);

        for (var emotion in emotions) {
          for (var reason in reasons) {
            if (!emotionReasonMap.containsKey(emotion)) {
              emotionReasonMap[emotion] = {};
            }
            if (!emotionReasonMap[emotion]!.containsKey(reason)) {
              emotionReasonMap[emotion]![reason] = 0;
            }
            emotionReasonMap[emotion]![reason] = emotionReasonMap[emotion]![reason]! + 1;
          }
        }
      }

      setState(() {
        emotionReasonCorrelation = emotionReasonMap;
        selectedRange = range;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getTimeText(int count) {
    return count == 1 ? "1 time" : "$count times";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.cardDark : Colors.white;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centering the dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: DropdownButton<String>(
                value: selectedRange,
                dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                style: AppTextStyles.body.copyWith(color: textColor),
                onChanged: (String? newRange) {
                  if (newRange != null) {
                    _fetchEmotionTriggersData(newRange);
                  }
                },
                items: <String>['Today', 'This Week', 'This Month', 'This Year']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppTextStyles.body.copyWith(color: textColor),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ))
            else if (emotionReasonCorrelation.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No triggers recorded for this period",
                    style: AppTextStyles.body.copyWith(color: textColor),
                  ),
                ),
              )
            else
              ...emotionReasonCorrelation.entries.map(
                    (emotionEntry) {
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: isDark ? 0 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emotionEntry.key,
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: emotionEntry.value.entries.map(
                                  (reasonEntry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_right, size: 18, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "${reasonEntry.key}: ${_getTimeText(reasonEntry.value)}",
                                          style: AppTextStyles.body.copyWith(
                                            fontSize: 16,
                                            color: subtitleColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
          ],
        ),
      ),
    );
  }
}
