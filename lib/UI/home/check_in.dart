import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/moodEntry_provider.dart';
import '../../Providers/checkin_provider.dart'; // Import CheckInProvider
import '../addMood/addMood_page1.dart'; // Import AddMood page
import '../settings/appPreferences/notifications_settings_page.dart';

class CheckInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: Provider.of<MoodEntryProvider>(context, listen: false)
          .countMoodEntriesToday(), // Fetch the completed check-ins count
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final completedCheckIns = snapshot.data ?? 0;

          // Get the total number of enabled check-in reminders set by the user
          final checkInProvider = Provider.of<CheckInProvider>(context);
          final totalReminders = checkInProvider.getEnabledCheckInRemindersCount();

          return GestureDetector(
            onTap: () {
              // Navigate to the appropriate screen based on total reminders
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (totalReminders == 0) {
                      return NotificationsSettingsPage();
                    } else {
                      return AddMood();
                    }
                  },
                ),
              );

            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's check-in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pangram',
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: totalReminders == 0 ? Colors.blue[50] : Colors.pink[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
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
                            SizedBox(width: 8),
                            Text(
                              totalReminders == 0
                                  ? "Set a goal for daily check-ins!"
                                  : "Check-in",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pangram',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              totalReminders == 0
                                  ? ""
                                  : completedCheckIns > totalReminders
                                  ? "$totalReminders/$totalReminders"
                                  : "$completedCheckIns/$totalReminders",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Pangram',
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: totalReminders == 0
                                    ? Colors.blue[100]
                                    : Colors.pink[50],
                              ),
                              child: Center(
                                child: Icon(
                                  totalReminders == 0
                                      ? Icons.arrow_forward
                                      : Icons.local_fire_department,
                                  color: totalReminders == 0
                                      ? Colors.blue
                                      : Colors.orange,
                                  size: 20,
                                ),
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
