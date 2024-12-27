import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/mood_entry.dart';

class DatabaseServices {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // Add a mood entry to Firestore
  static Future<void> addMoodEntry(MoodEntry moodEntry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      moodEntry.setUserId = user.uid; // Set user ID
    } else {
      throw Exception('No user logged in');
    }

    try {
      await _db.collection('mood_entries').add(moodEntry.toMap());
      print('Mood entry added successfully.');
    } catch (e) {
      throw Exception('Failed to add mood entry: $e');
    }
  }

  // Update an existing mood entry in Firestore
  static Future<void> updateMoodEntry(String id, MoodEntry moodEntry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      moodEntry.setUserId = user.uid; // Set user ID
    } else {
      throw Exception('No user logged in');
    }

    try {
      await _db.collection('mood_entries').doc(id).update(moodEntry.toMap());
      print('Mood entry updated successfully.');
    } catch (e) {
      throw Exception('Failed to update mood entry: $e');
    }
  }

  // Delete a mood entry by ID
  static Future<void> deleteMoodEntry(String id) async {
    try {
      await _db.collection('mood_entries').doc(id).delete();
      print('Mood entry deleted successfully.');
    } catch (e) {
      throw Exception('Failed to delete mood entry: $e');
    }
  }

  // Fetch all mood entries for the current user
  static Future<List<MoodEntry>> fetchMoodEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final QuerySnapshot snapshot = await _db
            .collection('mood_entries')
            .where('userId', isEqualTo: user.uid) // Filter by user ID
            .get();
        return snapshot.docs
            .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to fetch mood entries: $e');
      }
    } else {
      throw Exception('No user logged in');
    }
  }
}

