import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Models/mood_entry.dart';

class MoodEntryProvider extends ChangeNotifier {
  MoodEntry _moodEntry = MoodEntry(
    timestamp: DateTime.now(),
    mood: '',
    emotions: [],
    reasons: [],
    notes: null,
  );

  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('mood_entries');

  // Getter for mood entry
  MoodEntry get moodEntry => _moodEntry;

  // Get the list of selected emotions
  List<String> get selectedEmotions => _moodEntry.getEmotions;

  // Get the list of selected reasons
  List<String> get selectedReasons => _moodEntry.getReasons;

  // Setters to update data
  void setTimestamp(DateTime timestamp) {
    _moodEntry.setTimestamp = timestamp;
    notifyListeners();
  }

  void setMood(String mood) {
    _moodEntry.setMood = mood;
    notifyListeners();
  }

  void setEmotions(List<String> emotions) {
    _moodEntry.setEmotions = emotions;
    notifyListeners();
  }

  void setReasons(List<String> reasons) {
    _moodEntry.setReasons = reasons;
    notifyListeners();
  }

  void setNotes(String? notes) {
    _moodEntry.setNotes = notes;
    notifyListeners();
  }

  // Toggle emotion selection (add or remove from selected emotions)
  void toggleEmotion(String emotion) {
    if (_moodEntry.getEmotions.contains(emotion)) {
      _moodEntry.removeEmotion(emotion);
    } else {
      _moodEntry.addEmotion(emotion);
    }
    notifyListeners();
  }

  // Toggle reason selection (add or remove from selected reasons)
  void toggleReason(String reason) {
    if (_moodEntry.getReasons.contains(reason)) {
      _moodEntry.removeReason(reason);
    } else {
      _moodEntry.addReason(reason);
    }
    notifyListeners();
  }

  // Clear all selected reasons
  void clearSelectedReasons() {
    _moodEntry.setReasons = [];
    notifyListeners();
  }

  // Clear all fields
  void clear() {
    _moodEntry = MoodEntry(
      timestamp: DateTime.now(),
      mood: '',
      emotions: [],
      reasons: [],
      notes: null,
    );
    notifyListeners();
  }

}
