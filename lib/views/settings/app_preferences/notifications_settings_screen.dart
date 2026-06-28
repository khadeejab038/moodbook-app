import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../controllers/check_in_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load check-in reminders when the page is opened
    final provider = Provider.of<CheckInController>(context, listen: false);
    provider.loadCheckInReminders();
  }

  Future<void> _addCheckInReminder(BuildContext context) async {
    final provider = Provider.of<CheckInController>(context, listen: false);
    final now = DateTime.now();
    final newReminder = CheckInReminder(
      timestamp: now,
      isEnabled: true,
    );

    await provider.addCheckInReminder(newReminder);
  }

  Future<void> _deleteCheckInReminder(BuildContext context, int index) async {
    final provider = Provider.of<CheckInController>(context, listen: false);
    await provider.deleteCheckInReminder(index);
  }

  Future<void> _toggleCheckInReminder(
      BuildContext context, int index, bool value) async {
    final provider = Provider.of<CheckInController>(context, listen: false);
    await provider.updateCheckInReminder(index, isEnabled: value);
  }

  Future<void> _pickTime(BuildContext context, int index) async {
    final provider = Provider.of<CheckInController>(context, listen: false);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: AppTextStyles.pageTitle.copyWith(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.pageGradientDark : AppColors.pageGradientLight,
        ),
        child: SafeArea(
          child: Consumer<CheckInController>(
            builder: (context, provider, child) {
          final checkInReminders = provider.checkInReminders;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Manage your mood check-in reminders.',
                style: AppTextStyles.body.copyWith(
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkInReminders.length,
                itemBuilder: (context, index) {
                  final reminder = checkInReminders[index];

                  return Card(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                    ),
                    child: ListTile(
                      title: Text(
                        'Reminder at ${TimeOfDay.fromDateTime(reminder.timestamp).format(context)}',
                        style: AppTextStyles.bodySemiBold.copyWith(color: textColor),
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
                            icon: const Icon(Icons.delete, color: AppColors.error),
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text('Add Reminder', style: AppTextStyles.button.copyWith(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _addCheckInReminder(context),
              ),
            ],
          );
        },
      ),
     ),
    ),
   );
  }
}
