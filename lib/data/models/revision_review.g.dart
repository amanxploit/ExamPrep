// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision_review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RevisionReviewAdapter extends TypeAdapter<RevisionReview> {
  @override
  final int typeId = 10;

  @override
  RevisionReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RevisionReview(
      id: fields[0] as String?,
      userId: fields[1] as String,
      revisionItemId: fields[2] as String,
      rating: fields[3] as ReviewRating,
      reviewedAt: fields[4] as DateTime,
      previousIntervalDays: fields[5] as int,
      previousEaseFactor: fields[6] as double,
      previousRepetitions: fields[7] as int,
      newIntervalDays: fields[8] as int,
      newEaseFactor: fields[9] as double,
      newRepetitions: fields[10] as int,
      nextDueAt: fields[11] as DateTime,
      timeSpent: fields[12] as Duration?,
      notes: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RevisionReview obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.revisionItemId)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.reviewedAt)
      ..writeByte(5)
      ..write(obj.previousIntervalDays)
      ..writeByte(6)
      ..write(obj.previousEaseFactor)
      ..writeByte(7)
      ..write(obj.previousRepetitions)
      ..writeByte(8)
      ..write(obj.newIntervalDays)
      ..writeByte(9)
      ..write(obj.newEaseFactor)
      ..writeByte(10)
      ..write(obj.newRepetitions)
      ..writeByte(11)
      ..write(obj.nextDueAt)
      ..writeByte(12)
      ..write(obj.timeSpent)
      ..writeByte(13)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevisionReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewRatingAdapter extends TypeAdapter<ReviewRating> {
  @override
  final int typeId = 11;

  @override
  ReviewRating read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReviewRating.again;
      case 1:
        return ReviewRating.hard;
      case 2:
        return ReviewRating.good;
      case 3:
        return ReviewRating.easy;
      default:
        return ReviewRating.again;
    }
  }

  @override
  void write(BinaryWriter writer, ReviewRating obj) {
    switch (obj) {
      case ReviewRating.again:
        writer.writeByte(0);
        break;
      case ReviewRating.hard:
        writer.writeByte(1);
        break;
      case ReviewRating.good:
        writer.writeByte(2);
        break;
      case ReviewRating.easy:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewRatingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
