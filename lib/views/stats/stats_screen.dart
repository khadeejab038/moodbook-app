import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'widgets/mood_heatmap.dart';
import 'widgets/mood_piechart.dart';
import 'widgets/emotion_triggers.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final cardBg = isDark ? AppColors.cardStatsDark : AppColors.cardStatsLight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.pageGradientDark : AppColors.pageGradientLight,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.w(4), context.h(10), context.w(4), context.h(1)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Stats',
                  style: AppTextStyles.pageTitle.copyWith(
                    color: textColor,
                    fontSize: context.w(5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.h(2.5)),
                      Text(
                        'Mood Calendar',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: context.w(4.5),
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(context.w(3)),
                        ),
                        padding: EdgeInsets.all(context.w(4)),
                        child: MoodHeatmap(),
                      ),
                      SizedBox(height: context.h(2.5)),
                      Text(
                        'Mood Distribution',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: context.w(4.5),
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(context.w(3)),
                        ),
                        padding: EdgeInsets.all(context.w(4)),
                        child: MoodPieChart(),
                      ),
                      SizedBox(height: context.h(2.5)),
                      Text(
                        'Emotion Triggers',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: context.w(4.5),
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(context.w(3)),
                        ),
                        padding: EdgeInsets.all(context.w(4)),
                        child: EmotionTriggersInsight(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
