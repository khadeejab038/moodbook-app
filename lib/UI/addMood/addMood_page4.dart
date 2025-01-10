import '../../../Services/database_services_mood_entries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/moodEntry_provider.dart';
import '../home/home_screen.dart';
import 'addMood_page5_popup.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final moodProvider = Provider.of<MoodEntryProvider>(context, listen: false);

    // Pre-fill the TextField with the saved note if it exists
    notesController.text = moodProvider.moodEntry.getNotes ?? '';
  }

  // Show popup dialog with mood-specific message
  void showPopupDialog(String mood) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddMoodPopup(mood: mood),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      final moodProvider = Provider.of<MoodEntryProvider>(context, listen: false);

                      // Save the note in the provider
                      moodProvider.moodEntry.setNotes = notesController.text;

                      // Navigate back
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "4/4",
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      final moodProvider = Provider.of<MoodEntryProvider>(context, listen: false);
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
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Anything you want to add",
                  style: TextStyle(
                    fontFamily: 'Pangram',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "Add your notes on any thought that relates to your mood",
                  style: TextStyle(
                    fontFamily: 'Pangram',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: "Write your notes here",
                      hintStyle: const TextStyle(fontFamily: 'Pangram'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4CFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () async {
                      final moodProvider = Provider.of<MoodEntryProvider>(context, listen: false);
                      final moodEntry = moodProvider.moodEntry;

                      // Update notes in the MoodEntry object
                      moodEntry.setNotes = notesController.text;

                      try {
                        // Call the static method from DatabaseServices to save the entry
                        await DatabaseServices.saveMoodEntryToFirebase(moodEntry);

                        moodProvider.clear(); // Clear the provider state
                        showPopupDialog(moodEntry.getMood);    // Show success popup with mood-specific message
                      } catch (e) {
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error saving mood entry')),
                        );
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Pangram',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
