import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/database/user_database.dart';
import '../models/user.dart';
import '../services/notification_service.dart';

class CheckInController extends ChangeNotifier {
  List<CheckInReminder> _checkInReminders = [];

  List<CheckInReminder> get checkInReminders => _checkInReminders;

  String? get userID => FirebaseAuth.instance.currentUser?.uid;

  CheckInController();

  /// Load check-in reminders from Firestore
  Future<void> loadCheckInReminders() async {
    final uid = userID;
    if (uid == null) {
      print('CheckInController: User not logged in, cannot load reminders.');
      return;
    }
    try {
      _checkInReminders = await UserDatabase.fetchCheckInReminders(uid);
      // Sort the reminders in ascending order by timestamp
      _checkInReminders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners();
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    } catch (e) {
      print('Failed to load check-in reminders: $e');
    }
  }

  /// Add a new check-in reminder
  Future<void> addCheckInReminder(CheckInReminder reminder) async {
    final uid = userID;
    if (uid == null) {
      print('Cannot add check-in reminder: user is null');
      return;
    }
    try {
      _checkInReminders.add(reminder);
      // Re-sort reminders after updating the time
      _checkInReminders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners(); // Update UI immediately
      await UserDatabase.addCheckInReminder(uid, reminder);
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    } catch (e) {
      print('Failed to add check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders.remove(reminder);
      notifyListeners();
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    }
  }

  /// Delete a check-in reminder by index
  Future<void> deleteCheckInReminder(int index) async {
    if (index < 0 || index >= _checkInReminders.length) return;

    final uid = userID;
    if (uid == null) {
      print('Cannot delete check-in reminder: user is null');
      return;
    }

    final removedReminder = _checkInReminders[index];
    _checkInReminders.removeAt(index);
    notifyListeners(); // Update UI immediately

    try {
      await UserDatabase.deleteCheckInReminder(uid, index);
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    } catch (e) {
      print('Failed to delete check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders.insert(index, removedReminder);
      notifyListeners();
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    }
  }

  /// Update a specific check-in reminder
  Future<void> updateCheckInReminder(int index, {DateTime? timestamp, bool? isEnabled}) async {
    if (index < 0 || index >= _checkInReminders.length) return;

    final uid = userID;
    if (uid == null) {
      print('Cannot update check-in reminder: user is null');
      return;
    }

    final originalReminder = _checkInReminders[index];
    final updatedReminder = CheckInReminder(
      timestamp: timestamp ?? originalReminder.timestamp,
      isEnabled: isEnabled ?? originalReminder.isEnabled,
    );

    _checkInReminders[index] = updatedReminder;
    // Re-sort reminders after updating the time
    _checkInReminders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    notifyListeners(); // Update UI immediately

    try {
      await UserDatabase.updateCheckInReminder(
        uid,
        index,
        timestamp: timestamp,
        isEnabled: isEnabled,
      );
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    } catch (e) {
      print('Failed to update check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders[index] = originalReminder;
      notifyListeners();
      
      // Sync local scheduled notifications
      await NotificationService().rescheduleAllLocalNotifications(_checkInReminders);
    }
  }

  /// Get the total number of check-in reminders
  int getTotalCheckInReminders() {
    return _checkInReminders.length;
  }

  /// Get the number of enabled check-in reminders
  int getEnabledCheckInRemindersCount() {
    return _checkInReminders.where((reminder) => reminder.isEnabled).length;
  }
}
