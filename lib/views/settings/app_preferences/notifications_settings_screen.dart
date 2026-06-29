import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../controllers/check_in_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../services/notification_service.dart';
import '../../widgets/snack_bar_helper.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> with WidgetsBindingObserver {
  bool _exactAlarmsAllowed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load check-in reminders when the page is opened
    final provider = Provider.of<CheckInController>(context, listen: false);
    provider.loadCheckInReminders();
    
    // Request permission on page entry
    NotificationService().requestPermissions().then((_) {
      _checkExactAlarmsStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkExactAlarmsStatus();
    }
  }

  Future<void> _checkExactAlarmsStatus() async {
    final allowed = await NotificationService().canScheduleExactAlarms();
    if (mounted) {
      setState(() {
        _exactAlarmsAllowed = allowed;
      });
    }
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
              if (!_exactAlarmsAllowed) ...[
                Card(
                  color: AppColors.error.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.error, width: 1),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                    title: Text(
                      'Exact Alarms Disabled',
                      style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.error),
                    ),
                    subtitle: Text(
                      'Tap here to allow "Alarms & reminders" in settings so reminders trigger at the exact minute.',
                      style: AppTextStyles.caption.copyWith(color: isDark ? Colors.white70 : Colors.black87),
                    ),
                    onTap: () async {
                      await NotificationService().requestExactAlarmsPermission();
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
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
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.notifications_active, color: AppColors.primary),
                label: Text('Send Test Notification', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final enabled = await NotificationService().areNotificationsEnabled();
                  if (!enabled) {
                    showSnackBar(context, 'Notification permission is blocked. Please enable it in system settings.');
                    await NotificationService().requestPermissions();
                  } else {
                    final debugTimes = NotificationService().getDebugTimes();
                    await NotificationService().showTestNotification();
                    await Future.delayed(const Duration(milliseconds: 500));
                    final pendingStr = await NotificationService().getPendingNotificationsDebugString();
                    showSnackBar(context, 'Test notification sent!\n$debugTimes\n$pendingStr');
                  }
                },
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
