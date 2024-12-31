// import 'package:flutter/material.dart';
// import '../UI/home_screen.dart';
// import '../UI/stats_page.dart';
// import '../UI/addMood_page1.dart';
// import '../UI/history_page.dart';
// import '../UI/settings_page.dart';
//
// class BottomNavBar extends StatelessWidget {
//   final int currentIndex;
//
//   BottomNavBar({required this.currentIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//             break;
//           case 1:
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => StatsPage()),
//             );
//             break;
//           case 2:
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
//               ),
//               builder: (BuildContext context) {
//                 return AddMood();
//               },
//             );
//             break;
//           case 3:
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HistoryPage()),
//             );
//             break;
//           case 4:
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => SettingsPage()),
//             );
//             break;
//         }
//       },
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.purple,
//       unselectedItemColor: Colors.grey,
//       items: [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
//         BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add Mood"),
//         BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../UI/home/home_screen.dart';
import '../UI/stats/stats_page.dart';
import '../UI/addMood/addMood_page1.dart';
import '../UI/history/history_page.dart';
import '../UI/settings/settings_page.dart';

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
            BottomNavigationBarItem(icon: Image.asset('lib/assets/home.png'), label: "Home"),
            BottomNavigationBarItem(icon: Image.asset('lib/assets/stats.png'), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.add, size: 0), label: ""), // Placeholder for FAB
            BottomNavigationBarItem(icon: Image.asset('lib/assets/cal.png'), label: "History"),
            BottomNavigationBarItem(icon: Image.asset('lib/assets/settings.png'), label: "Settings"),
          ],
          // Wrap in a Container to adjust height
          iconSize: 30, // Adjust icon size if needed
          elevation: 5, // Optional: add elevation for shadow effect
          selectedFontSize: 14,  // Adjust font size if needed
          unselectedFontSize: 12, // Adjust font size if needed
          backgroundColor: Colors.white, // Optional: set background color if needed
        ),

        // BottomNavigationBar(
        //   currentIndex: currentIndex,
        //   onTap: (index) {
        //     switch (index) {
        //       case 0:
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => HomeScreen()),
        //         );
        //         break;
        //       case 1:
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => StatsPage()),
        //         );
        //         break;
        //       case 2:
        //       // FAB handles Add Mood
        //         break;
        //       case 3:
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => HistoryPage()),
        //         );
        //         break;
        //       case 4:
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => SettingsPage()),
        //         );
        //         break;
        //     }
        //   },
        //   type: BottomNavigationBarType.fixed,
        //   selectedItemColor: Color(0xFF8B4CFC),
        //   unselectedItemColor: Colors.grey,
        //   items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        //     BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        //     BottomNavigationBarItem(icon: Icon(Icons.add, size: 0), label: ""), // Placeholder for FAB
        //     BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        //   ],
        // ),
        Positioned(
          bottom: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
                    ),
                    builder: (BuildContext context) {
                      return AddMood();
                    },
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
