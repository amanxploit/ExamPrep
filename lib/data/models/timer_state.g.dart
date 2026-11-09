// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerStateAdapter extends TypeAdapter<TimerState> {
  @override
  final int typeId = 7;

  @override
  TimerState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerState(
      examId: fields[0] as String?,
      currentType: fields[1] as SessionType,
      remainingSeconds: fields[2] as int,
      isRunning: fields[3] as bool,
      completedFocusSessions: fields[4] as int,
      endTime: fields[5] as DateTime?,
      sessionStartTime: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TimerState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.examId)
      ..writeByte(1)
      ..write(obj.currentType)
      ..writeByte(2)
      ..write(obj.remainingSeconds)
      ..writeByte(3)
      ..write(obj.isRunning)
      ..writeByte(4)
      ..write(obj.completedFocusSessions)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.sessionStartTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
