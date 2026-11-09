import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'home_providers.g.dart';

// Active exam provider
@riverpod
Stream<Exam?> activeExam(ActiveExamRef ref) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.watchActiveExam();
}

// Days left for active exam
@riverpod
int daysLeft(DaysLeftRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  if (exam == null) return 0;
  return exam.daysLeft;
}

// Total chapters for active exam
@riverpod
int totalChapters(TotalChaptersRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  if (exam == null) return 0;
  
  final repo = ref.watch(examRepositoryProvider);
  final chapters = repo.getAllChaptersForExam(exam.id);
  return chapters.length;
}

// Completed chapters for active exam
@riverpod
int completedChapters(CompletedChaptersRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  if (exam == null) return 0;
  
  final repo = ref.watch(examRepositoryProvider);
  final chapters = repo.getAllChaptersForExam(exam.id);
  return chapters.where((c) => c.isCompleted).length;
}

// Remaining chapters
@riverpod
int remainingChapters(RemainingChaptersRef ref) {
  final total = ref.watch(totalChaptersProvider);
  final completed = ref.watch(completedChaptersProvider);
  return total - completed;
}

// Percent prepared
@riverpod
double percentPrepared(PercentPreparedRef ref) {
  final total = ref.watch(totalChaptersProvider);
  if (total == 0) return 0.0;
  final completed = ref.watch(completedChaptersProvider);
  return completed / total;
}

// Today's focus minutes
@riverpod
int todayFocusMinutes(TodayFocusMinutesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  final sessions = repo.getTodaySessions(exam?.id);
  return sessions
      .where((s) => s.type == SessionType.focus)
      .fold(0, (sum, s) => sum + s.durationMinutes);
}

// Daily goal minutes
@riverpod
int dailyGoalMinutes(DailyGoalMinutesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  return exam?.dailyGoalMinutes ?? 120;
}

// Today's focus progress (0-1)
@riverpod
double todayFocusProgress(TodayFocusProgressRef ref) {
  final goal = ref.watch(dailyGoalMinutesProvider);
  if (goal == 0) return 0.0;
  final minutes = ref.watch(todayFocusMinutesProvider);
  return (minutes / goal).clamp(0.0, 1.0);
}

// Current streak
@riverpod
int currentStreak(CurrentStreakRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) return 0;
  
  final sessions = repo.getCompletedSessions(exam.id);
  final chapters = repo.getAllChaptersForExam(exam.id);
  
  // Get all dates with activity
  final activityDates = <DateTime>{};
  
  for (final session in sessions) {
    if (session.type == SessionType.focus) {
      activityDates.add(session.startedAt.dateOnly);
    }
  }
  
  for (final chapter in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
    activityDates.add(chapter.completedAt!.dateOnly);
  }
  
  if (activityDates.isEmpty) return 0;
  
  // Check streak from today backwards
  var currentDate = DateTime.now().dateOnly;
  var streak = 0;
  
  // If today has activity, count it
  // If not, check yesterday
  if (!activityDates.contains(currentDate)) {
    currentDate = currentDate.subtract(const Duration(days: 1));
  }
  
  while (activityDates.contains(currentDate)) {
    streak++;
    currentDate = currentDate.subtract(const Duration(days: 1));
  }
  
  return streak;
}

// Longest streak
@riverpod
int longestStreak(LongestStreakRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) return 0;
  
  final sessions = repo.getCompletedSessions(exam.id);
  final chapters = repo.getAllChaptersForExam(exam.id);
  
  final activityDates = <DateTime>{};
  
  for (final session in sessions) {
    if (session.type == SessionType.focus) {
      activityDates.add(session.startedAt.dateOnly);
    }
  }
  
  for (final chapter in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
    activityDates.add(chapter.completedAt!.dateOnly);
  }
  
  if (activityDates.isEmpty) return 0;
  
  final sortedDates = activityDates.toList()..sort();
  
  var maxStreak = 1;
  var currentStreak = 1;
  
  for (int i = 1; i < sortedDates.length; i++) {
    final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
    if (diff == 1) {
      currentStreak++;
      maxStreak = maxStreak < currentStreak ? currentStreak : maxStreak;
    } else {
      currentStreak = 1;
    }
  }
  
  return maxStreak;
}

// Total focus time for active exam
@riverpod
int totalFocusTime(TotalFocusTimeRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  final sessions = repo.getCompletedSessions(exam?.id);
  return sessions
      .where((s) => s.type == SessionType.focus)
      .fold(0, (sum, s) => sum + s.durationMinutes);
}

// Total sessions count
@riverpod
int sessionsCount(SessionsCountRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  final sessions = repo.getCompletedSessions(exam?.id);
  return sessions.where((s) => s.type == SessionType.focus).length;
}

// Weekly chapters (last 7 days)
@riverpod
List<int> weeklyChapters(WeeklyChaptersRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) return List.filled(7, 0);
  
  final chapters = repo.getAllChaptersForExam(exam.id)
      .where((c) => c.isCompleted && c.completedAt != null)
      .toList();
  
  final last7Days = AppDateUtils.last7Days();
  final result = <int>[];
  
  for (final day in last7Days) {
    final count = chapters.where((c) => c.completedAt!.dateOnly == day).length;
    result.add(count);
  }
  
  return result;
}

// Weekly focus minutes (last 7 days)
@riverpod
List<int> weeklyFocusMinutes(WeeklyFocusMinutesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  final sessions = repo.getCompletedSessions(exam?.id)
      .where((s) => s.type == SessionType.focus)
      .toList();
  
  final last7Days = AppDateUtils.last7Days();
  final result = <int>[];
  
  for (final day in last7Days) {
    final minutes = sessions
        .where((s) => s.startedAt.dateOnly == day)
        .fold(0, (sum, s) => sum + s.durationMinutes);
    result.add(minutes);
  }
  
  return result;
}

// Weekly day labels
@riverpod
List<String> weeklyLabels(WeeklyLabelsRef ref) {
  return AppDateUtils.last7DayLabels();
}

// Subject status for progress tracking
@riverpod
Map<String, String> subjectStatus(SubjectStatusRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) return {};
  
  final subjects = repo.getSubjectsForExam(exam.id);
  final status = <String, String>{};
  
  for (final subject in subjects) {
    final chapters = repo.getChaptersForSubject(subject.id);
    if (chapters.isEmpty) {
      status[subject.id] = 'on track';
      continue;
    }
    
    final completed = chapters.where((c) => c.isCompleted).length;
    final total = chapters.length;
    final completedRatio = completed / total;
    
    final daysSinceCreated = DateTime.now().dateOnly.difference(exam.createdAt.dateOnly).inDays;
    final totalDays = exam.daysLeft + daysSinceCreated;
    final expectedRatio = totalDays > 0 ? daysSinceCreated / totalDays : 1.0;
    
    status[subject.id] = completedRatio >= expectedRatio ? 'on track' : 'behind';
  }
  
  return status;
}

// Today's tasks
@riverpod
List<StudyTask> todayTasks(TodayTasksRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  if (exam == null) return [];
  return repo.getTodayTasks(exam.id);
}