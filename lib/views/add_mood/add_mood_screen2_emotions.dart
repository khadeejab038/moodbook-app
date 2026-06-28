import 'package:provider/provider.dart';
import 'package:firebasebackend/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/emoji_data.dart';
import 'add_mood_screen3_reasons.dart';
import '../widgets/responsive_extension.dart';

class AddEmotions extends StatefulWidget {
  const AddEmotions({super.key});

  @override
  State<AddEmotions> createState() => _AddEmotionsState();
}

class _AddEmotionsState extends State<AddEmotions> {
  String searchQuery = ''; // Search query to filter emotions

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodEntryController>(context);
    final currentMood = moodProvider.moodEntry.getMood.toLowerCase();

    // Filtered emotions list based on the search query
    final filteredEmotions = allEmotions
        .where((emotion) => emotion.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Determine whether to show the "Recently Used" section based on search query
    final showRecentlyUsed = searchQuery.isEmpty;

    return Scaffold(
      body: Container(
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
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              // Standardized Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(3), vertical: context.h(1)),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        "2/4",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontSize: context.w(4.5),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        moodProvider.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.w(5)),
                  child: Column(
                    children: [
                      SizedBox(height: context.h(2)),
                      // Harmonious Centered Headings
                      Text(
                        "Choose the emotions that make you feel $currentMood",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(6),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pangram',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Select at least 1 emotion",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(3.75),
                          fontFamily: 'Pangram',
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: context.h(3)),

                      // Search Bar
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search emotions',
                          labelStyle: const TextStyle(fontFamily: 'Pangram'),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(7.5)),
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                      SizedBox(height: context.h(3)),

                      // Display Selected Emotions Section
                      if (moodProvider.selectedEmotions.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Selected:",
                              style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                            ),
                            TextButton(
                              onPressed: () {
                                moodProvider.clearSelectedEmotions();
                              },
                              child: Text(
                                "Clear all",
                                style: TextStyle(color: Colors.red, fontSize: context.w(3.75), fontFamily: 'Pangram', fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(1.5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: context.w(3),
                            runSpacing: context.h(0.5),
                            children: moodProvider.selectedEmotions.map((emotionTitle) {
                              final emojiItem = allEmotions.firstWhere((item) => item.title == emotionTitle);
                              return Chip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      emojiItem.imagePath,
                                      width: context.w(5),
                                      height: context.w(5),
                                    ),
                                    SizedBox(width: context.w(1.2)),
                                    Text(
                                      emotionTitle,
                                      style: TextStyle(fontSize: context.w(3.5), fontWeight: FontWeight.w500, fontFamily: 'Pangram'),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.purple[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.w(2)),
                                  side: BorderSide(
                                    color: Colors.purple[300]!,
                                    width: 0.8,
                                  ),
                                ),
                                deleteIcon: Icon(Icons.close, size: context.w(4), color: Colors.black),
                                onDeleted: () {
                                  moodProvider.toggleEmotion(emotionTitle);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // Recently Used Section
                      if (showRecentlyUsed && moodProvider.recentlyUsedEmotions.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recently Used:",
                            style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                          ),
                        ),
                        SizedBox(height: context.h(1.5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: context.w(3),
                            runSpacing: context.h(0.5),
                            children: moodProvider.recentlyUsedEmotions.map((emotionTitle) {
                              final emojiItem = allEmotions.firstWhere((item) => item.title == emotionTitle);
                              return GestureDetector(
                                onTap: () {
                                  moodProvider.toggleEmotion(emotionTitle);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: context.w(10),
                                  child: Image.asset(
                                    emojiItem.imagePath,
                                    width: context.w(8.75),
                                    height: context.w(8.75),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // Display All Emotions Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "All Emotions:",
                          style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                        ),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: context.w(5),
                          runSpacing: context.h(1),
                          children: filteredEmotions.map((emotion) {
                            return GestureDetector(
                              onTap: () {
                                moodProvider.toggleEmotion(emotion.title);
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: moodProvider.selectedEmotions.contains(emotion.title)
                                        ? Colors.purple[100]
                                        : Colors.grey[300],
                                    radius: context.w(10),
                                    child: Image.asset(
                                      emotion.imagePath,
                                      width: context.w(8.75),
                                      height: context.w(8.75),
                                    ),
                                  ),
                                  Text(
                                    emotion.title,
                                    style: TextStyle(fontSize: context.w(3), fontFamily: 'Pangram'),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                    ],
                  ),
                ),
              ),
              // Standardized Bottom Button
              Padding(
                padding: EdgeInsets.fromLTRB(context.w(5), 0, context.w(5), context.h(3)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.w(10)),
                    ),
                    minimumSize: Size(context.w(85), context.h(7.5)),
                  ),
                  onPressed: () {
                    if (moodProvider.selectedEmotions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one emotion before continuing.'),
                          backgroundColor: Color(0xFF8B4CFC),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddReasons(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: context.w(4), color: Colors.white, fontFamily: 'Pangram', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
