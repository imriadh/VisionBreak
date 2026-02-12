import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/sleep_provider.dart';
import '../../core/theme/app_theme.dart';

class SleepPage extends ConsumerStatefulWidget {
  const SleepPage({super.key});

  @override
  ConsumerState<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends ConsumerState<SleepPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sleepProvider.notifier).calculateWakeTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sleepState = ref.watch(sleepProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('😴 Sleep Cycle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistoryDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E3A8A),
              const Color(0xFF3730A3),
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Optimal Wake Times',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'If you go to bed now, wake up at:',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),

                // Wake Time Cards
                ...sleepState.suggestedWakeTimes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final wakeTime = entry.value;
                  final cycles = index + 4;
                  final duration = wakeTime.difference(DateTime.now());

                  return _WakeTimeCard(
                    wakeTime: wakeTime,
                    cycles: cycles,
                    duration: duration,
                    isSelected: sleepState.selectedWakeTime == wakeTime,
                    onTap: () => _setAlarm(wakeTime),
                  );
                }),

                const SizedBox(height: 24),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sleep Cycles',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Each cycle is ~90 minutes. Wake between cycles for better rest.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Rate Sleep Button
                ElevatedButton.icon(
                  onPressed: () => _showRatingSleepDialog(context),
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Rate Last Night\'s Sleep'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setAlarm(DateTime wakeTime) {
    ref.read(sleepProvider.notifier).setAlarm(wakeTime);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm set for ${DateFormat.jm().format(wakeTime)}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showRatingSleepDialog(BuildContext context) {
    int selectedRating = 3;
    final bedTimeController = TextEditingController(
      text: TimeOfDay.now().format(context),
    );
    final wakeTimeController = TextEditingController(
      text: TimeOfDay.now().format(context),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Your Sleep'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was your sleep quality?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final emojis = ['😫', '😕', '😐', '🙂', '😊'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedRating = index + 1),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedRating == index + 1
                            ? AppTheme.primaryLight.withOpacity(0.2)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        emojis[index],
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final now = DateTime.now();
              ref.read(sleepProvider.notifier).addSleepRecord(
                    bedTime: now.subtract(const Duration(hours: 8)),
                    wakeTime: now,
                    rating: selectedRating,
                  );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sleep record saved')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(BuildContext context) {
    final records = ref.read(sleepProvider).records;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sleep History'),
        content: SizedBox(
          width: double.maxFinite,
          child: records.isEmpty
              ? const Center(child: Text('No sleep records yet'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return ListTile(
                      leading: Text(
                        ['😫', '😕', '😐', '🙂', '😊'][record.rating - 1],
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        DateFormat.yMMMd().format(record.bedTime),
                      ),
                      subtitle: Text(
                        '${record.duration.inHours}h ${record.duration.inMinutes % 60}m (${record.cycles.toStringAsFixed(1)} cycles)',
                      ),
                    );
                  },
                ),
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

class _WakeTimeCard extends StatelessWidget {
  final DateTime wakeTime;
  final int cycles;
  final Duration duration;
  final bool isSelected;
  final VoidCallback onTap;

  const _WakeTimeCard({
    required this.wakeTime,
    required this.cycles,
    required this.duration,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                ],
              )
            : null,
        color: isSelected ? null : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat.jm().format(wakeTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$cycles cycles',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hours}h ${minutes}m of sleep',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  )
                else
                  Icon(
                    Icons.alarm_add,
                    color: Colors.white.withOpacity(0.5),
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
