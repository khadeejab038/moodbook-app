import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/moodEntry_provider.dart';
import '../Utils/emoji_data.dart';
import 'home_screen.dart';
import 'addMood_page2.dart';

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

  Future<void> _selectDateAndTime(BuildContext context) async {
    // Select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Restrict to current or past dates
    );

    if (pickedDate != null) {
      // Select time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        // Combine the selected date and time
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (combinedDateTime.isAfter(DateTime.now())) {
          // Show an error if the selected time is in the future
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Future dates and times are not allowed."),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          setState(() {
            selectedDateTime = combinedDateTime; // Update the selected timestamp
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodEntryProvider = Provider.of<MoodEntryProvider>(context);

    return Container(
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
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 35),
          Row(
            children: [
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _selectDateAndTime(context), // Open date and time picker
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedDateTime != null
                          ? "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}, ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}"
                          : "Select Date & Time",
                      style: const TextStyle(fontFamily: 'Pangram'),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              const Text("1/4", style: TextStyle(fontFamily: 'Pangram')),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  moodEntryProvider.clear(); // Clear state if user closes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                  );
                },
                child: const Icon(Icons.close, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(6.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "What's your mood right now?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
          ),
          const SizedBox(height: 30),
          const SizedBox(
            width: 280,
            child: Text(
              "Select mood that reflects the most how you are feeling at this moment.",
              style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 120,
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
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: isSelected ? 80 : 60,
                    height: isSelected ? 80 : 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ]
                          : [],
                    ),
                    child: Image.asset(
                      moods[index].imagePath,  // Displaying the image based on selected mood
                      width: isSelected ? 40 : 30, // Adjust image size based on selection
                      height: isSelected ? 40 : 30,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 200),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4CFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              minimumSize: const Size(350, 20),
            ),
            onPressed: () {
              // Save the selected mood and timestamp
              moodEntryProvider.setMood(moods[selectedEmojiIndex].title);  // Using title of selected mood
              moodEntryProvider.setTimestamp(selectedDateTime!); // Save timestamp
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmotions(),
                ),
              );
            },
            child: const Text("Continue", style: TextStyle(color: Colors.white, fontFamily: 'Pangram')),
          ),
        ],
      ),
    );
  }
}
