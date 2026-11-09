// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyTaskAdapter extends TypeAdapter<StudyTask> {
  @override
  final int typeId = 3;

  @override
  StudyTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyTask(
      id: fields[0] as String?,
      examId: fields[1] as String,
      title: fields[2] as String,
      subjectId: fields[3] as String?,
      chapterId: fields[4] as String?,
      dueDate: fields[5] as DateTime,
      isDone: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StudyTask obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.subjectId)
      ..writeByte(4)
      ..write(obj.chapterId)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.isDone)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
