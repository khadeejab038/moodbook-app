import 'package:flutter/material.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AddMoodPopup extends StatelessWidget {
  final String mood;

  const AddMoodPopup({
    super.key,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    // Define the custom text and image path for each mood
    final Map<String, Map<String, String>> moodData = {
      'Terrible': {
        'boldText': "Not every day is easy, and that’s okay",
        'regularText': "Small steps like tracking your mood can pave the way to brighter days over time. Keep going—you’ve got this!",
        'imagePath': 'assets/smile.png',
      },
      'Bad': {
        'boldText': "It’s okay to have tough days",
        'regularText': "By taking the time to reflect on your feelings, you’re already doing something positive for yourself. Stay strong—you’re making progress!",
        'imagePath': 'assets/smile.png',
      },
      'Neutral': {
        'boldText': "Neutral days are an important part of the journey",
        'regularText': "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
        'imagePath': 'assets/smile.png',
      },
      'Good': {
        'boldText': "It’s wonderful to see you feeling good!",
        'regularText': "Consistency is key—keep reflecting on what works for you and growing from each day. You’re doing great!",
        'imagePath': 'assets/halo.png',
      },
      'Excellent': {
        'boldText': "You’re in a great place today!",
        'regularText': "Take a moment to celebrate your wins and reflect on what brings you joy. Keep tracking to stay connected with these positive feelings.",
        'imagePath': 'assets/goodtogo.png',
      },
    };

    // Safely fetch mood data or use a default value
    final selectedMood = moodData[mood] ?? {
      'boldText': "Neutral days are an important part of the journey.",
      'regularText': "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
      'imagePath': 'assets/goodtogo.png',
    };

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.w(7.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: context.w(5)),
              child: Image.asset(selectedMood['imagePath'] ?? 'assets/goodtogo.png'),
            ),
            Text(
              selectedMood['boldText'] ?? "Neutral days are an important part of the journey.",
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(
                color: textColor,
                fontSize: context.w(5),
              ),
            ),
            SizedBox(height: context.h(1.2)),
            Text(
              selectedMood['regularText'] ?? "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: subtitleColor,
                fontSize: context.w(3.5),
              ),
            ),
            SizedBox(height: context.h(2.5)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.w(10)),
                ),
                minimumSize: Size(context.w(50), context.h(6)),
              ),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              child: Text(
                'Got it',
                style: AppTextStyles.button.copyWith(
                  fontSize: context.w(4.5),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
