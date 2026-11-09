import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'revision_review.g.dart';

@HiveType(typeId: 10)
class RevisionReview extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String revisionItemId;

  @HiveField(3)
  ReviewRating rating;

  @HiveField(4)
  DateTime reviewedAt;

  @HiveField(5)
  int previousIntervalDays;

  @HiveField(6)
  double previousEaseFactor;

  @HiveField(7)
  int previousRepetitions;

  @HiveField(8)
  int newIntervalDays;

  @HiveField(9)
  double newEaseFactor;

  @HiveField(10)
  int newRepetitions;

  @HiveField(11)
  DateTime nextDueAt;

  @HiveField(12)
  Duration? timeSpent;

  @HiveField(13)
  String? notes;

  RevisionReview({
    String? id,
    required this.userId,
    required this.revisionItemId,
    required this.rating,
    required this.reviewedAt,
    required this.previousIntervalDays,
    required this.previousEaseFactor,
    required this.previousRepetitions,
    required this.newIntervalDays,
    required this.newEaseFactor,
    required this.newRepetitions,
    required this.nextDueAt,
    this.timeSpent,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  RevisionReview copyWith({
    String? id,
    String? userId,
    String? revisionItemId,
    ReviewRating? rating,
    DateTime? reviewedAt,
    int? previousIntervalDays,
    double? previousEaseFactor,
    int? previousRepetitions,
    int? newIntervalDays,
    double? newEaseFactor,
    int? newRepetitions,
    DateTime? nextDueAt,
    Duration? timeSpent,
    String? notes,
  }) {
    return RevisionReview(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      revisionItemId: revisionItemId ?? this.revisionItemId,
      rating: rating ?? this.rating,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      previousIntervalDays: previousIntervalDays ?? this.previousIntervalDays,
      previousEaseFactor: previousEaseFactor ?? this.previousEaseFactor,
      previousRepetitions: previousRepetitions ?? this.previousRepetitions,
      newIntervalDays: newIntervalDays ?? this.newIntervalDays,
      newEaseFactor: newEaseFactor ?? this.newEaseFactor,
      newRepetitions: newRepetitions ?? this.newRepetitions,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      timeSpent: timeSpent ?? this.timeSpent,
      notes: notes ?? this.notes,
    );
  }
}

@HiveType(typeId: 11)
enum ReviewRating {
  @HiveField(0)
  again,
  @HiveField(1)
  hard,
  @HiveField(2)
  good,
  @HiveField(3)
  easy,
}

extension ReviewRatingExtension on ReviewRating {
  String get displayName {
    switch (this) {
      case ReviewRating.again:
        return 'Again';
      case ReviewRating.hard:
        return 'Hard';
      case ReviewRating.good:
        return 'Good';
      case ReviewRating.easy:
        return 'Easy';
    }
  }

  int get quality {
    switch (this) {
      case ReviewRating.again:
        return 0;
      case ReviewRating.hard:
        return 3;
      case ReviewRating.good:
        return 4;
      case ReviewRating.easy:
        return 5;
    }
  }
}
