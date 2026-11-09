// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamAdapter extends TypeAdapter<Exam> {
  @override
  final int typeId = 0;

  @override
  Exam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exam(
      id: fields[0] as String?,
      name: fields[1] as String,
      examDate: fields[2] as DateTime,
      createdAt: fields[3] as DateTime,
      isActive: fields[4] as bool,
      colorValue: fields[5] as int,
      dailyGoalMinutes: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Exam obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.examDate)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.dailyGoalMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
