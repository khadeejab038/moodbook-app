import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'widgets/mood_heatmap.dart';
import 'widgets/mood_piechart.dart';
import 'widgets/emotion_triggers.dart';
import '../widgets/responsive_extension.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xAAC7DFFF),
              Color(0xFFFFCEB7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(context.w(4), context.h(7.5), context.w(4), context.h(1)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Stats',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100F11),
                      fontSize: context.w(5),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.h(2.5)),
                        Text(
                          'Mood Calendar',
                          style: TextStyle(
                            fontFamily: 'Pangram',
                            fontWeight: FontWeight.bold,
                            fontSize: context.w(4.5),
                            color: Color(0xFF100F11),
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDED7FA).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(context.w(3)),
                          ),
                          padding: EdgeInsets.all(context.w(4)),
                          child: MoodHeatmap(),
                        ),
                        SizedBox(height: context.h(2.5)),
                        Text(
                          'Mood Distribution',
                          style: TextStyle(
                            fontFamily: 'Pangram',
                            fontWeight: FontWeight.bold,
                            fontSize: context.w(4.5),
                            color: Color(0xFF100F11),
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDED7FA).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(context.w(3)),
                          ),
                          padding: EdgeInsets.all(context.w(4)),
                          child: MoodPieChart(),
                        ),
                        SizedBox(height: context.h(2.5)),
                        Text(
                          'Emotion Triggers',
                          style: TextStyle(
                            fontFamily: 'Pangram',
                            fontWeight: FontWeight.bold,
                            fontSize: context.w(4.5),
                            color: Color(0xFF100F11),
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDED7FA).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(context.w(3)),
                          ),
                          padding: EdgeInsets.all(context.w(4)),
                          child: EmotionTriggersInsight(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
