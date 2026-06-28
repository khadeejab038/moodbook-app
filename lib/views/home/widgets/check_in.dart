import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/mood_entry_controller.dart';
import '../../../controllers/check_in_controller.dart'; // Import CheckInController
import '../../add_mood/add_mood_screen1_mood.dart'; // Import AddMood page
import '../../settings/app_preferences/notifications_settings_screen.dart';
import '../../widgets/responsive_extension.dart';

class CheckInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: Provider.of<MoodEntryController>(context, listen: false)
          .countMoodEntriesToday(), // Fetch the completed check-ins count
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final completedCheckIns = snapshot.data ?? 0;

          // Get the total number of enabled check-in reminders set by the user
          final checkInProvider = Provider.of<CheckInController>(context);
          final totalReminders = checkInProvider.getEnabledCheckInRemindersCount();

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
                    style: TextStyle(
                      fontSize: context.w(5),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pangram',
                    ),
                  ),
                  SizedBox(height: context.h(2.5)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(5),
                      vertical: context.h(1.5),
                    ),
                    decoration: BoxDecoration(
                      color: totalReminders == 0 ? Colors.blue[50] : Colors.pink[50],
                      borderRadius: BorderRadius.circular(context.w(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: context.w(6),
                                backgroundColor: totalReminders == 0
                                    ? Colors.blue[100]
                                    : Colors.pink[100],
                                child: Icon(
                                  totalReminders == 0
                                      ? Icons.notifications
                                      : Icons.check_circle,
                                  color: totalReminders == 0 ? Colors.blue : Colors.pink,
                                ),
                              ),
                              SizedBox(width: context.w(2)),
                              Expanded(
                                child: Text(
                                  totalReminders == 0
                                      ? "Set a goal for daily check-ins!"
                                      : "Check-in",
                                  style: TextStyle(
                                    fontSize: context.w(3.75),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Pangram',
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.w(4),
                                  fontFamily: 'Pangram',
                                ),
                            ),
                            SizedBox(width: context.w(2)),
                            Container(
                              width: context.w(10),
                              height: context.w(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: totalReminders == 0
                                    ? Colors.blue[100]
                                    : Colors.pink[50],
                              ),
                              child: Center(
                                child: totalReminders == 0
                                    ? Icon(Icons.arrow_forward, color: Colors.blue, size: context.w(5))
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
