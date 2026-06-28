import '../../models/database/mood_entry_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../home/home_screen.dart';
import 'add_mood_screen5_popup.dart';
import '../widgets/responsive_extension.dart';

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

    final moodProvider = Provider.of<MoodEntryController>(context, listen: false);

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
                      onPressed: () {
                        final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
                        moodProvider.moodEntry.setNotes = notesController.text;
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "4/4",
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
                        final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
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
                        "Anything you want to add",
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
                        "Add your notes on any thought that relates to your mood",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(3.75),
                          fontFamily: 'Pangram',
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: context.h(3)),
                      // Notes Input Area
                      Container(
                        height: context.h(37.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.w(5)),
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
                              borderRadius: BorderRadius.circular(context.w(2.5)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                    ],
                  ),
                ),
              ),
              // Standardized Bottom Button (Save)
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
                  onPressed: () async {
                    final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
                    final moodEntry = moodProvider.moodEntry;
                    moodEntry.setNotes = notesController.text;

                    try {
                      await MoodEntryDatabase.saveMoodEntryToFirebase(moodEntry);
                      moodProvider.clear();
                      showPopupDialog(moodEntry.getMood);
                    } catch (e) {
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error saving mood entry'), backgroundColor: Color(0xFF8B4CFC)),
                      );
                    }
                  },
                  child: Text(
                    'Save',
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
