// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyPlanTaskAdapter extends TypeAdapter<DailyPlanTask> {
  @override
  final int typeId = 14;

  @override
  DailyPlanTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyPlanTask(
      id: fields[0] as String?,
      userId: fields[1] as String,
      date: fields[2] as DateTime,
      title: fields[3] as String,
      description: fields[4] as String,
      type: fields[5] as DailyPlanTaskType,
      sourceId: fields[6] as String?,
      estimatedMinutes: fields[7] as int,
      priorityScore: fields[8] as int,
      status: fields[9] as DailyPlanTaskStatus,
      startedAt: fields[10] as DateTime?,
      completedAt: fields[11] as DateTime?,
      actualMinutes: fields[12] as int,
      sortOrder: fields[13] as int,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyPlanTask obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.sourceId)
      ..writeByte(7)
      ..write(obj.estimatedMinutes)
      ..writeByte(8)
      ..write(obj.priorityScore)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.startedAt)
      ..writeByte(11)
      ..write(obj.completedAt)
      ..writeByte(12)
      ..write(obj.actualMinutes)
      ..writeByte(13)
      ..write(obj.sortOrder)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlanTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyPlanTaskTypeAdapter extends TypeAdapter<DailyPlanTaskType> {
  @override
  final int typeId = 15;

  @override
  DailyPlanTaskType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DailyPlanTaskType.studyChapter;
      case 1:
        return DailyPlanTaskType.revision;
      case 2:
        return DailyPlanTaskType.flashcard;
      case 3:
        return DailyPlanTaskType.breakTime;
      case 4:
        return DailyPlanTaskType.custom;
      default:
        return DailyPlanTaskType.studyChapter;
    }
  }

  @override
  void write(BinaryWriter writer, DailyPlanTaskType obj) {
    switch (obj) {
      case DailyPlanTaskType.studyChapter:
        writer.writeByte(0);
        break;
      case DailyPlanTaskType.revision:
        writer.writeByte(1);
        break;
      case DailyPlanTaskType.flashcard:
        writer.writeByte(2);
        break;
      case DailyPlanTaskType.breakTime:
        writer.writeByte(3);
        break;
      case DailyPlanTaskType.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlanTaskTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyPlanTaskStatusAdapter extends TypeAdapter<DailyPlanTaskStatus> {
  @override
  final int typeId = 16;

  @override
  DailyPlanTaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DailyPlanTaskStatus.pending;
      case 1:
        return DailyPlanTaskStatus.inProgress;
      case 2:
        return DailyPlanTaskStatus.completed;
      case 3:
        return DailyPlanTaskStatus.skipped;
      default:
        return DailyPlanTaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, DailyPlanTaskStatus obj) {
    switch (obj) {
      case DailyPlanTaskStatus.pending:
        writer.writeByte(0);
        break;
      case DailyPlanTaskStatus.inProgress:
        writer.writeByte(1);
        break;
      case DailyPlanTaskStatus.completed:
        writer.writeByte(2);
        break;
      case DailyPlanTaskStatus.skipped:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlanTaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
