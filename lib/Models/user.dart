import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userID;
  String email;
  String name;
  DateTime createdAt;
  String avatar;
  List<CheckInReminder>? checkInReminders; // Optional list of check-in reminders

  // Default unnamed constructor
  User({
    required this.userID,
    required this.email,
    required this.name,
    required this.createdAt,
    this.avatar = "grey",
    this.checkInReminders,
  });

  // Convert Firestore document to UserModel
  factory User.fromFirestore(Map<String, dynamic> doc) {
    return User(
      userID: doc['userID'] ?? '',
      email: doc['email'] ?? '',
      name: doc['name'] ?? '',
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      avatar: doc['avatar'],
      checkInReminders: (doc['checkInReminders'] as List?)?.map((item) => CheckInReminder.fromMap(item)).toList(),
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
    return CheckInReminder(
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isEnabled: map['isEnabled'] ?? false,
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

