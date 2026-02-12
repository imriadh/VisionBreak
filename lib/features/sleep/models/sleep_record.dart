import 'package:hive/hive.dart';

part 'sleep_record.g.dart';

@HiveType(typeId: 0)
class SleepRecord {
  @HiveField(0)
  final DateTime bedTime;
  
  @HiveField(1)
  final DateTime wakeTime;
  
  @HiveField(2)
  final int rating; // 1-5
  
  @HiveField(3)
  final String? notes;

  SleepRecord({
    required this.bedTime,
    required this.wakeTime,
    required this.rating,
    this.notes,
  });

  Duration get duration => wakeTime.difference(bedTime);
  
  double get cycles => duration.inMinutes / 90.0;
}
