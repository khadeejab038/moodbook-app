import 'package:flutter/material.dart';
import '../home/home_screen.dart';

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
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Image.asset(selectedMood['imagePath'] ?? 'assets/goodtogo.png'),
            ),
            Text(
              selectedMood['boldText'] ?? "Neutral days are an important part of the journey.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Pangram',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedMood['regularText'] ?? "Staying consistent with tracking your mood will help you uncover patterns and discover what truly supports your well-being.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Pangram',
                fontSize: 14,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4CFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                );
              },
              child: const Text(
                'Got it',
                style: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: 18,
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
