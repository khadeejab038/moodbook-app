class MoodEntry {
  DateTime _timestamp; // Combines date and time into a single field
  String _mood = '';
  List<String> _emotions = [];
  List<String> _reasons = [];
  String? _notes;

  // Constructor
  MoodEntry({
    required DateTime timestamp,
    required String mood,
    List<String>? emotions,
    List<String>? reasons,
    String? notes,
  })  : _timestamp = timestamp,
        _mood = mood,
        _emotions = emotions ?? [],
        _reasons = reasons ?? [],
        _notes = notes;

  // Getters
  DateTime get getTimestamp => _timestamp;
  String get getMood => _mood;
  List<String> get getEmotions => _emotions;
  List<String> get getReasons => _reasons;
  String? get getNotes => _notes;

  // Setters
  set setTimestamp(DateTime timestamp) => _timestamp = timestamp;
  set setMood(String mood) => _mood = mood;
  set setEmotions(List<String> emotions) => _emotions = emotions;
  set setReasons(List<String> reasons) => _reasons = reasons;
  set setNotes(String? notes) => _notes = notes;

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
      'timestamp': _timestamp.toIso8601String(), // Ensure compatibility
      'mood': _mood,
      'emotions': _emotions,
      'reasons': _reasons,
      'notes': _notes,
    };
  }

  // Create from Firestore Map
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      timestamp: DateTime.parse(map['timestamp']),
      mood: map['mood'] ?? '',
      emotions: List<String>.from(map['emotions'] ?? []),
      reasons: List<String>.from(map['reasons'] ?? []),
      notes: map['notes'],
    );
  }
}
