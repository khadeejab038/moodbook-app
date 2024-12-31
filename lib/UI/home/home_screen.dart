import 'package:firebasebackend/UI/home/mood_chart.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../addMood/addMood_page1.dart';

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
              // Top Section (Greeting and Calendar)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
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
                              fontFamily: 'Pangram', // Apply Pangram font
                            ),
                            children: [
                              TextSpan(
                                text: "Alexa! 👋",
                                style: TextStyle(
                                  color: Color(0xFF8B4CFC),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Pangram', // Apply Pangram font
                                ),
                              ),
                            ],
                          ),
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
                                      ? Color(0xFF8B4CFC)
                                      : Colors.white70,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                width: 60,
                                child: Column(
                                  children: [
                                    Text(
                                      days[index],
                                      style: TextStyle(
                                        color: index == 3
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Pangram',
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: index == 3
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Pangram',
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
