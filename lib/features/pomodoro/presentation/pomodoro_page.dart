import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../providers/pomodoro_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_formatter.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(pomodoroProvider);
    final pomodoroNotifier = ref.read(pomodoroProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Pomodoro Focus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStatsDialog(context, pomodoroState),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.shade400,
              Colors.orange.shade400,
              Colors.amber.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phase Indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pomodoroState.phase == PomodoroPhase.work
                          ? Icons.work_outline
                          : Icons.coffee_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pomodoroState.phase == PomodoroPhase.work
                          ? 'FOCUS TIME'
                          : pomodoroState.phase == PomodoroPhase.shortBreak
                              ? 'SHORT BREAK'
                              : 'LONG BREAK',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Circular Timer
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: pomodoroState.progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: CircularTimerPainter(
                        progress: value,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        progressColor: Colors.white,
                      ),
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TimeFormatter.formatDuration(
                                  Duration(seconds: pomodoroState.remainingSeconds),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${pomodoroState.completedPomodoros} / 4',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pomodoroState.status == PomodoroStatus.idle ||
                        pomodoroState.status == PomodoroStatus.paused) ...[
                      _ControlButton(
                        icon: pomodoroState.status == PomodoroStatus.idle
                            ? Icons.play_arrow
                            : Icons.play_arrow,
                        onPressed: pomodoroState.status == PomodoroStatus.idle
                            ? pomodoroNotifier.start
                            : pomodoroNotifier.resume,
                        label: pomodoroState.status == PomodoroStatus.idle
                            ? 'Start'
                            : 'Resume',
                      ),
                    ],
                    if (pomodoroState.status == PomodoroStatus.running) ...[
                      _ControlButton(
                        icon: Icons.pause,
                        onPressed: pomodoroNotifier.pause,
                        label: 'Pause',
                      ),
                    ],
                    if (pomodoroState.status != PomodoroStatus.idle) ...[
                      const SizedBox(width: 20),
                      _ControlButton(
                        icon: Icons.stop,
                        onPressed: pomodoroNotifier.reset,
                        label: 'Reset',
                      ),
                      const SizedBox(width: 20),
                      _ControlButton(
                        icon: Icons.skip_next,
                        onPressed: pomodoroNotifier.skipPhase,
                        label: 'Skip',
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Duration Settings
              if (pomodoroState.status == PomodoroStatus.idle)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (pomodoroState.phase == PomodoroPhase.work) ...[
                        _DurationSetting(
                          label: 'Work Duration',
                          value: pomodoroState.workMinutes,
                          onDecrease: pomodoroState.workMinutes > 15
                              ? () => pomodoroNotifier
                                  .setWorkDuration(pomodoroState.workMinutes - 5)
                              : null,
                          onIncrease: pomodoroState.workMinutes < 60
                              ? () => pomodoroNotifier
                                  .setWorkDuration(pomodoroState.workMinutes + 5)
                              : null,
                        ),
                      ] else ...[
                        _DurationSetting(
                          label: 'Break Duration',
                          value: pomodoroState.breakMinutes,
                          onDecrease: pomodoroState.breakMinutes > 5
                              ? () => pomodoroNotifier.setBreakDuration(
                                  pomodoroState.breakMinutes - 5)
                              : null,
                          onIncrease: pomodoroState.breakMinutes < 30
                              ? () => pomodoroNotifier.setBreakDuration(
                                  pomodoroState.breakMinutes + 5)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Stats Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.today,
                      label: 'Today',
                      value: '${pomodoroState.todayPomodoros}',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _StatItem(
                      icon: Icons.timer_outlined,
                      label: 'Session',
                      value: '${pomodoroState.completedPomodoros}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context, PomodoroState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📊 Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow('Today\'s Pomodoros', '${state.todayPomodoros}'),
            _StatRow('Current Session', '${state.completedPomodoros}'),
            _StatRow(
              'Focus Time Today',
              '${state.todayPomodoros * state.workMinutes} min',
            ),
            const Divider(),
            const Text(
              'Keep up the great work! 🎉',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String label;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange.shade700,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _DurationSetting extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const _DurationSetting({
    required this.label,
    required this.value,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.white,
              iconSize: 32,
              onPressed: onDecrease,
            ),
            const SizedBox(width: 20),
            Text(
              '$value min',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.white,
              iconSize: 32,
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  CircularTimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
