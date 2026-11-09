import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';

part 'task_providers.g.dart';

@riverpod
Stream<List<StudyTask>> examTasks(ExamTasksRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.watchTasks(examId);
}

@riverpod
Future<void> addTask(AddTaskRef ref, {
  required String examId,
  required String title,
  String? subjectId,
  String? chapterId,
  required DateTime dueDate,
}) async {
  final repo = ref.watch(examRepositoryProvider);
  final task = StudyTask(
    examId: examId,
    title: title,
    subjectId: subjectId,
    chapterId: chapterId,
    dueDate: dueDate,
    createdAt: DateTime.now(),
  );
  await repo.addTask(task);
}

@riverpod
Future<void> updateTask(UpdateTaskRef ref, StudyTask task) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.updateTask(task);
}

@riverpod
Future<void> deleteTask(DeleteTaskRef ref, String taskId) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.deleteTask(taskId);
}

@riverpod
Future<void> toggleTask(ToggleTaskRef ref, StudyTask task) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.updateTask(task.copyWith(isDone: !task.isDone));
}