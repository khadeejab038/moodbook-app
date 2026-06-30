import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../../utils/error_parser.dart';

class EmotionTriggersInsight extends StatefulWidget {
  @override
  _EmotionTriggersInsightState createState() => _EmotionTriggersInsightState();
}

class _EmotionTriggersInsightState extends State<EmotionTriggersInsight> {
  Map<String, Map<String, int>> emotionReasonCorrelation = {};
  String selectedRange = "Today"; // Default selection
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEmotionTriggersData("Today");
  }

  // Fetch data from Firestore for the selected date range
  Future<void> _fetchEmotionTriggersData(String range) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;

    final now = DateTime.now();
    DateTime startDate;
    if (range == "Today") {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (range == "This Week") {
      startDate = now.subtract(const Duration(days: 7));
    } else if (range == "This Month") {
      startDate = DateTime(now.year, now.month - 1, now.day);
    } else { // "This Year"
      startDate = DateTime(now.year - 1, now.month, now.day);
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .get();

      Map<String, Map<String, int>> emotionReasonMap = {};

      for (var entry in snapshot.docs) {
        final data = entry.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final rawEmotions = data['emotions'];
        final rawReasons = data['reasons'];

        final emotions = rawEmotions is List ? List<String>.from(rawEmotions) : <String>[];
        final reasons = rawReasons is List ? List<String>.from(rawReasons) : <String>[];

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

      if (mounted) {
        setState(() {
          emotionReasonCorrelation = emotionReasonMap;
          selectedRange = range;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorParser.getFriendlyMessage(e);
          _isLoading = false;
        });
      }
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
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _fetchEmotionTriggersData(selectedRange),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Retry", style: AppTextStyles.button.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              )
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
