import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../stats/stats_screen.dart';
import '../add_mood/add_mood_screen1_mood.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? AppColors.navBarDark : AppColors.navBarLight;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); break;
              case 1: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatsPage())); break;
              case 2: break; // FAB handles Add Mood
              case 3: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryPage())); break;
              case 4: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsPage())); break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          backgroundColor: navBgColor,
          items: [
            BottomNavigationBarItem(icon: Image.asset('assets/home.png', color: currentIndex == 0 ? AppColors.primary : Colors.grey), label: "Home"),
            BottomNavigationBarItem(icon: Image.asset('assets/stats.png', color: currentIndex == 1 ? AppColors.primary : Colors.grey), label: "Stats"),
            const BottomNavigationBarItem(icon: Icon(Icons.add, size: 0), label: ""),
            BottomNavigationBarItem(icon: Image.asset('assets/cal.png', color: currentIndex == 3 ? AppColors.primary : Colors.grey), label: "History"),
            BottomNavigationBarItem(icon: Image.asset('assets/settings.png', color: currentIndex == 4 ? AppColors.primary : Colors.grey), label: "Settings"),
          ],
          iconSize: 30,
          elevation: 5,
          selectedFontSize: 14,
          unselectedFontSize: 12,
        ),
        Positioned(
          bottom: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMood()));
                },
                backgroundColor: AppColors.primary,
                elevation: 5,
                shape: const CircleBorder(),
                tooltip: 'Add Mood',
                child: const Icon(Icons.add, size: 30, color: Colors.white),
              ),
              const SizedBox(height: 3),
              Text(
                'Add Mood',
                style: AppTextStyles.navLabel.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
