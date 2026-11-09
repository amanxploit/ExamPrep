import 'package:flutter/material.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/core/extensions/extensions.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';

/// Single authoritative service for all exam preparation calculations.
/// All UI components and providers must delegate to this service.
class CalculationService {
  final ExamRepository _repository;

  CalculationService(this._repository);

  /// Calculates chapter coverage for an exam.
  ChapterCoverage calculateChapterCoverage(Exam exam) {
    final chapters = _repository.getAllChaptersForExam(exam.id);
    final total = chapters.length;
    final completed = chapters.where((c) => c.isCompleted).length;
    final remaining = total - completed;
    final percent = total == 0 ? 0.0 : completed / total;

    return ChapterCoverage(
      total: total,
      completed: completed,
      remaining: remaining,
      percent: percent,
    );
  }

  /// Calculates subject progress for an exam.
  SubjectProgress calculateSubjectProgress(Subject subject) {
    final chapters = _repository.getChaptersForSubject(subject.id);
    final total = chapters.length;
    final completed = chapters.where((c) => c.isCompleted).length;
    final remaining = total - completed;
    final percent = total == 0 ? 0.0 : completed / total;

    return SubjectProgress(
      subjectId: subject.id,
      subjectName: subject.name,
      subjectColor: subject.color,
      totalChapters: total,
      completedChapters: completed,
      remainingChapters: remaining,
      percent: percent,
    );
  }

  /// Calculates subject progress for all subjects in an exam.
  List<SubjectProgress> calculateAllSubjectProgress(Exam exam) {
    final subjects = _repository.getSubjectsForExam(exam.id);
    return subjects.map((s) => calculateSubjectProgress(s)).toList();
  }

  /// Calculates study duration from completed focus sessions.
  StudyDuration calculateStudyDuration(List<FocusSession> sessions) {
    final focusSessions = sessions.where((s) => s.type == SessionType.focus && s.completed);
    final totalMinutes = focusSessions.fold(0, (sum, s) => sum + s.durationMinutes);
    return StudyDuration.fromMinutes(totalMinutes);
  }

  /// Calculates today's study minutes from focus sessions.
  int calculateTodayFocusMinutes(List<FocusSession> sessions) {
    final today = DateTime.now().dateOnly;
    return sessions
        .where((s) => s.type == SessionType.focus && s.completed && s.startedAt.dateOnly == today)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  /// Calculates daily goal progress.
  DailyGoalProgress calculateDailyGoalProgress({
    required int actualMinutes,
    required int targetMinutes,
  }) {
    if (targetMinutes <= 0) {
      return DailyGoalProgress(
        actualMinutes: actualMinutes,
        targetMinutes: targetMinutes,
        percent: 0.0,
        remainingMinutes: 0,
        isGoalMet: false,
      );
    }

    final percent = (actualMinutes / targetMinutes).clamp(0.0, 1.0);
    final remaining = (targetMinutes - actualMinutes).clamp(0, targetMinutes);
    final isGoalMet = actualMinutes >= targetMinutes;

    return DailyGoalProgress(
      actualMinutes: actualMinutes,
      targetMinutes: targetMinutes,
      percent: percent,
      remainingMinutes: remaining,
      isGoalMet: isGoalMet,
    );
  }

  /// Calculates daily and weekly study totals.
  WeeklyTotals calculateWeeklyTotals({
    required List<FocusSession> sessions,
    required List<Chapter> chapters,
    DateTime? referenceDate,
  }) {
    final refDate = referenceDate ?? DateTime.now();
    final last7Days = _getLast7Days(refDate);
    final focusSessions = sessions.where((s) => s.type == SessionType.focus && s.completed).toList();

    final dailyChapters = <DateTime, int>{};
    final dailyMinutes = <DateTime, int>{};

    for (final day in last7Days) {
      dailyChapters[day] = chapters
          .where((c) => c.isCompleted && c.completedAt != null && c.completedAt!.dateOnly == day)
          .length;
      dailyMinutes[day] = focusSessions
          .where((s) => s.startedAt.dateOnly == day)
          .fold(0, (sum, s) => sum + s.durationMinutes);
    }

    final totalChapters = dailyChapters.values.fold(0, (a, b) => a + b);
    final totalMinutes = dailyMinutes.values.fold(0, (a, b) => a + b);

    return WeeklyTotals(
      dailyChapters: dailyChapters,
      dailyMinutes: dailyMinutes,
      labels: last7Days.map((d) => d.weekdayInitial).toList(),
      totalChapters: totalChapters,
      totalMinutes: totalMinutes,
    );
  }

  /// Calculates current and longest study streaks.
  StreakInfo calculateStreaks({
    required List<FocusSession> sessions,
    required List<Chapter> chapters,
    int minimumQualifyingMinutes = 1,
  }) {
    final focusSessions = sessions.where((s) => s.type == SessionType.focus && s.completed && s.durationMinutes >= minimumQualifyingMinutes).toList();
    final completedChapters = chapters.where((c) => c.isCompleted && c.completedAt != null).toList();

    final activityDates = <DateTime>{};
    for (final session in focusSessions) {
      activityDates.add(session.startedAt.dateOnly);
    }
    for (final chapter in completedChapters) {
      activityDates.add(chapter.completedAt!.dateOnly);
    }

    if (activityDates.isEmpty) {
      return StreakInfo(current: 0, longest: 0);
    }

    final sortedDates = activityDates.toList()..sort();
    var currentStreak = 0;
    var longestStreak = 1;
    var currentStreakLocal = 1;

    // Check current streak (ending today or yesterday)
    var checkDate = DateTime.now().dateOnly;
    if (!activityDates.contains(checkDate)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    while (activityDates.contains(checkDate)) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Calculate longest streak
    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreakLocal++;
        if (currentStreakLocal > longestStreak) {
          longestStreak = currentStreakLocal;
        }
      } else {
        currentStreakLocal = 1;
      }
    }

    return StreakInfo(current: currentStreak, longest: longestStreak);
  }

  /// Calculates exam countdown.
  ExamCountdown calculateExamCountdown(Exam exam) {
    final now = DateTime.now();
    final examDate = exam.examDate;
    final isPast = examDate.isBefore(now.dateOnly);
    final daysLeft = isPast ? 0 : now.daysUntil(examDate);

    return ExamCountdown(
      examId: exam.id,
      examName: exam.name,
      examDate: examDate,
      daysLeft: daysLeft,
      isPast: isPast,
    );
  }

  /// Calculates consistency score (active study days in last 14 days / 14).
  double calculateConsistencyScore(List<FocusSession> sessions, List<Chapter> chapters) {
    final last14Days = _getLast14Days(DateTime.now());
    final activityDates = <DateTime>{};

    for (final session in sessions.where((s) => s.type == SessionType.focus && s.completed)) {
      if (last14Days.contains(session.startedAt.dateOnly)) {
        activityDates.add(session.startedAt.dateOnly);
      }
    }
    for (final chapter in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
      if (last14Days.contains(chapter.completedAt!.dateOnly)) {
        activityDates.add(chapter.completedAt!.dateOnly);
      }
    }

    final activeDays = activityDates.length;
    return (activeDays / 14 * 100).roundToDouble();
  }

  /// Calculates milestone progress.
  List<MilestoneProgress> calculateMilestones({
    required int totalFocusMinutes,
    required int totalSessions,
    required int longestStreak,
    required int completedChapters,
  }) {
    final milestones = <MilestoneProgress>[];

    // Focus minutes milestones
    milestones.add(MilestoneProgress(
      id: 'focus_600',
      name: '600 Focus Minutes',
      description: 'Complete 600 minutes of focused study',
      currentValue: totalFocusMinutes,
      targetValue: 600,
      unit: 'min',
    ));

    // Streak milestones
    milestones.add(MilestoneProgress(
      id: 'streak_7',
      name: '7-Day Streak',
      description: 'Study 7 days in a row',
      currentValue: longestStreak,
      targetValue: 7,
      unit: 'days',
    ));

    // Chapter completion milestones
    milestones.add(MilestoneProgress(
      id: 'chapters_50',
      name: '50 Chapters',
      description: 'Complete 50 chapters',
      currentValue: completedChapters,
      targetValue: 50,
      unit: 'chapters',
    ));

    return milestones;
  }

  /// Calculates weighted readiness score (if all components have data).
  ReadinessScore? calculateReadinessScore({
    required ChapterCoverage coverage,
    required double revisionHealth,
    required double consistency,
    double? practiceScore,
  }) {
    final hasRevisionData = revisionHealth > 0;
    final hasPracticeData = practiceScore != null && practiceScore > 0;
    
    // Return null if no meaningful data
    if (coverage.percent == 0 && revisionHealth == 0 && consistency == 0 && !hasPracticeData) {
      return null;
    }

    final weights = <String, double>{};
    weights['coverage'] = 0.50;
    weights['revision'] = hasRevisionData ? 0.20 : 0.0;
    weights['consistency'] = 0.15;
    weights['practice'] = hasPracticeData ? 0.15 : 0.0;

    final totalWeight = weights.values.fold(0.0, (a, b) => a + b);
    if (totalWeight == 0) return null;

    final normalizedWeights = weights.map((k, v) => MapEntry(k, v / totalWeight));

    final score = (coverage.percent * (normalizedWeights['coverage'] ?? 0)) +
        (revisionHealth * (normalizedWeights['revision'] ?? 0)) +
        (consistency / 100 * (normalizedWeights['consistency'] ?? 0)) +
        ((practiceScore ?? 0) * (normalizedWeights['practice'] ?? 0));

    return ReadinessScore(
      score: (score * 100).round(),
      weights: normalizedWeights, // Return normalized weights
      hasRevisionData: hasRevisionData,
      hasPracticeData: hasPracticeData,
    );
  }

  List<DateTime> _getLast7Days(DateTime refDate) {
    final end = refDate.dateOnly;
    return List.generate(7, (i) => end.subtract(Duration(days: 6 - i)));
  }

  List<DateTime> _getLast14Days(DateTime refDate) {
    final end = refDate.dateOnly;
    return List.generate(14, (i) => end.subtract(Duration(days: 13 - i)));
  }
}

/// Result objects for calculations

class ChapterCoverage {
  final int total;
  final int completed;
  final int remaining;
  final double percent;

  ChapterCoverage({
    required this.total,
    required this.completed,
    required this.remaining,
    required this.percent,
  });
}

class SubjectProgress {
  final String subjectId;
  final String subjectName;
  final Color subjectColor;
  final int totalChapters;
  final int completedChapters;
  final int remainingChapters;
  final double percent;

  SubjectProgress({
    required this.subjectId,
    required this.subjectName,
    required this.subjectColor,
    required this.totalChapters,
    required this.completedChapters,
    required this.remainingChapters,
    required this.percent,
  });
}

class StudyDuration {
  final int totalMinutes;
  final int hours;
  final int minutes;

  StudyDuration._({
    required this.totalMinutes,
    required this.hours,
    required this.minutes,
  });

  factory StudyDuration.fromMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return StudyDuration._(
      totalMinutes: minutes,
      hours: hours,
      minutes: remainingMinutes,
    );
  }

  String get formatted {
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }
}

class DailyGoalProgress {
  final int actualMinutes;
  final int targetMinutes;
  final double percent;
  final int remainingMinutes;
  final bool isGoalMet;

  DailyGoalProgress({
    required this.actualMinutes,
    required this.targetMinutes,
    required this.percent,
    required this.remainingMinutes,
    required this.isGoalMet,
  });
}

class WeeklyTotals {
  final Map<DateTime, int> dailyChapters;
  final Map<DateTime, int> dailyMinutes;
  final List<String> labels;
  final int totalChapters;
  final int totalMinutes;

  WeeklyTotals({
    required this.dailyChapters,
    required this.dailyMinutes,
    required this.labels,
    required this.totalChapters,
    required this.totalMinutes,
  });
}

class StreakInfo {
  final int current;
  final int longest;

  StreakInfo({required this.current, required this.longest});
}

class ExamCountdown {
  final String examId;
  final String examName;
  final DateTime examDate;
  final int daysLeft;
  final bool isPast;

  ExamCountdown({
    required this.examId,
    required this.examName,
    required this.examDate,
    required this.daysLeft,
    required this.isPast,
  });

  String get displayText {
    if (isPast) return 'Exam passed';
    if (daysLeft == 0) return 'Today';
    if (daysLeft == 1) return '1 day left';
    return '$daysLeft days left';
  }
}

class MilestoneProgress {
  final String id;
  final String name;
  final String description;
  final int currentValue;
  final int targetValue;
  final String unit;

  MilestoneProgress({
    required this.id,
    required this.name,
    required this.description,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
  });

  double get percent => targetValue == 0 ? 0.0 : (currentValue / targetValue).clamp(0.0, 1.0);
  bool get isCompleted => currentValue >= targetValue;
}

class ReadinessScore {
  final int score;
  final Map<String, double> weights;
  final bool hasRevisionData;
  final bool hasPracticeData;

  ReadinessScore({
    required this.score,
    required this.weights,
    required this.hasRevisionData,
    required this.hasPracticeData,
  });
}