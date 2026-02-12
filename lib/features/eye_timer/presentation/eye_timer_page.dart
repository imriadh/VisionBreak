import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../providers/eye_timer_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../core/constants/app_constants.dart';

class EyeTimerPage extends ConsumerWidget {
  const EyeTimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(eyeTimerProvider);
    final timerNotifier = ref.read(eyeTimerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('👁 Eye Care Timer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Circular Timer
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: timerState.progress),
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
                                  Duration(seconds: timerState.remainingSeconds),
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
                              Text(
                                timerState.status == TimerStatus.idle
                                    ? 'Ready to start'
                                    : timerState.status == TimerStatus.paused
                                        ? 'Paused'
                                        : 'Until next break',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
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
                    if (timerState.status == TimerStatus.idle ||
                        timerState.status == TimerStatus.paused) ...[
                      _ControlButton(
                        icon: timerState.status == TimerStatus.idle
                            ? Icons.play_arrow
                            : Icons.play_arrow,
                        onPressed: timerState.status == TimerStatus.idle
                            ? timerNotifier.start
                            : timerNotifier.resume,
                        label: timerState.status == TimerStatus.idle
                            ? 'Start'
                            : 'Resume',
                      ),
                    ],
                    if (timerState.status == TimerStatus.running) ...[
                      _ControlButton(
                        icon: Icons.pause,
                        onPressed: timerNotifier.pause,
                        label: 'Pause',
                      ),
                    ],
                    if (timerState.status != TimerStatus.idle) ...[
                      const SizedBox(width: 20),
                      _ControlButton(
                        icon: Icons.stop,
                        onPressed: timerNotifier.reset,
                        label: 'Reset',
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Interval Selector
              if (timerState.status == TimerStatus.idle)
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
                      Text(
                        'Interval Duration',
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
                            onPressed: timerState.intervalMinutes >
                                    AppConstants.minEyeTimerMinutes
                                ? () => timerNotifier.setInterval(
                                    timerState.intervalMinutes - 5)
                                : null,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${timerState.intervalMinutes} min',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.white,
                            iconSize: 32,
                            onPressed: timerState.intervalMinutes <
                                    AppConstants.maxEyeTimerMinutes
                                ? () => timerNotifier.setInterval(
                                    timerState.intervalMinutes + 5)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Info Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '20-20-20 Rule: Every 20 minutes, look at something 20 feet away for 20 seconds',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
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
        FloatingActionButton.large(
          onPressed: onPressed,
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.primaryLight,
          child: Icon(icon, size: 36),
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
