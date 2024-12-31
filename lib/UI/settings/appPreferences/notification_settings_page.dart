import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  List<CheckInReminder> checkInReminders = [
    CheckInReminder(time: TimeOfDay(hour: 9, minute: 0), isEnabled: true),
    CheckInReminder(time: TimeOfDay(hour: 18, minute: 0), isEnabled: true),
  ];

  void _addCheckInReminder() {
    setState(() {
      checkInReminders.add(CheckInReminder(
        time: TimeOfDay.now(),
        isEnabled: true,
      ));
    });
  }

  void _deleteCheckInReminder(int index) {
    setState(() {
      checkInReminders.removeAt(index);
    });
  }

  void _toggleCheckInReminder(int index, bool value) {
    setState(() {
      checkInReminders[index].isEnabled = value;
    });
  }

  Future<void> _pickTime(int index) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: checkInReminders[index].time,
    );
    if (selectedTime != null) {
      setState(() {
        checkInReminders[index].time = selectedTime;
      });
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
      body: Container(
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
                      'Reminder at ${reminder.time.format(context)}',
                      style: TextStyle(fontFamily: 'Pangram'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: reminder.isEnabled,
                          onChanged: (value) =>
                              _toggleCheckInReminder(index, value),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCheckInReminder(index),
                        ),
                      ],
                    ),
                    onTap: () => _pickTime(index),
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
              onPressed: _addCheckInReminder,
            ),
          ],
        ),
      ),
    );
  }
}

class CheckInReminder {
  TimeOfDay time;
  bool isEnabled;

  CheckInReminder({
    required this.time,
    this.isEnabled = true,
  });
}
