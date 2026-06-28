import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../stats/stats_screen.dart';
import '../add_mood/add_mood_screen1_mood.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StatsPage()),
                );
                break;
              case 2:
              // FAB handles Add Mood
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF8B4CFC),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Image.asset('assets/home.png'), label: "Home"),
            BottomNavigationBarItem(icon: Image.asset('assets/stats.png'), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.add, size: 0), label: ""), // Placeholder for FAB
            BottomNavigationBarItem(icon: Image.asset('assets/cal.png'), label: "History"),
            BottomNavigationBarItem(icon: Image.asset('assets/settings.png'), label: "Settings"),
          ],
          // Wrap in a Container to adjust height
          iconSize: 30, // Adjust icon size if needed
          elevation: 5, // Optional: add elevation for shadow effect
          selectedFontSize: 14,  // Adjust font size if needed
          unselectedFontSize: 12, // Adjust font size if needed
          backgroundColor: Colors.white, // Optional: set background color if needed
        ),


        Positioned(
          bottom: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMood()),
                  );
                },
                backgroundColor: const Color(0xFF8B4CFC), // Button color
                elevation: 5, // Adds shadow for a floating effect
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
                shape: const CircleBorder(),
                tooltip: 'Add Mood', // Tooltip for accessibility
              ),


              const SizedBox(height: 3),
              const Text(
                'Add Mood',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
