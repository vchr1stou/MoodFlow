import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    debugPrint('Initializing notification service...');
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestCriticalPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // Request permissions explicitly
    if (Platform.isAndroid) {
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        debugPrint('Android notification permission granted: $granted');
      }
    } else if (Platform.isIOS) {
      final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
        debugPrint('iOS notification permission granted: $granted');
      }
    }

    // Check current permission status
    final settings = await _notifications.getNotificationAppLaunchDetails();
    debugPrint('Notification launch details: ${settings?.didNotificationLaunchApp}');
  }

  Future<void> scheduleDailyCheckIn({
    required int id,
    required DateTime scheduledTime,
    required String title,
    String? body,
  }) async {
    debugPrint('Scheduling daily check-in notification:');
    debugPrint('ID: $id');
    debugPrint('Time: $scheduledTime');
    debugPrint('Title: $title');

    final androidDetails = AndroidNotificationDetails(
      'daily_check_in_channel',
      'MoodFlow',
      channelDescription: 'Daily mood check-ins',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'daily_check_in',
      subtitle: title,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
      debugPrint('Scheduling notification for: $scheduledDate');
      
      await _notifications.zonedSchedule(
        id,
        'MoodFlow',
        null,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Successfully scheduled daily check-in notification');
    } catch (e) {
      debugPrint('Error scheduling daily check-in notification: $e');
    }
  }

  Future<void> scheduleQuoteReminder({
    required DateTime scheduledTime,
  }) async {
    debugPrint('Scheduling quote reminder notification:');
    debugPrint('Time: $scheduledTime');

    final androidDetails = AndroidNotificationDetails(
      'quote_reminder_channel',
      'MoodFlow',
      channelDescription: 'Daily inspirational quotes',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'quote_reminder',
      subtitle: 'Daily Inspiration',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
      debugPrint('Scheduling quote reminder for: $scheduledDate');
      
      await _notifications.zonedSchedule(
        100, // Using a different ID range for quote reminders
        'MoodFlow',
        null,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Successfully scheduled quote reminder notification');
    } catch (e) {
      debugPrint('Error scheduling quote reminder notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    debugPrint('Canceling notification with ID: $id');
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    debugPrint('Canceling all notifications');
    await _notifications.cancelAll();
  }
} 