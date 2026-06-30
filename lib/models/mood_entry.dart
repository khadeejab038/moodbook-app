import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  DateTime _timestamp;
  String _mood = '';
  List<String> _emotions = [];
  List<String> _reasons = [];
  String? _notes;
  String? _userId;

  // Constructor
  MoodEntry({
    required DateTime timestamp,
    required String mood,
    List<String>? emotions,
    List<String>? reasons,
    String? notes,
    String? userId,
  })
      : _timestamp = timestamp,
        _mood = mood,
        _emotions = emotions ?? [],
        _reasons = reasons ?? [],
        _notes = notes,
        _userId = userId;

  // Getters
  DateTime get getTimestamp => _timestamp;

  String get getMood => _mood;

  List<String> get getEmotions => _emotions;

  List<String> get getReasons => _reasons;

  String? get getNotes => _notes;

  String? get getUserId => _userId;

  // Setters
  set setTimestamp(DateTime timestamp) => _timestamp = timestamp;

  set setMood(String mood) => _mood = mood;

  set setEmotions(List<String> emotions) => _emotions = emotions;

  set setReasons(List<String> reasons) => _reasons = reasons;

  set setNotes(String? notes) => _notes = notes;

  set setUserId(String? userId) => _userId = userId;

  // Methods for adding/removing emotions
  void addEmotion(String emotion) {
    _emotions.add(emotion);
  }

  void removeEmotion(String emotion) {
    _emotions.remove(emotion);
  }

  // Methods for adding/removing reasons
  void addReason(String reason) {
    _reasons.add(reason);
  }

  void removeReason(String reason) {
    _reasons.remove(reason);
  }

  // Convert to Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'timestamp': Timestamp.fromDate(_timestamp),
      // Convert DateTime to Firestore Timestamp
      'mood': _mood,
      'emotions': _emotions,
      'reasons': _reasons,
      'notes': _notes ?? '',
      'userId': _userId,
    };
  }

  // Create from Firestore Map
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    final rawEmotions = map['emotions'];
    List<String> parsedEmotions = [];
    if (rawEmotions is List) {
      parsedEmotions = rawEmotions.map((e) => e.toString()).toList();
    }

    final rawReasons = map['reasons'];
    List<String> parsedReasons = [];
    if (rawReasons is List) {
      parsedReasons = rawReasons.map((e) => e.toString()).toList();
    }

    return MoodEntry(
      timestamp: parsedTimestamp,
      mood: map['mood'] as String? ?? '',
      emotions: parsedEmotions,
      reasons: parsedReasons,
      notes: map['notes'] as String? ?? '',
      userId: map['userId'] as String?,
    );
  }
}
