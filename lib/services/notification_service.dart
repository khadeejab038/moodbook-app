import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../main.dart';
import '../views/add_mood/add_mood_screen1_mood.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize Timezone
    tz.initializeTimeZones();
    try {
      final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('Could not get local timezone, defaulting to UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // 2. Initialize Android settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. Initialize iOS settings
    const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // 4. Combine initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle when notification is tapped
        _navigateToMoodLogging();
      },
    );
  }

  void _navigateToMoodLogging() {
    // Check if user is authenticated (cannot log mood without a user profile)
    if (FirebaseAuth.instance.currentUser == null) {
      print('User is not authenticated, skipping direct navigation');
      return;
    }

    void pushScreen() {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => AddMood()),
      );
    }

    if (navigatorKey.currentState != null) {
      pushScreen();
    } else {
      // If navigator is not ready yet (e.g. cold start), wait a bit and retry
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState != null) {
          pushScreen();
        } else {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (navigatorKey.currentState != null) {
              pushScreen();
            }
          });
        }
      });
    }
  }

  Future<bool> requestPermissions() async {
    bool granted = false;

    // Request iOS permissions
    final iosImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final bool? result = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
    }

    // Request Android permissions (needed for Android 13+)
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final bool? permissionGranted = await androidImplementation.requestNotificationsPermission();
      granted = permissionGranted ?? false;
    }
    
    return granted;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }
    return true; 
  }

  Future<bool> canScheduleExactAlarms() async {
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      return await androidImplementation.canScheduleExactNotifications() ?? false;
    }
    return true;
  }

  Future<void> requestExactAlarmsPermission() async {
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      try {
        await androidImplementation.requestExactAlarmsPermission();
      } catch (e) {
        print('Error requesting exact alarm settings page: $e');
      }
    }
  }

  String getDebugTimes() {
    final nowLocal = DateTime.now();
    final nowTz = tz.TZDateTime.now(tz.local);
    return 'Sys: ${nowLocal.hour.toString().padLeft(2, '0')}:${nowLocal.minute.toString().padLeft(2, '0')} | TZ: ${nowTz.hour.toString().padLeft(2, '0')}:${nowTz.minute.toString().padLeft(2, '0')} | Zone: ${tz.local.name}';
  }

  Future<String> getPendingNotificationsDebugString() async {
    final List<PendingNotificationRequest> pendingRequests =
        await _notificationsPlugin.pendingNotificationRequests();
    if (pendingRequests.isEmpty) {
      return 'Pending: None';
    }
    final buffer = StringBuffer('Pending (${pendingRequests.length}):\n');
    for (var request in pendingRequests) {
      buffer.write('- ID: ${request.id}, Title: ${request.title}\n');
    }
    return buffer.toString().trim();
  }

  // Schedule a daily check-in reminder
  Future<void> scheduleDailyReminder(int id, DateTime time) async {
    // Determine the next instance of this time in local timezone
    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(time.hour, time.minute);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'checkin_reminders_channel',
      'Check-in Reminders',
      channelDescription: 'Daily reminders to log your mood',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Try scheduling exact alarm first (fires at the exact minute)
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: 'Time for a mood check-in!',
        body: 'How are you feeling right now? Take a moment to log your mood in MoodBook.',
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
      );
      print('Scheduled exact daily reminder id: $id at $scheduledTime');
    } catch (e) {
      print('Exact alarm scheduling failed, falling back to inexact: $e');
      // Fallback to inexact alarm (avoids Android 14 SecurityException)
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: 'Time for a mood check-in!',
        body: 'How are you feeling right now? Take a moment to log your mood in MoodBook.',
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
      );
      print('Scheduled inexact daily reminder id: $id at $scheduledTime');
    }
  }

  // Trigger a test notification immediately
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'test_notifications_channel',
      'Test Notifications',
      channelDescription: 'Used for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: 999,
      title: 'MoodBook Test',
      body: 'This is a test notification from MoodBook! Your notifications are working perfectly.',
      notificationDetails: notificationDetails,
    );
    print('Displayed immediate test notification');
  }

  // Cancel all reminders
  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
    print('Cancelled all local reminders');
  }

  // Reschedule all active reminders
  Future<void> rescheduleAllLocalNotifications(List<CheckInReminder> reminders) async {
    await cancelAllReminders();
    for (int i = 0; i < reminders.length; i++) {
      final reminder = reminders[i];
      if (reminder.isEnabled) {
        await scheduleDailyReminder(i, reminder.timestamp);
      }
    }
  }

  // Helper method to get the next instance of a specific hour and minute
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
