import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../models/emoji_item.dart';
import '../../../models/emoji_data.dart';
import '../../widgets/responsive_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class MoodChart extends StatelessWidget {
  String _getMoodEmoji(String mood) {
    final moodItem = moods.firstWhere(
          (emoji) => emoji.title.toLowerCase() == mood.toLowerCase(),
      orElse: () => EmojiItem(
        imagePath: 'assets/neutral-face.png',
        title: 'Neutral',
      ),
    );
    return moodItem.imagePath;
  }

  double _getBarHeight(String mood, BuildContext context) {
    switch (mood.toLowerCase()) {
      case 'terrible':
        return context.h(5);
      case 'bad':
        return context.h(10);
      case 'neutral':
        return context.h(15);
      case 'good':
        return context.h(20);
      case 'excellent':
        return context.h(23.75);
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = isDark ? AppColors.cardStatsDark : AppColors.cardStatsLight;
    final trackColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mood_entries')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Failed to load mood chart: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No mood entries available.', style: AppTextStyles.body.copyWith(color: textColor)));
          }

          final moodEntries = snapshot.data!.docs;
          final reversedEntries = moodEntries.reversed.toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: context.h(2)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(context.w(3)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
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
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: context.w(5),
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(reversedEntries.length, (index) {
                            final data = reversedEntries[index].data() as Map<String, dynamic>?;
                            final mood = data?['mood'] as String? ?? 'Neutral';
                            final rawTimestamp = data?['timestamp'];
                            DateTime parsedTime = DateTime.now();
                            if (rawTimestamp is Timestamp) {
                              parsedTime = rawTimestamp.toDate();
                            }
                            final time = TimeOfDay.fromDateTime(parsedTime).format(context);
                            final date = DateFormat('MMM dd').format(parsedTime);

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
                                          color: trackColor,
                                          borderRadius: BorderRadius.circular(barWidth / 2),
                                        ),
                                      ),
                                      Container(
                                        height: _getBarHeight(mood, context),
                                        width: barWidth,
                                        decoration: BoxDecoration(
                                          color: AppColors.forMood(mood),
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
                                    style: AppTextStyles.caption.copyWith(
                                      color: subtitleColor,
                                      fontSize: context.w(2.6),
                                    ),
                                  ),
                                  Text(
                                    time,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(
                                      color: subtitleColor,
                                      fontSize: context.w(2.6),
                                    ),
                                  ),
                                ],
                              ),
                            );
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
