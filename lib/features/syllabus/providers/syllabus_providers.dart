import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'syllabus_providers.g.dart';

@riverpod
Stream<List<Subject>> subjects(SubjectsRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  if (exam == null) return Stream.value([]);
  return repo.watchSubjects(exam.id);
}

@riverpod
Stream<List<Chapter>> chaptersForSubject(
    ChaptersForSubjectRef ref, String subjectId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.watchChapters(subjectId);
}

@riverpod
Map<String, String> subjectStatuses(SubjectStatusesRef ref) {
  return ref.watch(subjectStatusProvider);
}

@riverpod
Future<void> addSubject(
  AddSubjectRef ref, {
  required String examId,
  required String subjectName,
  required int colorValue,
  List<String>? bulkChapters,
}) async {
  final repo = ref.watch(examRepositoryProvider);
  final subjects = repo.getSubjectsForExam(examId);
  final order = subjects.length;

  final subject = Subject(
    examId: examId,
    name: subjectName,
    order: order,
    colorValue: colorValue,
  );

  await repo.addSubject(subject);

  if (bulkChapters != null && bulkChapters.isNotEmpty) {
    for (int i = 0; i < bulkChapters.length; i++) {
      final chapterName = bulkChapters[i].trim();
      if (chapterName.isNotEmpty) {
        final chapter = Chapter(
          subjectId: subject.id,
          name: chapterName,
          order: i,
        );
        await repo.addChapter(chapter);
      }
    }
  }
}

@riverpod
Future<void> updateSubject(UpdateSubjectRef ref, Subject subject) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.updateSubject(subject);
}

@riverpod
Future<void> deleteSubject(DeleteSubjectRef ref, String subjectId) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.deleteSubject(subjectId);
}

@riverpod
Future<void> reorderSubjects(
    ReorderSubjectsRef ref, List<Subject> subjects) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.reorderSubjects(subjects);
}

@riverpod
Future<void> addChapter(
  AddChapterRef ref, {
  required String subjectId,
  required String chapterName,
}) async {
  final repo = ref.watch(examRepositoryProvider);
  final chapters = repo.getChaptersForSubject(subjectId);
  final order = chapters.length;

  final chapter = Chapter(
    subjectId: subjectId,
    name: chapterName,
    order: order,
  );

  await repo.addChapter(chapter);
}

@riverpod
Future<void> updateChapter(UpdateChapterRef ref, Chapter chapter) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.updateChapter(chapter);
}

@riverpod
Future<void> toggleChapter(ToggleChapterRef ref, Chapter chapter) async {
  final repo = ref.watch(examRepositoryProvider);
  if (chapter.isCompleted) {
    await repo.updateChapter(
        chapter.copyWith(isCompleted: false, clearCompletedAt: true));
  } else {
    await repo.updateChapter(chapter.copyWith(isCompleted: true));
  }
}

@riverpod
Future<void> deleteChapter(DeleteChapterRef ref, String chapterId) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.deleteChapter(chapterId);
}

@riverpod
Future<void> reorderChapters(
    ReorderChaptersRef ref, List<Chapter> chapters) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.reorderChapters(chapters);
}
