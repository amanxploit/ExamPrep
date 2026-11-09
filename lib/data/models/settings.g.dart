// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 6;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      focusMinutes: fields[0] as int,
      shortBreakMinutes: fields[1] as int,
      longBreakMinutes: fields[2] as int,
      sessionsBeforeLongBreak: fields[3] as int,
      autoStartBreaks: fields[4] as bool,
      sound: fields[5] as bool,
      vibration: fields[6] as bool,
      dailyReminderTime: fields[7] as String?,
      onboardingDone: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.focusMinutes)
      ..writeByte(1)
      ..write(obj.shortBreakMinutes)
      ..writeByte(2)
      ..write(obj.longBreakMinutes)
      ..writeByte(3)
      ..write(obj.sessionsBeforeLongBreak)
      ..writeByte(4)
      ..write(obj.autoStartBreaks)
      ..writeByte(5)
      ..write(obj.sound)
      ..writeByte(6)
      ..write(obj.vibration)
      ..writeByte(7)
      ..write(obj.dailyReminderTime)
      ..writeByte(8)
      ..write(obj.onboardingDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
