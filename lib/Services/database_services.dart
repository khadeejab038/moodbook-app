import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/MoodEntry.dart';

class DatabaseServices {
  static Future<void> saveMoodEntryToFirebase(MoodEntry moodEntry) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      moodEntry.setUserId = user.uid; // Set the user ID
    } else {
      throw Exception('No user is logged in');
    }

    try {
      await FirebaseFirestore.instance.collection('mood_entries').add(moodEntry.toMap());
    } catch (e) {
      throw Exception('Error saving mood entry: $e');
    }
  }
}

