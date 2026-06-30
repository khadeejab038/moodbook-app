import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userID;
  String email;
  String name;
  DateTime createdAt;
  String? avatar; // Optional
  List<CheckInReminder>? checkInReminders; // Optional list of check-in reminders

  // Default unnamed constructor
  User({
    required this.userID,
    required this.email,
    required this.name,
    required this.createdAt,
    this.avatar,
    this.checkInReminders,
  });

  // Convert Firestore document to UserModel
  factory User.fromFirestore(Map<String, dynamic> doc) {
    final rawCreatedAt = doc['createdAt'];
    DateTime parsedCreatedAt;
    if (rawCreatedAt is Timestamp) {
      parsedCreatedAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      parsedCreatedAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else {
      parsedCreatedAt = DateTime.now();
    }

    final rawReminders = doc['checkInReminders'];
    List<CheckInReminder>? parsedReminders;
    if (rawReminders is List) {
      parsedReminders = rawReminders
          .map((item) {
            if (item is Map) {
              return CheckInReminder.fromMap(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<CheckInReminder>()
          .toList();
    }

    return User(
      userID: doc['userID'] as String? ?? '',
      email: doc['email'] as String? ?? '',
      name: doc['name'] as String? ?? '',
      createdAt: parsedCreatedAt,
      avatar: doc['avatar'] as String?,
      checkInReminders: parsedReminders,
    );
  }

  // Convert UserModel to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'avatar': avatar,
      'checkInReminders': checkInReminders?.map((e) => e.toMap()).toList() ?? [],
    };
  }
}


class CheckInReminder {
  DateTime timestamp;
  bool isEnabled;

  CheckInReminder({
    required this.timestamp,
    required this.isEnabled,
  });

  // Convert CheckInReminder map to CheckInReminder object
  factory CheckInReminder.fromMap(Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    return CheckInReminder(
      timestamp: parsedTimestamp,
      isEnabled: map['isEnabled'] as bool? ?? false,
    );
  }

  // Convert CheckInReminder object to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'isEnabled': isEnabled,
    };
  }
}

