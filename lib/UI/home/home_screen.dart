import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/UI/home/mood_chart.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../addMood/addMood_page1.dart';
import 'daily_average_mood.dart';

class HomeScreen extends StatelessWidget {

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
    return MaterialApp(
      routes: {
        '/addMood': (context) => AddMood(),
      },
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8E3D9).withOpacity(0.7),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section (Greeting)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
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
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Pangram',
                                  ),
                                ),
                              );
                            }
                        ),
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.local_fire_department,
                              size: 24,
                              color: Colors.orange,
                            ),
                            Text(
                              "5",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontFamily: 'Pangram',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Calendar Row
                    DailyAverageMood(),
                  ],
                ),
              ),
              Divider(color: Colors.transparent),
              // Today's Check-in Section
              Padding(
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
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.pink[100],
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.pink,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Check-in",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pangram',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "3/3",
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
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF8E8E),
                                      Color(0xFFFF3CBE),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.pink[50],
                                    child: Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
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
              SizedBox(height: 20),
              // Mood Chart Section
              Expanded(
                child: MoodChart(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 0),
      ),
    );
  }
}
