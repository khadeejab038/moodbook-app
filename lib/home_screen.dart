import 'modal2.dart';
import 'package:flutter/material.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'history_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/addMood': (context) => AddMoodModal(),
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
              // Top Section (Greeting and Calendar)
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
                              fontFamily: 'Pangram', // Apply Pangram font
                            ),
                            children: [
                              TextSpan(
                                text: "Alexa! 👋",
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Pangram', // Apply Pangram font
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
                            Icon(Icons.local_fire_department,
                                size: 24, color: Colors.orange),
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
                    SizedBox(height: 24),
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

              // Mood Chart Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mood chart",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Pangram'),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            final emojiImages = [
                              'lib/assets/smile.png',
                              'lib/assets/angry.png',
                              'lib/assets/neutral-face.png',
                              'lib/assets/disappointed.png',
                              'lib/assets/angry.png',
                            ];
                            final times = [
                              '10:06',
                              '12:10',
                              '14:40',
                              '18:30',
                              '20:10',
                            ];

                            return Column(
                              children: [
                                // Replace emojis with image assets
                                Image.asset(
                                  emojiImages[index],
                                  height: 24,
                                  width: 24,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 100,
                                  width: 10,
                                  color: Colors.purpleAccent,
                                ),
                                SizedBox(height: 8),
                                // Display the corresponding time
                                Text(
                                  times[index],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'Pangram', // Apply Pangram font
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // Default to Home
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatsPage(),
                  ),
                );
                break;
              case 2:
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  ),
                  builder: (BuildContext context) {
                    return AddMoodModal();
                  },
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(),
                  ),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle), label: "Add Mood"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}

// Add Mood Modal Widget
class AddMoodModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.4,
          colors: [
            Color(0xFFCCEFFF),
            Color(0xFFEFF9F2),
            Color(0xFFCFCFCF),
          ],
          stops: [0.3, 0.8, 1],
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // calendar top left area!!!
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                child: Row(
                  children: [
                    Text('Sun, 4 Jun', style: TextStyle(fontFamily: 'Pangram')), // Apply Pangram font
                    SizedBox(width: 10),
                    Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
              SizedBox(width: 40),
              Text("1/4", style: TextStyle(fontFamily: 'Pangram')), // Apply Pangram font
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal sheet
                },
                child: const Icon(Icons.close, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(6.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "What's your mood right now?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 280,
            child: Text(
              "Select mood that reflects the most how you are feeling at this moment.",
              style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 180),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Stack(
              children: [
                Image.asset('lib/assets/emojibar-def.png'),
              ],
            ),
          ),
          SizedBox(height: 200),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B4CFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              minimumSize: const Size(350, 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TwoByFour(),
                ),
              );
            },
            child: Text("Continue", style: TextStyle(color: Colors.white, fontFamily: 'Pangram')), // Apply Pangram font
          ),
        ],
      ),
    );
  }
}
