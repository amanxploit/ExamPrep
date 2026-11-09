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
  
  Chapter({
    String? id,
    required this.subjectId,
    required this.name,
    required this.order,
    this.isCompleted = false,
    this.completedAt,
  }) : id = id ?? const Uuid().v4();
  
  Chapter copyWith({
    String? id,
    String? subjectId,
    String? name,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return Chapter(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
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
  
  @override
  String toString() => 'Chapter(id: $id, name: $name, isCompleted: $isCompleted)';
}