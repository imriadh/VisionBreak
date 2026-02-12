import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    // Eye Timer Channel
    const eyeTimerChannel = AndroidNotificationChannel(
      AppConstants.eyeTimerChannelId,
      AppConstants.eyeTimerChannelName,
      description: AppConstants.eyeTimerChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    // Sleep Alarm Channel
    const sleepAlarmChannel = AndroidNotificationChannel(
      AppConstants.sleepAlarmChannelId,
      AppConstants.sleepAlarmChannelName,
      description: AppConstants.sleepAlarmChannelDescription,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    // Pomodoro Channel
    const pomodoroChannel = AndroidNotificationChannel(
      AppConstants.pomodoroChannelId,
      AppConstants.pomodoroChannelName,
      description: AppConstants.pomodoroChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(eyeTimerChannel);
    
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(sleepAlarmChannel);
    
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pomodoroChannel);
  }

  Future<void> showEyeTimerNotification({
    required String title,
    required String body,
    bool ongoing = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      AppConstants.eyeTimerChannelId,
      AppConstants.eyeTimerChannelName,
      channelDescription: AppConstants.eyeTimerChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: ongoing,
      autoCancel: false,
      styleInformation: const BigTextStyleInformation(''),
      actions: ongoing
          ? const <AndroidNotificationAction>[
              AndroidNotificationAction('pause', '⏸ Pause'),
              AndroidNotificationAction('stop', '⏹ Stop'),
            ]
          : null,
    );

    await _notifications.show(
      1,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showPomodoroNotification({
    required String title,
    required String body,
    bool ongoing = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      AppConstants.pomodoroChannelId,
      AppConstants.pomodoroChannelName,
      channelDescription: AppConstants.pomodoroChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ongoing: ongoing,
      autoCancel: false,
      actions: ongoing
          ? const <AndroidNotificationAction>[
              AndroidNotificationAction('pause', '⏸ Pause'),
              AndroidNotificationAction('stop', '⏹ Stop'),
            ]
          : null,
    );

    await _notifications.show(
      2,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showSleepAlarmNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.sleepAlarmChannelId,
      AppConstants.sleepAlarmChannelName,
      channelDescription: AppConstants.sleepAlarmChannelDescription,
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
    );

    await _notifications.show(
      3,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  void _onNotificationTap(NotificationResponse response) {
    final action = response.actionId;
    debugPrint('Notification tapped: $action');
    // Handle notification actions here
  }
}
