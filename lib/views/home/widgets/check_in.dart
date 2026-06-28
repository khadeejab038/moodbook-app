import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/mood_entry_controller.dart';
import '../../../controllers/check_in_controller.dart';
import '../../add_mood/add_mood_screen1_mood.dart';
import '../../settings/app_preferences/notifications_settings_screen.dart';
import '../../widgets/responsive_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class CheckInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return FutureBuilder<int>(
      future: Provider.of<MoodEntryController>(context, listen: false)
          .countMoodEntriesToday(), // Fetch the completed check-ins count
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyles.body.copyWith(color: textColor)));
        } else {
          final completedCheckIns = snapshot.data ?? 0;

          // Get the total number of enabled check-in reminders set by the user
          final checkInProvider = Provider.of<CheckInController>(context);
          final totalReminders = checkInProvider.getEnabledCheckInRemindersCount();

          // Determine theme-aware check-in colors
          final Color cardBg = totalReminders == 0
              ? (isDark ? AppColors.cardDark : AppColors.checkInGoalBg)
              : (isDark ? AppColors.cardDark : AppColors.checkInActiveBg);

          final Color iconBg = totalReminders == 0
              ? (isDark ? Colors.blue.withOpacity(0.2) : AppColors.checkInGoalIcon)
              : (isDark ? Colors.pink.withOpacity(0.2) : AppColors.checkInActiveIcon);

          final Color iconColor = totalReminders == 0
              ? AppColors.checkInGoalAccent
              : AppColors.checkInActiveAccent;

          return GestureDetector(
            onTap: () {
              // Navigate to the appropriate screen based on total reminders
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (totalReminders == 0) {
                      return NotificationsSettingsPage(); // Redirect to Notifications settings
                    } else {
                      return AddMood(); // Proceed to AddMood if check-in reminders are set
                    }
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's check-in",
                    style: AppTextStyles.heading2.copyWith(
                      fontSize: context.w(5),
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: context.h(2.5)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(5),
                      vertical: context.h(1.5),
                    ),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(context.w(5)),
                      border: isDark ? Border.all(color: Colors.grey.shade800) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: context.w(6),
                                backgroundColor: iconBg,
                                child: Icon(
                                  totalReminders == 0
                                      ? Icons.notifications
                                      : Icons.check_circle,
                                  color: iconColor,
                                ),
                              ),
                              SizedBox(width: context.w(2)),
                              Expanded(
                                child: Text(
                                  totalReminders == 0
                                      ? "Set a goal for daily check-ins!"
                                      : "Check-in",
                                  style: AppTextStyles.bodySemiBold.copyWith(
                                    fontSize: context.w(3.75),
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              totalReminders == 0
                                  ? ""
                                  : completedCheckIns >= totalReminders
                                  ? "$totalReminders/$totalReminders"
                                  : "$completedCheckIns/$totalReminders",
                              style: AppTextStyles.bodyBold.copyWith(
                                fontSize: context.w(4),
                                color: textColor,
                              ),
                            ),
                            SizedBox(width: context.w(2)),
                            Container(
                              width: context.w(10),
                              height: context.w(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: totalReminders == 0
                                    ? iconBg
                                    : (isDark ? Colors.pink.withOpacity(0.1) : AppColors.checkInActiveBg),
                              ),
                              child: Center(
                                child: totalReminders == 0
                                    ? Icon(Icons.arrow_forward, color: iconColor, size: context.w(5))
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
