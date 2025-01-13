import 'package:flutter/material.dart';
import '../Services/database_services_users.dart';
import '../Models/user.dart';

class CheckInProvider extends ChangeNotifier {
  final String userID; // The ID of the logged-in user
  List<CheckInReminder> _checkInReminders = [];

  List<CheckInReminder> get checkInReminders => _checkInReminders;

  CheckInProvider({required this.userID});

  /// Load check-in reminders from Firestore
  Future<void> loadCheckInReminders() async {
    try {
      _checkInReminders = await DatabaseServicesUsers.fetchCheckInReminders(userID);
      // Sort the reminders in ascending order by timestamp
      _checkInReminders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners();
    } catch (e) {
      print('Failed to load check-in reminders: $e');
    }
  }

  /// Add a new check-in reminder
  Future<void> addCheckInReminder(CheckInReminder reminder) async {
    try {
      _checkInReminders.add(reminder);
      // Re-sort reminders after updating the time
      _checkInReminders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners(); // Update UI immediately
      await DatabaseServicesUsers.addCheckInReminder(userID, reminder);
    } catch (e) {
      print('Failed to add check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders.remove(reminder);
      notifyListeners();
    }
  }

  /// Delete a check-in reminder by index
  Future<void> deleteCheckInReminder(int index) async {
    if (index < 0 || index >= _checkInReminders.length) return;

    final removedReminder = _checkInReminders[index];
    _checkInReminders.removeAt(index);
    notifyListeners(); // Update UI immediately

    try {
      await DatabaseServicesUsers.deleteCheckInReminder(userID, index);
    } catch (e) {
      print('Failed to delete check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders.insert(index, removedReminder);
      notifyListeners();
    }
  }

  /// Update a specific check-in reminder
  Future<void> updateCheckInReminder(int index, {DateTime? timestamp, bool? isEnabled}) async {
    if (index < 0 || index >= _checkInReminders.length) return;

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
      await DatabaseServicesUsers.updateCheckInReminder(
        userID,
        index,
        timestamp: timestamp,
        isEnabled: isEnabled,
      );
    } catch (e) {
      print('Failed to update check-in reminder: $e');
      // Rollback the change in case of error
      _checkInReminders[index] = originalReminder;
      notifyListeners();
    }
  }

  /// Get the total number of check-in reminders
  int getTotalCheckInRemindersCount() {
    return _checkInReminders.length;
  }

  /// Get the number of enabled check-in reminders
  int getEnabledCheckInRemindersCount() {
    return _checkInReminders.where((reminder) => reminder.isEnabled).length;
  }

}
