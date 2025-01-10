import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EmotionTriggersInsight extends StatefulWidget {
  @override
  _EmotionTriggersInsightState createState() => _EmotionTriggersInsightState();
}

class _EmotionTriggersInsightState extends State<EmotionTriggersInsight> {
  Map<String, Map<String, int>> emotionReasonCorrelation = {};
  String selectedRange = "Today"; // Default selection

  @override
  void initState() {
    super.initState();
    _fetchEmotionTriggersData("Today");
  }

  // Fetch data from Firestore for the selected date range
  Future<void> _fetchEmotionTriggersData(String range) async {
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

    // Fetch mood entries based on the selected range
    final snapshot = await FirebaseFirestore.instance
        .collection('mood_entries')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .get();

    Map<String, Map<String, int>> emotionReasonMap = {};

    for (var entry in snapshot.docs) {
      final emotions = List<String>.from(entry['emotions']);
      final reasons = List<String>.from(entry['reasons']);

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
    });
  }

  String _getTimeText(int count) {
    return count == 1 ? "1 time" : "$count times";
  }

  @override
  Widget build(BuildContext context) {
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
                      style: TextStyle(
                        fontFamily: 'Pangram', // Pangram font for dropdown
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (emotionReasonCorrelation.isEmpty)
              Center(child: CircularProgressIndicator()),
            ...emotionReasonCorrelation.entries.map(
                  (emotionEntry) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emotionEntry.key,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pangram', // Pangram font for text
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: emotionEntry.value.entries.map(
                                (reasonEntry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_right, size: 18, color: Colors.black),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${reasonEntry.key}: ${_getTimeText(reasonEntry.value)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontFamily: 'Pangram', // Pangram font
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
