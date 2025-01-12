import 'package:flutter/material.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'mood_heatmap.dart'; // Import heatmap
import 'mood_piechart.dart'; // Import Mood Distribution Chart
import 'emotion_triggers.dart'; // Import Emotion Triggers Insight widget

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Stats',
          style: TextStyle(
            fontFamily: 'Pangram',
            fontWeight: FontWeight.bold,
            color: Color(0xFF100F11),
            fontSize: 20.0,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF100F11)),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xAAC7DFFF),
                  Color(0xFFFFCEB7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Mood Calendar',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF100F11),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDED7FA).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16.0), // Optional padding inside the box
                    child: MoodHeatmap(), // Heatmap widget
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Mood Distribution',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF100F11),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDED7FA).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: MoodPieChart(), // Mood Distribution Pie Chart widget
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Emotion Triggers',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF100F11),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDED7FA).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: EmotionTriggersInsight(), // Emotion Triggers Insight widget
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
