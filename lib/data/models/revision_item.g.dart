// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RevisionItemAdapter extends TypeAdapter<RevisionItem> {
  @override
  final int typeId = 8;

  @override
  RevisionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RevisionItem(
      id: fields[0] as String?,
      userId: fields[1] as String,
      chapterId: fields[2] as String,
      title: fields[3] as String,
      dueAt: fields[4] as DateTime,
      intervalDays: fields[5] as int,
      easeFactor: fields[6] as double,
      repetitions: fields[7] as int,
      status: fields[8] as RevisionStatus,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RevisionItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.chapterId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.dueAt)
      ..writeByte(5)
      ..write(obj.intervalDays)
      ..writeByte(6)
      ..write(obj.easeFactor)
      ..writeByte(7)
      ..write(obj.repetitions)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevisionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RevisionStatusAdapter extends TypeAdapter<RevisionStatus> {
  @override
  final int typeId = 9;

  @override
  RevisionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RevisionStatus.pending;
      case 1:
        return RevisionStatus.inProgress;
      case 2:
        return RevisionStatus.completed;
      case 3:
        return RevisionStatus.archived;
      default:
        return RevisionStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, RevisionStatus obj) {
    switch (obj) {
      case RevisionStatus.pending:
        writer.writeByte(0);
        break;
      case RevisionStatus.inProgress:
        writer.writeByte(1);
        break;
      case RevisionStatus.completed:
        writer.writeByte(2);
        break;
      case RevisionStatus.archived:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevisionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
