import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../widgets/responsive_extension.dart';

class AddMoodPopup extends StatelessWidget {
  final String mood;

  const AddMoodPopup({
    super.key,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    // Define the custom text and image path for each mood
    final Map<String, Map<String, String>> moodData = {
      'Terrible': {
        'boldText': "Not every day is easy, and that’s okay",
        'regularText': "Small steps like tracking your mood can pave the way to brighter days over time. Keep going—you’ve got this!",
        'imagePath': 'assets/smile.png', // Path for Terrible mood image
      },
      'Bad': {
        'boldText': "It’s okay to have tough days",
        'regularText': "By taking the time to reflect on your feelings, you’re already doing something positive for yourself. Stay strong—you’re making progress!",
        'imagePath': 'assets/smile.png', // Path for Bad mood image
      },
      'Neutral': {
        'boldText': "Neutral days are an important part of the journey",
        'regularText': "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
        'imagePath': 'assets/smile.png', // Path for Neutral mood image
      },
      'Good': {
        'boldText': "It’s wonderful to see you feeling good!",
        'regularText': "Consistency is key—keep reflecting on what works for you and growing from each day. You’re doing great!",
        'imagePath': 'assets/halo.png', // Path for Good mood image
      },
      'Excellent': {
        'boldText': "You’re in a great place today!",
        'regularText': "Take a moment to celebrate your wins and reflect on what brings you joy. Keep tracking to stay connected with these positive feelings.",
        'imagePath': 'assets/goodtogo.png', // Path for Excellent mood image
      },
    };

    // Safely fetch mood data or use a default value
    final selectedMood = moodData[mood] ?? {
      'boldText': "Neutral days are an important part of the journey.",
      'regularText': "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
      'imagePath': 'assets/goodtogo.png', // Default image path
    };

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.w(7.5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: context.w(5)),
              child: Image.asset(selectedMood['imagePath'] ?? 'assets/goodtogo.png'),
            ),
            Text(
              selectedMood['boldText'] ?? "Neutral days are an important part of the journey.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pangram',
                fontSize: context.w(5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.h(1.2)),
            Text(
              selectedMood['regularText'] ?? "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pangram',
                fontSize: context.w(3.5),
                color: Colors.black38,
              ),
            ),
            SizedBox(height: context.h(2.5)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4CFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.w(10)),
                ),
                minimumSize: Size(context.w(50), context.h(6)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                );
              },
              child: Text(
                'Got it',
                style: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: context.w(4.5),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
