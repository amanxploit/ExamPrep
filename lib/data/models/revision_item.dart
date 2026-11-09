import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'revision_item.g.dart';

@HiveType(typeId: 8)
class RevisionItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String chapterId;

  @HiveField(3)
  String title;

  @HiveField(4)
  DateTime dueAt;

  @HiveField(5)
  int intervalDays;

  @HiveField(6)
  double easeFactor;

  @HiveField(7)
  int repetitions;

  @HiveField(8)
  RevisionStatus status;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  RevisionItem({
    String? id,
    required this.userId,
    required this.chapterId,
    required this.title,
    required this.dueAt,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
    this.repetitions = 0,
    this.status = RevisionStatus.pending,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  RevisionItem copyWith({
    String? id,
    String? userId,
    String? chapterId,
    String? title,
    DateTime? dueAt,
    int? intervalDays,
    double? easeFactor,
    int? repetitions,
    RevisionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RevisionItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isOverdue =>
      dueAt.isBefore(DateTime.now().dateOnly) &&
      status == RevisionStatus.pending;
  bool get isDueToday =>
      dueAt.dateOnly == DateTime.now().dateOnly &&
      status == RevisionStatus.pending;
  bool get isUpcoming =>
      dueAt.isAfter(DateTime.now().dateOnly) &&
      status == RevisionStatus.pending;
  bool get isCompleted => status == RevisionStatus.completed;
}

@HiveType(typeId: 9)
enum RevisionStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  archived,
}
