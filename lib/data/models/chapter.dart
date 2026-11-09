import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'chapter.g.dart';

@HiveType(typeId: 2)
class Chapter extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String subjectId;
  
  @HiveField(2)
  String name;
  
  @HiveField(3)
  int order;
  
  @HiveField(4)
  bool isCompleted;
  
  @HiveField(5)
  DateTime? completedAt;
  
  @HiveField(6)
  int estimatedMinutes;
  
  @HiveField(7)
  int importance;
  
  @HiveField(8)
  int difficulty;
  
  @HiveField(9)
  bool isInProgress;
  
  @HiveField(10)
  String description;

  Chapter({
    String? id,
    required this.subjectId,
    required this.name,
    required this.order,
    this.isCompleted = false,
    this.completedAt,
    this.estimatedMinutes = 0,
    this.importance = 3,
    this.difficulty = 3,
    this.isInProgress = false,
    this.description = '',
  }) : id = id ?? const Uuid().v4();
  
  Chapter copyWith({
    String? id,
    String? subjectId,
    String? name,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    int? estimatedMinutes,
    int? importance,
    int? difficulty,
    bool? isInProgress,
    String? description,
    bool clearCompletedAt = false,
  }) {
    return Chapter(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      importance: importance ?? this.importance,
      difficulty: difficulty ?? this.difficulty,
      isInProgress: isInProgress ?? this.isInProgress,
      description: description ?? this.description,
    );
  }
  
  void markCompleted() {
    isCompleted = true;
    completedAt = DateTime.now();
  }
  
  void markIncomplete() {
    isCompleted = false;
    completedAt = null;
  }
  
  void markInProgress() {
    isInProgress = true;
  }
  
  void markNotInProgress() {
    isInProgress = false;
  }
  
  @override
  String toString() => 'Chapter(id: $id, name: $name, isCompleted: $isCompleted)';
}