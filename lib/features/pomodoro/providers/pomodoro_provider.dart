import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/notification_service.dart';

enum PomodoroPhase { work, shortBreak, longBreak }
enum PomodoroStatus { idle, running, paused }

class PomodoroState {
  final int workMinutes;
  final int breakMinutes;
  final int remainingSeconds;
  final int totalSeconds;
  final PomodoroPhase phase;
  final PomodoroStatus status;
  final int completedPomodoros;
  final int todayPomodoros;

  PomodoroState({
    required this.workMinutes,
    required this.breakMinutes,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.phase,
    required this.status,
    required this.completedPomodoros,
    required this.todayPomodoros,
  });

  PomodoroState copyWith({
    int? workMinutes,
    int? breakMinutes,
    int? remainingSeconds,
    int? totalSeconds,
    PomodoroPhase? phase,
    PomodoroStatus? status,
    int? completedPomodoros,
    int? todayPomodoros,
  }) {
    return PomodoroState(
      workMinutes: workMinutes ?? this.workMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      todayPomodoros: todayPomodoros ?? this.todayPomodoros,
    );
  }

  double get progress => remainingSeconds / totalSeconds;
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier()
      : super(PomodoroState(
          workMinutes: AppConstants.defaultPomodoroMinutes,
          breakMinutes: AppConstants.defaultBreakMinutes,
          remainingSeconds: AppConstants.defaultPomodoroMinutes * 60,
          totalSeconds: AppConstants.defaultPomodoroMinutes * 60,
          phase: PomodoroPhase.work,
          status: PomodoroStatus.idle,
          completedPomodoros: 0,
          todayPomodoros: 0,
        )) {
    _loadSettings();
  }

  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final workMinutes = prefs.getInt(AppConstants.keyPomodoroWorkDuration) ??
        AppConstants.defaultPomodoroMinutes;
    final breakMinutes = prefs.getInt(AppConstants.keyPomodoroBreakDuration) ??
        AppConstants.defaultBreakMinutes;
    
    final today = DateTime.now();
    final lastDate = prefs.getString('last_pomodoro_date');
    final todayString = '${today.year}-${today.month}-${today.day}';
    
    final todayCount = (lastDate == todayString)
        ? (prefs.getInt('today_pomodoros') ?? 0)
        : 0;

    state = state.copyWith(
      workMinutes: workMinutes,
      breakMinutes: breakMinutes,
      remainingSeconds: workMinutes * 60,
      totalSeconds: workMinutes * 60,
      todayPomodoros: todayCount,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyPomodoroWorkDuration, state.workMinutes);
    await prefs.setInt(AppConstants.keyPomodoroBreakDuration, state.breakMinutes);
  }

  Future<void> _saveTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    await prefs.setString('last_pomodoro_date', todayString);
    await prefs.setInt('today_pomodoros', state.todayPomodoros);
  }

  void setWorkDuration(int minutes) {
    if (state.status == PomodoroStatus.idle && state.phase == PomodoroPhase.work) {
      state = state.copyWith(
        workMinutes: minutes,
        remainingSeconds: minutes * 60,
        totalSeconds: minutes * 60,
      );
      _saveSettings();
    }
  }

  void setBreakDuration(int minutes) {
    if (state.status == PomodoroStatus.idle) {
      state = state.copyWith(breakMinutes: minutes);
      _saveSettings();
    }
  }

  void start() {
    if (state.status == PomodoroStatus.idle) {
      state = state.copyWith(status: PomodoroStatus.running);
      _startTimer();
      _showNotification();
    }
  }

  void pause() {
    if (state.status == PomodoroStatus.running) {
      _timer?.cancel();
      state = state.copyWith(status: PomodoroStatus.paused);
      _notificationService.cancelNotification(2);
    }
  }

  void resume() {
    if (state.status == PomodoroStatus.paused) {
      state = state.copyWith(status: PomodoroStatus.running);
      _startTimer();
      _showNotification();
    }
  }

  void reset() {
    _timer?.cancel();
    final seconds = state.phase == PomodoroPhase.work
        ? state.workMinutes * 60
        : state.breakMinutes * 60;
    state = state.copyWith(
      remainingSeconds: seconds,
      totalSeconds: seconds,
      status: PomodoroStatus.idle,
    );
    _notificationService.cancelNotification(2);
  }

  void skipPhase() {
    _timer?.cancel();
    _switchPhase();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        
        if (state.remainingSeconds % 10 == 0) {
          _showNotification();
        }
      } else {
        _onPhaseComplete();
      }
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    
    if (state.phase == PomodoroPhase.work) {
      final newCompleted = state.completedPomodoros + 1;
      final newToday = state.todayPomodoros + 1;
      
      state = state.copyWith(
        completedPomodoros: newCompleted,
        todayPomodoros: newToday,
      );
      _saveTodayCount();
      
      _notificationService.showPomodoroNotification(
        title: '🎉 Work Session Complete!',
        body: 'Great job! Time for a break.',
        ongoing: false,
      );
    } else {
      _notificationService.showPomodoroNotification(
        title: '⏰ Break Complete!',
        body: 'Ready to focus again?',
        ongoing: false,
      );
    }
    
    _switchPhase();
  }

  void _switchPhase() {
    if (state.phase == PomodoroPhase.work) {
      final isLongBreak = state.completedPomodoros % 
          AppConstants.pomodorosUntilLongBreak == 0;
      final nextPhase = isLongBreak 
          ? PomodoroPhase.longBreak 
          : PomodoroPhase.shortBreak;
      final breakMinutes = isLongBreak 
          ? AppConstants.defaultLongBreakMinutes 
          : state.breakMinutes;
      
      state = state.copyWith(
        phase: nextPhase,
        remainingSeconds: breakMinutes * 60,
        totalSeconds: breakMinutes * 60,
        status: PomodoroStatus.idle,
      );
    } else {
      state = state.copyWith(
        phase: PomodoroPhase.work,
        remainingSeconds: state.workMinutes * 60,
        totalSeconds: state.workMinutes * 60,
        status: PomodoroStatus.idle,
      );
    }
  }

  void _showNotification() {
    final minutes = state.remainingSeconds ~/ 60;
    final seconds = state.remainingSeconds % 60;
    final phaseText = state.phase == PomodoroPhase.work 
        ? 'Focus Time' 
        : 'Break Time';
    
    _notificationService.showPomodoroNotification(
      title: '$phaseText - $minutes:${seconds.toString().padLeft(2, '0')}',
      body: state.phase == PomodoroPhase.work 
          ? 'Stay focused!' 
          : 'Take a rest',
      ongoing: true,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});
