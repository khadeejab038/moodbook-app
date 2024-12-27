import 'package:provider/provider.dart';
import 'package:firebasebackend/home_screen.dart';
import 'package:flutter/material.dart';
import 'Providers/moodEntry_provider.dart';
import 'Utils/emoji_data.dart';
import 'addMood_page3.dart';

class AddEmotions extends StatefulWidget {
  const AddEmotions({super.key});

  @override
  State<AddEmotions> createState() => _AddEmotionsState();
}

class _AddEmotionsState extends State<AddEmotions> {
  String searchQuery = ''; // Search query to filter emotions

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodEntryProvider>(context);
    final currentMood = moodProvider.moodEntry.getMood;

    // Filtered emotions list based on the search query
    final filteredEmotions = allEmotions
        .where((emotion) => emotion.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height, // Full screen height
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100), // Padding to avoid button overlap
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        BackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 130),
                        const Text("2/4"),
                        const SizedBox(width: 100),
                        ElevatedButton(
                          onPressed: () {
                            moodProvider.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(6.0),
                          ),
                          child: const Icon(Icons.close, color: Colors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Choose the emotions that make you feel $currentMood",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const SizedBox(
                      width: 280,
                      child: Text(
                        "Select at least 1 emotion",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '  Search emotions',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (moodProvider.selectedEmotions.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(right: 200),
                        child: Text(
                          "Selected Emotions:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 12.0,
                        children: moodProvider.selectedEmotions.map((emotionTitle) {
                          // Find the corresponding emoji item by title
                          final emojiItem = allEmotions.firstWhere((item) => item.title == emotionTitle);
                          return Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  emojiItem.imagePath,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  emotionTitle,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.purple[200],
                            deleteIcon: const Icon(Icons.close, size: 16, color: Colors.black),
                            onDeleted: () {
                              moodProvider.toggleEmotion(emotionTitle); // Deselect the emotion
                            },
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 20.0,
                      runSpacing: 8.0,
                      children: filteredEmotions.map((emotion) {
                        return GestureDetector(
                          onTap: () {
                            moodProvider.toggleEmotion(emotion.title); // Use the setter method
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: moodProvider.selectedEmotions.contains(emotion.title)
                                    ? Colors.purple[100]
                                    : Colors.grey[300],
                                radius: 40,
                                child: Image.asset(
                                  emotion.imagePath,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              Text(
                                emotion.title,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Floating "Continue" button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    minimumSize: const Size(350, 10),
                  ),
                  onPressed: () {
                    if (moodProvider.selectedEmotions.isEmpty) {
                      // Show a SnackBar if no emotion is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one emotion before continuing.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Proceed to the next screen if validation passes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddReasons(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
