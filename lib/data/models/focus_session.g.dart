// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FocusSessionAdapter extends TypeAdapter<FocusSession> {
  @override
  final int typeId = 4;

  @override
  FocusSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusSession(
      id: fields[0] as String?,
      examId: fields[1] as String?,
      type: fields[2] as SessionType,
      startedAt: fields[3] as DateTime,
      durationMinutes: fields[4] as int,
      completed: fields[5] as bool,
      completedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FocusSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.completed)
      ..writeByte(6)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 5;

  @override
  SessionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionType.focus;
      case 1:
        return SessionType.shortBreak;
      case 2:
        return SessionType.longBreak;
      default:
        return SessionType.focus;
    }
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    switch (obj) {
      case SessionType.focus:
        writer.writeByte(0);
        break;
      case SessionType.shortBreak:
        writer.writeByte(1);
        break;
      case SessionType.longBreak:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
