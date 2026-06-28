import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/emoji_data.dart';
import '../widgets/date_time_picker.dart';
import '../home/home_screen.dart';
import 'add_mood_screen2_emotions.dart';
import '../widgets/responsive_extension.dart';

class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  DateTime? selectedDateTime;
  int selectedEmojiIndex = 2; // Default to the middle emoji (Neutral)

  @override
  void initState() {
    super.initState();
    // Set default date and time to now
    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final moodEntryProvider = Provider.of<MoodEntryController>(context);

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
                    Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "1/4",
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
                        moodEntryProvider.clear(); // Clear state if user closes
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
                      // Date & Time picker button brought down below the top bar
                      ElevatedButton(
                        onPressed: () => selectDateAndTime(
                          context,
                          selectedDateTime ?? DateTime.now(), // Pass current selectedDateTime or default now
                              (DateTime newDateTime) { // Callback to update the selected date and time
                            setState(() {
                              selectedDateTime = newDateTime;
                            });
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.w(7)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: context.h(1.8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedDateTime != null
                                  ? "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}, ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}"
                                  : "Select Date & Time",
                              style: TextStyle(fontFamily: 'Pangram', fontSize: context.w(3.75)),
                            ),
                            SizedBox(width: context.w(2.5)),
                            const Icon(Icons.calendar_month_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: context.h(3)),
                      // Centered & Harmonious texts
                      Text(
                        "What's your mood right now?",
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
                        "Select mood that reflects the most how you are feeling at this moment.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(3.75),
                          fontFamily: 'Pangram',
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                      // Horizontal Mood List
                      Container(
                        height: context.h(15),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moods.length, // Using the 'moods' list from emoji_data.dart
                          itemBuilder: (context, index) {
                            final isSelected = selectedEmojiIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEmojiIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: context.w(2)),
                                width: isSelected ? context.w(20) : context.w(15),
                                height: isSelected ? context.w(20) : context.w(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                      : [],
                                ),
                                child: Image.asset(
                                  moods[index].imagePath, // Displaying the image based on selected mood
                                  width: isSelected ? context.w(10) : context.w(7.5), // Adjust image size based on selection
                                  height: isSelected ? context.w(10) : context.w(7.5),
                                ),
                              ),
                            );
                          },
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
                    // Save the selected mood and timestamp
                    moodEntryProvider.setMood(moods[selectedEmojiIndex].title); // Using title of selected mood
                    moodEntryProvider.setTimestamp(selectedDateTime!); // Save timestamp
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEmotions(),
                      ),
                    );
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontSize: context.w(4),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
