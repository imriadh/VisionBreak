class AppConstants {
  // Eye Care Timer
  static const int defaultEyeTimerMinutes = 20;
  static const int minEyeTimerMinutes = 15;
  static const int maxEyeTimerMinutes = 60;
  static const int eyeBreakDurationSeconds = 20;
  
  // Sleep Cycle
  static const int sleepCycleDurationMinutes = 90;
  static const int fallAsleepTimeMinutes = 14;
  
  // Pomodoro
  static const int defaultPomodoroMinutes = 25;
  static const int defaultBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int pomodorosUntilLongBreak = 4;
  
  // Notification Channels
  static const String eyeTimerChannelId = 'eye_timer_channel';
  static const String eyeTimerChannelName = 'Eye Care Timer';
  static const String eyeTimerChannelDescription = 'Notifications for eye care reminders';
  
  static const String sleepAlarmChannelId = 'sleep_alarm_channel';
  static const String sleepAlarmChannelName = 'Sleep Alarm';
  static const String sleepAlarmChannelDescription = 'Notifications for sleep cycle alarms';
  
  static const String pomodoroChannelId = 'pomodoro_channel';
  static const String pomodoroChannelName = 'Pomodoro Timer';
  static const String pomodoroChannelDescription = 'Notifications for Pomodoro sessions';
  
  // Storage Keys
  static const String keyEyeTimerDuration = 'eye_timer_duration';
  static const String keyPomodoroWorkDuration = 'pomodoro_work_duration';
  static const String keyPomodoroBreakDuration = 'pomodoro_break_duration';
  static const String keyThemeMode = 'theme_mode';
  static const String keySleepRecords = 'sleep_records';
  static const String keyPomodoroStats = 'pomodoro_stats';
}
