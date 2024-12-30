import 'package:flutter/material.dart';
import '../../Widgets/bottom_nav_bar.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Stats',
              style: TextStyle(
                fontFamily: 'Pangram',
                fontWeight: FontWeight.bold,
                color: Color(0xFF100F11),
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF100F11)),
      ),
      body: SingleChildScrollView(
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Data Visualization Here',
                      style: TextStyle(fontFamily: 'Pangram'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Data Visualization Here',
                      style: TextStyle(fontFamily: 'Pangram'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Data Visualization Here',
                      style: TextStyle(fontFamily: 'Pangram'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
