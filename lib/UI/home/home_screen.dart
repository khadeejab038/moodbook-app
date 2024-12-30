import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widgets/bottom_nav_bar.dart';
import '../addMood/addMood_page1.dart';
import 'mood_chart.dart';

class HomeScreen extends StatelessWidget {
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
                Color(0xFFFFCEB7).withOpacity(0.7),
                Color(0xBACFFF).withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Hey, ",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Pangram',
                            ),
                            children: [
                              TextSpan(
                                text: "Alexa! 👋",
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Pangram',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Sun, 4 Jun",
                              style: TextStyle(color: Colors.grey, fontFamily: 'Pangram'),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.calendar_today, size: 20),
                            SizedBox(width: 16),
                            Icon(Icons.local_fire_department, size: 24, color: Colors.orange),
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
                  ],
                ),
              ),

              // Calendar Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: List.generate(7, (index) {
                        final days = [
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed'
                        ];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: index == 3
                                ? Colors.purple[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          width: 60,
                          child: Column(
                            children: [
                              Text(
                                days[index],
                                style: TextStyle(
                                  color: index == 3
                                      ? Colors.purple
                                      : Colors.black,
                                  fontFamily: 'Pangram', // Apply Pangram font
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: index == 3
                                      ? Colors.purple
                                      : Colors.black,
                                  fontFamily: 'Pangram', // Apply Pangram font
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: List.generate(7, (index) {
                        final emojis = [
                          'lib/assets/smile.png',
                          'lib/assets/disappointed.png',
                          'lib/assets/neutral-face.png',
                          'lib/assets/smile.png',
                          '', // No image for this slot
                          '', // No image for this slot
                          ''
                        ];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          width: 60,
                          child: Center(
                            child: emojis[index].isNotEmpty
                                ? Image.asset(
                              emojis[index],
                              height: 24,
                              width: 24,
                            )
                                : SizedBox.shrink(),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Divider(color: Colors.grey[300]),

              // Today's Check-in Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's check-in",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.pink[100],
                              child: Icon(Icons.check_circle, color: Colors.pink),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Check-in",
                              style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Pangram'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "3/3",
                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.local_fire_department,
                                color: Colors.orange, size: 24),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              MoodChart(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 0),
      ),
    );
  }
}
