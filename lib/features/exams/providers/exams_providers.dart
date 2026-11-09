import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'exams_providers.g.dart';

@riverpod
Stream<List<Exam>> allExams(AllExamsRef ref) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.watchExams();
}

@riverpod
Future<void> createExam(
  CreateExamRef ref, {
  required String examName,
  required DateTime examDate,
  required int colorValue,
  int dailyGoalMinutes = 120,
}) async {
  final repo = ref.watch(examRepositoryProvider);
  final exams = repo.getAllExams();
  final isFirst = exams.isEmpty;

  final exam = Exam(
    name: examName,
    examDate: examDate,
    createdAt: DateTime.now(),
    isActive: isFirst,
    colorValue: colorValue,
    dailyGoalMinutes: dailyGoalMinutes,
  );

  await repo.addExam(exam);
}

@riverpod
Future<void> updateExam(UpdateExamRef ref, Exam exam) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.updateExam(exam);
}

@riverpod
Future<void> deleteExam(DeleteExamRef ref, String examId) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.deleteExam(examId);
}

@riverpod
Future<void> setActiveExam(SetActiveExamRef ref, String examId) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.setActiveExam(examId);
}

@riverpod
List<Subject> subjectsForExam(SubjectsForExamRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getSubjectsForExam(examId);
}

@riverpod
Map<String, int> examStats(ExamStatsRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  final exam = repo.getExam(examId);

  if (exam == null) {
    return {
      'totalChapters': 0,
      'completedChapters': 0,
      'focusMinutes': 0,
      'streak': 0,
      'syllabusPercent': 0,
    };
  }

  final chapters = repo.getAllChaptersForExam(examId);
  final totalChapters = chapters.length;
  final completedChapters = chapters.where((c) => c.isCompleted).length;

  final sessions = repo.getCompletedSessions(examId);
  final focusMinutes = sessions
      .where((s) => s.type == SessionType.focus)
      .fold(0, (sum, s) => sum + s.durationMinutes);

  // Calculate streak for this exam
  final activityDates = <DateTime>{};
  for (final session in sessions.where((s) => s.type == SessionType.focus)) {
    activityDates.add(session.startedAt.dateOnly);
  }
  for (final chapter
      in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
    activityDates.add(chapter.completedAt!.dateOnly);
  }

  var streak = 0;
  if (activityDates.isNotEmpty) {
    var currentDate = DateTime.now().dateOnly;
    if (!activityDates.contains(currentDate)) {
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    while (activityDates.contains(currentDate)) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
  }

  final syllabusPercent =
      totalChapters > 0 ? (completedChapters / totalChapters * 100).round() : 0;

  return {
    'totalChapters': totalChapters,
    'completedChapters': completedChapters,
    'focusMinutes': focusMinutes,
    'streak': streak,
    'syllabusPercent': syllabusPercent,
  };
}
