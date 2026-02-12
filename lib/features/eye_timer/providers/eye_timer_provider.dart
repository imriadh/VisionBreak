import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/notification_service.dart';

enum TimerStatus { idle, running, paused }

class EyeTimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final TimerStatus status;
  final int intervalMinutes;

  EyeTimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.status,
    required this.intervalMinutes,
  });

  EyeTimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    TimerStatus? status,
    int? intervalMinutes,
  }) {
    return EyeTimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    );
  }

  double get progress => remainingSeconds / totalSeconds;
}

class EyeTimerNotifier extends StateNotifier<EyeTimerState> {
  EyeTimerNotifier()
      : super(EyeTimerState(
          totalSeconds: AppConstants.defaultEyeTimerMinutes * 60,
          remainingSeconds: AppConstants.defaultEyeTimerMinutes * 60,
          status: TimerStatus.idle,
          intervalMinutes: AppConstants.defaultEyeTimerMinutes,
        )) {
    _loadSettings();
  }

  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final minutes = prefs.getInt(AppConstants.keyEyeTimerDuration) ??
        AppConstants.defaultEyeTimerMinutes;
    setInterval(minutes);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyEyeTimerDuration, state.intervalMinutes);
  }

  void setInterval(int minutes) {
    if (state.status == TimerStatus.idle) {
      final seconds = minutes * 60;
      state = state.copyWith(
        intervalMinutes: minutes,
        totalSeconds: seconds,
        remainingSeconds: seconds,
      );
      _saveSettings();
    }
  }

  void start() {
    if (state.status == TimerStatus.idle) {
      state = state.copyWith(status: TimerStatus.running);
      _startTimer();
      _showNotification();
    }
  }

  void pause() {
    if (state.status == TimerStatus.running) {
      _timer?.cancel();
      state = state.copyWith(status: TimerStatus.paused);
      _notificationService.cancelNotification(1);
    }
  }

  void resume() {
    if (state.status == TimerStatus.paused) {
      state = state.copyWith(status: TimerStatus.running);
      _startTimer();
      _showNotification();
    }
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      status: TimerStatus.idle,
    );
    _notificationService.cancelNotification(1);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        
        // Update notification every 10 seconds
        if (state.remainingSeconds % 10 == 0) {
          _showNotification();
        }
      } else {
        _onTimerComplete();
      }
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.idle);
    _notificationService.showEyeTimerNotification(
      title: '👁 Eye Break Time!',
      body: 'Look at something 20 feet away for 20 seconds',
      ongoing: false,
    );
    
    // Reset timer
    state = state.copyWith(remainingSeconds: state.totalSeconds);
  }

  void _showNotification() {
    final minutes = state.remainingSeconds ~/ 60;
    final seconds = state.remainingSeconds % 60;
    _notificationService.showEyeTimerNotification(
      title: 'Eye Care Timer Running',
      body: 'Next break in $minutes:${seconds.toString().padLeft(2, '0')}',
      ongoing: true,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final eyeTimerProvider =
    StateNotifierProvider<EyeTimerNotifier, EyeTimerState>((ref) {
  return EyeTimerNotifier();
});
