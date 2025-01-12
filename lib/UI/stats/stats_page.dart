import 'package:flutter/material.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'mood_heatmap.dart';
import 'mood_piechart.dart';
import 'emotion_triggers.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          child: SingleChildScrollView(
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
                    padding: EdgeInsets.all(16.0),
                    child: MoodHeatmap(),
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
                    child: MoodPieChart(),
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
                    child: EmotionTriggersInsight(),
                  ),
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
