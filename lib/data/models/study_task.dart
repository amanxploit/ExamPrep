import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'study_task.g.dart';

@HiveType(typeId: 3)
class StudyTask extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String examId;
  
  @HiveField(2)
  String title;
  
  @HiveField(3)
  String? subjectId;
  
  @HiveField(4)
  String? chapterId;
  
  @HiveField(5)
  DateTime dueDate;
  
  @HiveField(6)
  bool isDone;
  
  @HiveField(7)
  DateTime createdAt;
  
  StudyTask({
    String? id,
    required this.examId,
    required this.title,
    this.subjectId,
    this.chapterId,
    required this.dueDate,
    this.isDone = false,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();
  
  StudyTask copyWith({
    String? id,
    String? examId,
    String? title,
    String? subjectId,
    String? chapterId,
    DateTime? dueDate,
    bool? isDone,
    DateTime? createdAt,
    bool clearSubjectId = false,
    bool clearChapterId = false,
  }) {
    return StudyTask(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      title: title ?? this.title,
      subjectId: clearSubjectId ? null : (subjectId ?? this.subjectId),
      chapterId: clearChapterId ? null : (chapterId ?? this.chapterId),
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  String toString() => 'StudyTask(id: $id, title: $title, isDone: $isDone)';
}