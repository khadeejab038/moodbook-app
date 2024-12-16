import 'package:firebasebackend/home_screen.dart';
import 'package:flutter/material.dart';

import 'modal3.dart';

class TwoByFour extends StatefulWidget {
  const TwoByFour({super.key});

  @override
  State<TwoByFour> createState() => _TwoByFourState();
}

class EmojiItem {
  final String imagePath;
  final String title;

  EmojiItem({required this.imagePath, required this.title});
}

class _TwoByFourState extends State<TwoByFour> {
  final List<EmojiItem> allEmotions = [
    EmojiItem(imagePath: 'lib/assets/neutral-face.png', title: 'Neutral'),
    EmojiItem(imagePath: 'lib/assets/heart-eyes.png', title: 'Heart Eyes'),
    EmojiItem(imagePath: 'lib/assets/angry.png', title: 'Angry'),
    EmojiItem(imagePath: 'lib/assets/confused.png', title: 'Confused'),
    EmojiItem(imagePath: 'lib/assets/disappointed.png', title: 'Disappointed'),
    EmojiItem(imagePath: 'lib/assets/fear.png', title: 'Fear'),
  ];

  Set<String> selectedEmotions = {}; // To track selected emotions
  String searchQuery = ''; // Search query to filter emotions

  @override
  Widget build(BuildContext context) {
    // Filtered emotions list based on the search query
    final filteredEmotions = allEmotions
        .where((emotion) => emotion.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
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
            child: SingleChildScrollView( // Allows scrolling if content exceeds the screen
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomeScreen()));
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

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose the emotions that make you feel neutral",
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


                  if (selectedEmotions.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "Selected Emotions:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      spacing: 12.0,
                      children: selectedEmotions.map((emotionTitle) {
                        return Chip(
                          label: Text(
                            emotionTitle,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: Colors.purple[200],
                        );
                      }).toList(),
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.only(right: 200),
                    child: Text(
                      "Recently Emotions:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 10),


                  Wrap(
                    spacing: 20.0,
                    runSpacing: 8.0,
                    children: filteredEmotions.map((emotion) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedEmotions.contains(emotion.title)) {
                              selectedEmotions.remove(emotion.title);
                            } else {
                              selectedEmotions.add(emotion.title);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: selectedEmotions.contains(emotion.title)
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

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.only(right: 240),
                    child: Text(
                      "All Emotions:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 10),


                  Wrap(
                    spacing: 20.0,
                    runSpacing: 8.0,
                    children: filteredEmotions.map((emotion) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedEmotions.contains(emotion.title)) {
                              selectedEmotions.remove(emotion.title);
                            } else {
                              selectedEmotions.add(emotion.title);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: selectedEmotions.contains(emotion.title)
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

                  SizedBox(height: 5,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B4CFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      minimumSize: const Size(350, 10),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReasonSelection(),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
