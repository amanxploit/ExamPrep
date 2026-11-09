import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:exam_prep/data/models/revision_review.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 12)
class Flashcard extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String? chapterId;

  @HiveField(3)
  String? revisionItemId;

  @HiveField(4)
  String front;

  @HiveField(5)
  String back;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  double confidence;

  @HiveField(8)
  int reviewCount;

  @HiveField(9)
  DateTime? lastReviewedAt;

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  DateTime updatedAt;

  Flashcard({
    String? id,
    required this.userId,
    this.chapterId,
    this.revisionItemId,
    required this.front,
    required this.back,
    this.tags = const [],
    this.confidence = 0.0,
    this.reviewCount = 0,
    this.lastReviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Flashcard copyWith({
    String? id,
    String? userId,
    String? chapterId,
    String? revisionItemId,
    String? front,
    String? back,
    List<String>? tags,
    double? confidence,
    int? reviewCount,
    DateTime? lastReviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      chapterId: chapterId ?? this.chapterId,
      revisionItemId: revisionItemId ?? this.revisionItemId,
      front: front ?? this.front,
      back: back ?? this.back,
      tags: tags ?? this.tags,
      confidence: confidence ?? this.confidence,
      reviewCount: reviewCount ?? this.reviewCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

@HiveType(typeId: 13)
class FlashcardReview extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String flashcardId;

  @HiveField(3)
  ReviewRating rating;

  @HiveField(4)
  DateTime reviewedAt;

  @HiveField(5)
  Duration? timeSpent;

  @HiveField(6)
  double previousConfidence;

  @HiveField(7)
  double newConfidence;

  FlashcardReview({
    String? id,
    required this.userId,
    required this.flashcardId,
    required this.rating,
    required this.reviewedAt,
    this.timeSpent,
    required this.previousConfidence,
    required this.newConfidence,
  }) : id = id ?? const Uuid().v4();
}
