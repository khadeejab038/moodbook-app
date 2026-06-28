import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/views/home/widgets/mood_chart.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../add_mood/add_mood_screen1_mood.dart';
import 'widgets/check_in.dart';
import 'widgets/daily_average_mood.dart';
import 'package:provider/provider.dart';
import '../../controllers/check_in_controller.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure CheckIn reminders are loaded when HomeScreen is initialized
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Initialize and load reminders
      Provider.of<CheckInController>(context, listen: false).loadCheckInReminders();
    }
  }

  Future<String?> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Using current user's UID
          .get();

      if (userDoc.exists) {
        // Return the 'name' field of the document
        return userDoc['name'];
      }
    }
    return null; // Return null if user is not found or there's an issue
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.homeGradientDark : AppColors.homeGradientLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (Greeting)
            Padding(
              padding: EdgeInsets.all(context.w(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<String?>(
                          future: _getUserName(), // Fetch the user name
                          builder: (context, snapshot) {
                            String greetingText = "Hey! 👋"; // Default greeting with emoji

                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData && snapshot.data != null) {
                                // Capitalize the first letter of the first name
                                String fullName = snapshot.data!;
                                String firstName = fullName.split(' ')[0]; // Get the first name
                                firstName = firstName[0].toUpperCase() + firstName.substring(1); // Capitalize the first letter

                                greetingText = "Hey, $firstName! 👋"; // Display first name if found
                              }
                            }

                            return RichText(
                              text: TextSpan(
                                text: greetingText, // Display the correct greeting
                                style: AppTextStyles.heading1.copyWith(
                                  fontSize: context.w(6),
                                  color: textColor,
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(3.5)),
                  // Calendar Row
                  DailyAverageMood(),
                ],
              ),
            ),
            const Divider(color: Colors.transparent),
            // Today's Check-in Section
            Consumer<CheckInController>(
              builder: (context, checkInProvider, child) {
                return CheckInWidget(); // The CheckInWidget now listens to changes from the provider
              },
            ),

            // Mood Chart Section
            Expanded(
              child: MoodChart(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
