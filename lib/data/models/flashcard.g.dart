// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardAdapter extends TypeAdapter<Flashcard> {
  @override
  final int typeId = 12;

  @override
  Flashcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flashcard(
      id: fields[0] as String?,
      userId: fields[1] as String,
      chapterId: fields[2] as String?,
      revisionItemId: fields[3] as String?,
      front: fields[4] as String,
      back: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
      confidence: fields[7] as double,
      reviewCount: fields[8] as int,
      lastReviewedAt: fields[9] as DateTime?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Flashcard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.chapterId)
      ..writeByte(3)
      ..write(obj.revisionItemId)
      ..writeByte(4)
      ..write(obj.front)
      ..writeByte(5)
      ..write(obj.back)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.confidence)
      ..writeByte(8)
      ..write(obj.reviewCount)
      ..writeByte(9)
      ..write(obj.lastReviewedAt)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashcardReviewAdapter extends TypeAdapter<FlashcardReview> {
  @override
  final int typeId = 13;

  @override
  FlashcardReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardReview(
      id: fields[0] as String?,
      userId: fields[1] as String,
      flashcardId: fields[2] as String,
      rating: fields[3] as ReviewRating,
      reviewedAt: fields[4] as DateTime,
      timeSpent: fields[5] as Duration?,
      previousConfidence: fields[6] as double,
      newConfidence: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardReview obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.flashcardId)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.reviewedAt)
      ..writeByte(5)
      ..write(obj.timeSpent)
      ..writeByte(6)
      ..write(obj.previousConfidence)
      ..writeByte(7)
      ..write(obj.newConfidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
