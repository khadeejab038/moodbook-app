import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/user.dart';
import '../../../Providers/checkin_provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  Future<void> _addCheckInReminder(BuildContext context) async {
    final provider = Provider.of<CheckInProvider>(context, listen: false);
    final now = DateTime.now();
    final newReminder = CheckInReminder(
      timestamp: now,
      isEnabled: true,
    );

    await provider.addCheckInReminder(newReminder);
  }

  Future<void> _deleteCheckInReminder(BuildContext context, int index) async {
    final provider = Provider.of<CheckInProvider>(context, listen: false);
    await provider.deleteCheckInReminder(index);
  }

  Future<void> _toggleCheckInReminder(
      BuildContext context, int index, bool value) async {
    final provider = Provider.of<CheckInProvider>(context, listen: false);
    await provider.updateCheckInReminder(index, isEnabled: value);
  }

  Future<void> _pickTime(BuildContext context, int index) async {
    final provider = Provider.of<CheckInProvider>(context, listen: false);
    final currentReminder = provider.checkInReminders[index];

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentReminder.timestamp),
    );

    if (selectedTime != null) {
      final updatedTimestamp = DateTime(
        currentReminder.timestamp.year,
        currentReminder.timestamp.month,
        currentReminder.timestamp.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      await provider.updateCheckInReminder(index, timestamp: updatedTimestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: TextStyle(
            fontFamily: 'Pangram',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF100F11)),
      ),
      body: Consumer<CheckInProvider>(
        builder: (context, provider, child) {
          final checkInReminders = provider.checkInReminders;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xAAC7DFFF), // #BACFFF with 67% opacity
                  Color(0xFFFFCEB7), // #FFCEB7 with 100% opacity
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Manage your mood check-in reminders.',
                  style: TextStyle(
                    fontFamily: 'Pangram',
                    fontSize: 16,
                    color: Color(0xFF100F11),
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: checkInReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = checkInReminders[index];

                    return Card(
                      child: ListTile(
                        title: Text(
                          'Reminder at ${TimeOfDay.fromDateTime(reminder.timestamp).format(context)}',
                          style: TextStyle(fontFamily: 'Pangram'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: reminder.isEnabled,
                              onChanged: (value) =>
                                  _toggleCheckInReminder(context, index, value),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteCheckInReminder(context, index),
                            ),
                          ],
                        ),
                        onTap: () => _pickTime(context, index),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Reminder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4CFC),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => _addCheckInReminder(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
