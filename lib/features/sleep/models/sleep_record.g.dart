// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepRecordAdapter extends TypeAdapter<SleepRecord> {
  @override
  final int typeId = 0;

  @override
  SleepRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepRecord(
      bedTime: fields[0] as DateTime,
      wakeTime: fields[1] as DateTime,
      rating: fields[2] as int,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.bedTime)
      ..writeByte(1)
      ..write(obj.wakeTime)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
