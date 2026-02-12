import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../models/sleep_record.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/notification_service.dart';

class SleepState {
  final List<DateTime> suggestedWakeTimes;
  final List<SleepRecord> records;
  final DateTime? selectedWakeTime;

  SleepState({
    this.suggestedWakeTimes = const [],
    this.records = const [],
    this.selectedWakeTime,
  });

  SleepState copyWith({
    List<DateTime>? suggestedWakeTimes,
    List<SleepRecord>? records,
    DateTime? selectedWakeTime,
  }) {
    return SleepState(
      suggestedWakeTimes: suggestedWakeTimes ?? this.suggestedWakeTimes,
      records: records ?? this.records,
      selectedWakeTime: selectedWakeTime ?? this.selectedWakeTime,
    );
  }
}

class SleepNotifier extends StateNotifier<SleepState> {
  SleepNotifier() : super(SleepState()) {
    _init();
  }

  Box<SleepRecord>? _sleepBox;
  final NotificationService _notificationService = NotificationService();

  Future<void> _init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SleepRecordAdapter());
    }
    _sleepBox = await Hive.openBox<SleepRecord>('sleep_records');
    _loadRecords();
  }

  void _loadRecords() {
    if (_sleepBox != null) {
      final records = _sleepBox!.values.toList();
      records.sort((a, b) => b.bedTime.compareTo(a.bedTime));
      state = state.copyWith(records: records);
    }
  }

  List<DateTime> calculateWakeTimes({DateTime? fromTime}) {
    final now = fromTime ?? DateTime.now();
    final fallAsleepTime = now.add(
      const Duration(minutes: AppConstants.fallAsleepTimeMinutes),
    );

    final List<DateTime> wakeTimes = [];
    for (int cycles = 4; cycles <= 6; cycles++) {
      final wakeTime = fallAsleepTime.add(
        Duration(minutes: cycles * AppConstants.sleepCycleDurationMinutes),
      );
      wakeTimes.add(wakeTime);
    }

    state = state.copyWith(suggestedWakeTimes: wakeTimes);
    return wakeTimes;
  }

  Future<void> setAlarm(DateTime wakeTime) async {
    state = state.copyWith(selectedWakeTime: wakeTime);
    
    // Schedule alarm using Android Alarm Manager
    final alarmId = wakeTime.millisecondsSinceEpoch ~/ 1000;
    await AndroidAlarmManager.oneShotAt(
      wakeTime,
      alarmId,
      _alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    _notificationService.showSleepAlarmNotification(
      title: '⏰ Alarm Set',
      body: 'Wake up at ${_formatTime(wakeTime)}',
    );
  }

  static void _alarmCallback() {
    NotificationService().showSleepAlarmNotification(
      title: '⏰ Wake Up!',
      body: 'Time to start your day!',
    );
  }

  Future<void> addSleepRecord({
    required DateTime bedTime,
    required DateTime wakeTime,
    required int rating,
    String? notes,
  }) async {
    final record = SleepRecord(
      bedTime: bedTime,
      wakeTime: wakeTime,
      rating: rating,
      notes: notes,
    );

    await _sleepBox?.add(record);
    _loadRecords();
  }

  Future<void> deleteSleepRecord(int index) async {
    await _sleepBox?.deleteAt(index);
    _loadRecords();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

final sleepProvider = StateNotifierProvider<SleepNotifier, SleepState>((ref) {
  return SleepNotifier();
});
