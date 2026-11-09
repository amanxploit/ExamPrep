import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';

part 'progress_providers.g.dart';

/// Overall chapter coverage from CalculationService
@riverpod
ChapterCoverage overallProgress(OverallProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) {
    return ChapterCoverage(total: 0, completed: 0, remaining: 0, percent: 0.0);
  }

  return calc.calculateChapterCoverage(exam);
}

/// Weekly chapters from CalculationService
@riverpod
Map<DateTime, int> weeklyChaptersProgress(WeeklyChaptersProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) {
    return {};
  }

  final chapters =
      ref.watch(examRepositoryProvider).getAllChaptersForExam(exam.id);
  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);

  final totals = calc.calculateWeeklyTotals(
    sessions: sessions,
    chapters: chapters,
  );

  return totals.dailyChapters;
}

/// Weekly focus minutes from CalculationService
@riverpod
Map<DateTime, int> weeklyFocusMinutesProgress(
    WeeklyFocusMinutesProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) {
    return {};
  }

  final chapters =
      ref.watch(examRepositoryProvider).getAllChaptersForExam(exam.id);
  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);

  final totals = calc.calculateWeeklyTotals(
    sessions: sessions,
    chapters: chapters,
  );

  return totals.dailyMinutes;
}

/// Weekly labels (last 7 days)
@riverpod
List<String> weeklyLabelsProgress(WeeklyLabelsProgressRef ref) {
  return AppDateUtils.last7DayLabels();
}

/// Summary stats from CalculationService
@riverpod
SummaryStats summaryStats(SummaryStatsRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) {
    return SummaryStats(
      totalFocusMinutes: 0,
      totalSessions: 0,
      longestStreak: 0,
      currentStreak: 0,
      totalChaptersCompleted: 0,
      consistencyScore: 0.0,
    );
  }

  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);
  final chapters =
      ref.watch(examRepositoryProvider).getAllChaptersForExam(exam.id);

  final duration = calc.calculateStudyDuration(sessions);
  final streak = calc.calculateStreaks(sessions: sessions, chapters: chapters);
  final consistency = calc.calculateConsistencyScore(sessions, chapters);
  final totalChaptersCompleted = chapters.where((c) => c.isCompleted).length;

  return SummaryStats(
    totalFocusMinutes: duration.totalMinutes,
    totalSessions: sessions.where((s) => s.type == SessionType.focus).length,
    longestStreak: streak.longest,
    currentStreak: streak.current,
    totalChaptersCompleted: totalChaptersCompleted,
    consistencyScore: consistency,
  );
}

/// Subject progress list
@riverpod
List<SubjectProgress> subjectProgressList(SubjectProgressListRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return [];

  return calc.calculateAllSubjectProgress(exam);
}

/// Exam countdown
@riverpod
ExamCountdown examCountdown(ExamCountdownRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) {
    return ExamCountdown(
      examId: '',
      examName: '',
      examDate: DateTime.now(),
      daysLeft: 0,
      isPast: false,
    );
  }

  return calc.calculateExamCountdown(exam);
}

/// Milestones
@riverpod
List<MilestoneProgress> milestones(MilestonesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return [];

  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);
  final chapters =
      ref.watch(examRepositoryProvider).getAllChaptersForExam(exam.id);

  final duration = calc.calculateStudyDuration(sessions);
  final streak = calc.calculateStreaks(sessions: sessions, chapters: chapters);
  final totalChaptersCompleted = chapters.where((c) => c.isCompleted).length;

  return calc.calculateMilestones(
    totalFocusMinutes: duration.totalMinutes,
    totalSessions: sessions.where((s) => s.type == SessionType.focus).length,
    longestStreak: streak.longest,
    completedChapters: totalChaptersCompleted,
  );
}

/// Readiness score
@riverpod
ReadinessScore? readinessScore(ReadinessScoreRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return null;

  final coverage = calc.calculateChapterCoverage(exam);
  final revisionHealth = calc.calculateRevisionHealth(exam.id);
  final consistency = calc.calculateConsistencyScore(
    ref.watch(examRepositoryProvider).getCompletedSessions(exam.id),
    ref.watch(examRepositoryProvider).getAllChaptersForExam(exam.id),
  );

  return calc.calculateReadinessScore(
    coverage: coverage,
    revisionHealth: revisionHealth,
    consistency: consistency,
    practiceScore: null,
  );
}

/// Today's focus minutes
@riverpod
int todayFocusMinutes(TodayFocusMinutesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return 0;

  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);

  return calc.calculateTodayFocusMinutes(sessions);
}

/// Today's focus progress
@riverpod
double todayFocusProgress(TodayFocusProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return 0.0;

  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);
  final goal = exam.dailyGoalMinutes;

  final minutes = calc.calculateTodayFocusMinutes(sessions);
  return calc
      .calculateDailyGoalProgress(
        actualMinutes: minutes,
        targetMinutes: goal,
      )
      .percent;
}

/// Daily goal minutes
@riverpod
int dailyGoalMinutes(DailyGoalMinutesRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  return exam?.dailyGoalMinutes ?? 120;
}

/// Time per subject (focus minutes per subject)
@riverpod
Map<String, int> timePerSubject(TimePerSubjectRef ref) {
  final exam = ref.watch(activeExamProvider).value;

  if (exam == null) return {};

  final sessions =
      ref.watch(examRepositoryProvider).getCompletedSessions(exam.id);
  final subjects =
      ref.watch(examRepositoryProvider).getSubjectsForExam(exam.id);

  final subjectMap = <String, int>{};

  for (final subject in subjects) {
    final subjectChapters =
        ref.watch(examRepositoryProvider).getChaptersForSubject(subject.id);
    final subjectChapterIds = subjectChapters.map((c) => c.id).toSet();

    // Note: This assumes sessions are linked to chapters somehow
    // For now, we'll compute based on chapters completed per subject
    // A more accurate implementation would link sessions to subjects
    final completedInSubject =
        subjectChapters.where((c) => c.isCompleted).length;
    // Estimate 50 min per chapter
    subjectMap[subject.name] = completedInSubject * 50;
  }

  return subjectMap;
}

/// Due revisions count
@riverpod
int dueRevisionsCount(DueRevisionsCountRef ref) {
  final exam = ref.watch(activeExamProvider).value;

  if (exam == null) return 0;

  final repo = ref.watch(examRepositoryProvider);
  final now = DateTime.now().dateOnly;

  return repo
      .getRevisionItemsForExam(exam.id)
      .where((r) =>
          r.dueAt.dateOnly.compareTo(now) <= 0 &&
          r.status == RevisionStatus.pending)
      .length;
}

/// Overdue revisions count
@riverpod
int overdueRevisionsCount(OverdueRevisionsCountRef ref) {
  final exam = ref.watch(activeExamProvider).value;

  if (exam == null) return 0;

  final repo = ref.watch(examRepositoryProvider);
  final now = DateTime.now().dateOnly;

  return repo
      .getRevisionItemsForExam(exam.id)
      .where((r) =>
          r.dueAt.dateOnly.compareTo(now) < 0 &&
          r.status == RevisionStatus.pending)
      .length;
}

/// Revision health
@riverpod
double revisionHealthProgress(RevisionHealthProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final calc = ref.watch(calculationServiceProvider);

  if (exam == null) return 0.0;

  return calc.calculateRevisionHealth(exam.id);
}

/// Subject status map
@riverpod
Map<String, SubjectStatus> subjectStatusMap(SubjectStatusMapRef ref) {
  final exam = ref.watch(activeExamProvider).value;

  if (exam == null) return {};

  final subjects =
      ref.watch(examRepositoryProvider).getSubjectsForExam(exam.id);
  final status = <String, SubjectStatus>{};

  for (final subject in subjects) {
    final chapters =
        ref.watch(examRepositoryProvider).getChaptersForSubject(subject.id);
    if (chapters.isEmpty) {
      status[subject.id] = SubjectStatus.onTrack;
      continue;
    }

    final completed = chapters.where((c) => c.isCompleted).length;
    final total = chapters.length;
    final completedRatio = completed / total;

    final daysSinceCreated =
        DateTime.now().dateOnly.difference(exam.createdAt.dateOnly).inDays;
    final totalDays = exam.daysLeft + daysSinceCreated;
    final expectedRatio = totalDays > 0 ? daysSinceCreated / totalDays : 1.0;

    status[subject.id] = completedRatio >= expectedRatio
        ? SubjectStatus.onTrack
        : SubjectStatus.behind;
  }

  return status;
}

/// Subject status enum
enum SubjectStatus {
  onTrack,
  behind,
}

/// Summary stats data class
class SummaryStats {
  final int totalFocusMinutes;
  final int totalSessions;
  final int longestStreak;
  final int currentStreak;
  final int totalChaptersCompleted;
  final double consistencyScore;

  SummaryStats({
    required this.totalFocusMinutes,
    required this.totalSessions,
    required this.longestStreak,
    required this.currentStreak,
    required this.totalChaptersCompleted,
    required this.consistencyScore,
  });
}
