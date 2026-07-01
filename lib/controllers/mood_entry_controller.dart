import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/mood_entry.dart';
import '../models/database/mood_entry_database.dart';

class MoodEntryController extends ChangeNotifier {
  MoodEntry _moodEntry = MoodEntry(
    timestamp: DateTime.now(),
    mood: '',
    emotions: [],
    reasons: [],
    notes: '',
  );

  List<String> _recentlyUsedEmotions = [];
  List<String> _recentlyUsedReasons = [];

  // Tracks the last time a mood entry was successfully saved;
  // stats widgets listen to this to know when to re-fetch.
  DateTime? _lastSavedAt;
  DateTime? get lastSavedAt => _lastSavedAt;

  MoodEntryController();

  // Getter for mood entry
  MoodEntry get moodEntry => _moodEntry;

  // Get the list of selected emotions
  List<String> get selectedEmotions => _moodEntry.getEmotions;

  // Get the list of selected reasons
  List<String> get selectedReasons => _moodEntry.getReasons;

  // Get the list of recently used reasons
  List<String> get recentlyUsedReasons => _recentlyUsedReasons;

  // Get the list of recently used emotions
  List<String> get recentlyUsedEmotions => _recentlyUsedEmotions;

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
    _moodEntry.setNotes = notes ?? '';
    notifyListeners();
  }

  // Toggle emotion selection (add or remove from selected emotions)
  void toggleEmotion(String emotion) {
    if (_moodEntry.getEmotions.contains(emotion)) {
      _moodEntry.removeEmotion(emotion);
    } else {
      _moodEntry.addEmotion(emotion);
      _updateRecentlyUsedEmotions(emotion); // Update recently used emotions when added
    }
    notifyListeners();
  }

  // Toggle reason selection (add or remove from selected reasons)
  void toggleReason(String reason) {
    if (_moodEntry.getReasons.contains(reason)) {
      _moodEntry.removeReason(reason);
    } else {
      _moodEntry.addReason(reason);
      _updateRecentlyUsedReasons(reason);

    }
    notifyListeners();
  }

  // Method to update recently used emotions
  void _updateRecentlyUsedEmotions(String emotion) {
    // Add the emotion to the beginning of the list
    if (!_recentlyUsedEmotions.contains(emotion)) {
      _recentlyUsedEmotions.insert(0, emotion);
    }

    // Keep only the last 8 emotions
    if (_recentlyUsedEmotions.length > 8) {
      _recentlyUsedEmotions.removeLast();
    }
  }

  // Add a reason to the recently used list, keeping the list limited to the most recent 8
  void _updateRecentlyUsedReasons(String reason) {
    if (_recentlyUsedReasons.contains(reason)) {
      _recentlyUsedReasons.remove(reason);
    }
    _recentlyUsedReasons.insert(0, reason); // Add to the front of the list

    // Ensure the list only contains the last 8 items
    if (_recentlyUsedReasons.length > 8) {
      _recentlyUsedReasons.removeLast();
    }
    notifyListeners();
  }

  // Clear all selected reasons
  void clearSelectedReasons() {
    _moodEntry.setReasons = [];
    notifyListeners();
  }

  // Clear all selected emotions
  void clearSelectedEmotions() {
    _moodEntry.setEmotions = [];
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

  /// Call this immediately after a mood entry is successfully saved to Firestore.
  /// Stats widgets (MoodPieChart, EmotionTriggersInsight) listen to this
  /// signal and will automatically re-fetch their data.
  void notifyEntrySaved() {
    _lastSavedAt = DateTime.now();
    notifyListeners();
  }

  // Clear recently used emotions and reasons lists
  void clearRecentlyUsed() {
    _recentlyUsedEmotions = [];
    _recentlyUsedReasons = [];
    notifyListeners();
  }

  // Count the number of mood entries created today
  Future<int> countMoodEntriesToday() async {
    try {
      // Fetch all mood entries for the current user
      List<MoodEntry> allEntries = await MoodEntryDatabase.fetchMoodEntries();

      // Get today's date range
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Filter entries that were created today
      final todayEntries = allEntries.where((entry) {
        final entryDate = entry.getTimestamp;
        return entryDate.isAfter(startOfDay) && entryDate.isBefore(endOfDay);
      }).toList();

      // Return the count of today's entries
      return todayEntries.length;
    } catch (e) {
      print('Error counting mood entries for today: $e');
      return 0; // Return zero in case of an error
    }
  }
}

