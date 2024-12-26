import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/moodEntry_provider.dart';
import 'home_screen.dart';

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

  // Show popup dialog after saving
  void showPopupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                  child: Image.asset('lib/assets/goodtogo.png'),
                ),
                const Text(
                  "You're on a good way!\nYour day is going \namazing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Keep tracking your mood to know how to improve your mental health.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to save the mood entry to Firebase
  Future<void> saveMoodEntryToFirebase() async {
    final moodProvider = Provider.of<MoodEntryProvider>(context, listen: false);
    final moodEntry = moodProvider.moodEntry;

    // Add the user ID to the mood entry
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      moodEntry.setUserId = user.uid;
    } else {
      print('Error: No user logged in');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('mood_entries').add(moodEntry.toMap());
      moodProvider.clear();
      showPopupDialog();
    } catch (e) {
      print('Error saving mood entry: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving mood entry')),
      );
    }
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  "Any thing you want to add",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "Add your notes on any thought that relates to your mood",
                  style: TextStyle(fontSize: 14, color: Colors.black),
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
                      )
                    ],
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: "Write your notes here",
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
                    onPressed: saveMoodEntryToFirebase,
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

