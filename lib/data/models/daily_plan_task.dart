import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'daily_plan_task.g.dart';

@HiveType(typeId: 14)
class DailyPlanTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String title;

  @HiveField(4)
  String description;

  @HiveField(5)
  DailyPlanTaskType type;

  @HiveField(6)
  String? sourceId;

  @HiveField(7)
  int estimatedMinutes;

  @HiveField(8)
  int priorityScore;

  @HiveField(9)
  DailyPlanTaskStatus status;

  @HiveField(10)
  DateTime? startedAt;

  @HiveField(11)
  DateTime? completedAt;

  @HiveField(12)
  int actualMinutes;

  @HiveField(13)
  int sortOrder;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  DateTime updatedAt;

  DailyPlanTask({
    String? id,
    required this.userId,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    this.sourceId,
    required this.estimatedMinutes,
    this.priorityScore = 0,
    this.status = DailyPlanTaskStatus.pending,
    this.startedAt,
    this.completedAt,
    this.actualMinutes = 0,
    this.sortOrder = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  DailyPlanTask copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? title,
    String? description,
    DailyPlanTaskType? type,
    String? sourceId,
    int? estimatedMinutes,
    int? priorityScore,
    DailyPlanTaskStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? actualMinutes,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyPlanTask(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      sourceId: sourceId ?? this.sourceId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      priorityScore: priorityScore ?? this.priorityScore,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isCompleted => status == DailyPlanTaskStatus.completed;
  bool get isInProgress => status == DailyPlanTaskStatus.inProgress;
  bool get isPending => status == DailyPlanTaskStatus.pending;
  bool get isSkipped => status == DailyPlanTaskStatus.skipped;

  int get remainingMinutes => (estimatedMinutes - actualMinutes).clamp(0, estimatedMinutes);
}

@HiveType(typeId: 15)
enum DailyPlanTaskType {
  @HiveField(0)
  studyChapter,
  @HiveField(1)
  revision,
  @HiveField(2)
  flashcard,
  @HiveField(3)
  breakTime,
  @HiveField(4)
  custom,
}

@HiveType(typeId: 16)
enum DailyPlanTaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  skipped,
}

extension DailyPlanTaskTypeExtension on DailyPlanTaskType {
  String get displayName {
    switch (this) {
      case DailyPlanTaskType.studyChapter:
        return 'Study Chapter';
      case DailyPlanTaskType.revision:
        return 'Revision';
      case DailyPlanTaskType.flashcard:
        return 'Flashcards';
      case DailyPlanTaskType.breakTime:
        return 'Break';
      case DailyPlanTaskType.custom:
        return 'Custom';
    }
  }
}

extension DailyPlanTaskStatusExtension on DailyPlanTaskStatus {
  String get displayName {
    switch (this) {
      case DailyPlanTaskStatus.pending:
        return 'Pending';
      case DailyPlanTaskStatus.inProgress:
        return 'In Progress';
      case DailyPlanTaskStatus.completed:
        return 'Completed';
      case DailyPlanTaskStatus.skipped:
        return 'Skipped';
    }
  }
}