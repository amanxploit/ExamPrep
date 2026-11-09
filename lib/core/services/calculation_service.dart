import 'package:flutter/material.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';
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
      weights: normalizedWeights,
      hasRevisionData: hasRevisionData,
      hasPracticeData: hasPracticeData,
    );
  }

  /// Calculates SM-2 next interval based on review rating.
  /// Intervals: 1, 3, 7, 14, 30 days (configurable)
  SM2Result calculateSM2Interval({
    required ReviewRating rating,
    required int currentIntervalDays,
    required double currentEaseFactor,
    required int currentRepetitions,
    List<int> intervals = const [1, 3, 7, 14, 30],
  }) {
    // SM-2 algorithm
    double newEaseFactor = currentEaseFactor;
    int newRepetitions = currentRepetitions;
    int newIntervalDays = currentIntervalDays;

    final quality = rating.quality;

    if (rating == ReviewRating.again) {
      // Reset to first interval
      newRepetitions = 0;
      newIntervalDays = intervals.first;
    } else {
      // Update ease factor based on quality (0-5)
      newEaseFactor = currentEaseFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (newEaseFactor < 1.3) newEaseFactor = 1.3;

      newRepetitions = currentRepetitions + 1;

      if (newRepetitions == 1) {
        newIntervalDays = intervals[0];
      } else if (newRepetitions == 2) {
        newIntervalDays = intervals[1];
      } else {
        // For repetitions >= 3, use ease factor to determine interval
        final baseInterval = intervals[newRepetitions - 1 < intervals.length ? newRepetitions - 1 : intervals.length - 1];
        newIntervalDays = (baseInterval * newEaseFactor).round();
        
        // Cap at maximum interval
        if (newIntervalDays > intervals.last) {
          newIntervalDays = intervals.last;
        }
      }
    }

    final nextDueAt = DateTime.now().dateOnly.add(Duration(days: newIntervalDays));

    return SM2Result(
      newIntervalDays: newIntervalDays,
      newEaseFactor: newEaseFactor,
      newRepetitions: newRepetitions,
      nextDueAt: nextDueAt,
    );
  }

  /// Creates a new revision item for a chapter with initial SM-2 parameters.
  RevisionItem createRevisionItem({
    required String userId,
    required String chapterId,
    required String title,
    List<int> intervals = const [1, 3, 7, 14, 30],
  }) {
    final initialDueAt = DateTime.now().dateOnly.add(Duration(days: intervals.first));
    return RevisionItem(
      userId: userId,
      chapterId: chapterId,
      title: title,
      dueAt: initialDueAt,
      intervalDays: intervals.first,
      easeFactor: 2.5,
      repetitions: 0,
      status: RevisionStatus.pending,
    );
  }

  /// Updates a revision item after a review.
  RevisionItem updateRevisionItemAfterReview({
    required RevisionItem item,
    required ReviewRating rating,
    required List<int> intervals,
  }) {
    final result = calculateSM2Interval(
      rating: rating,
      currentIntervalDays: item.intervalDays,
      currentEaseFactor: item.easeFactor,
      currentRepetitions: item.repetitions,
      intervals: intervals,
    );

    return item.copyWith(
      dueAt: result.nextDueAt,
      intervalDays: result.newIntervalDays,
      easeFactor: result.newEaseFactor,
      repetitions: result.newRepetitions,
      status: rating == ReviewRating.again ? RevisionStatus.pending : RevisionStatus.completed,
    );
  }

  /// Creates a revision review record preserving history.
  RevisionReview createRevisionReview({
    required String userId,
    required RevisionItem item,
    required ReviewRating rating,
    Duration? timeSpent,
    String? notes,
    List<int> intervals = const [1, 3, 7, 14, 30],
  }) {
    final result = calculateSM2Interval(
      rating: rating,
      currentIntervalDays: item.intervalDays,
      currentEaseFactor: item.easeFactor,
      currentRepetitions: item.repetitions,
      intervals: intervals,
    );

    return RevisionReview(
      userId: userId,
      revisionItemId: item.id,
      rating: rating,
      reviewedAt: DateTime.now(),
      previousIntervalDays: item.intervalDays,
      previousEaseFactor: item.easeFactor,
      previousRepetitions: item.repetitions,
      newIntervalDays: result.newIntervalDays,
      newEaseFactor: result.newEaseFactor,
      newRepetitions: result.newRepetitions,
      nextDueAt: result.nextDueAt,
      timeSpent: timeSpent,
      notes: notes,
    );
  }

  /// Calculates revision health (percentage of due/overdue items reviewed on time).
  double calculateRevisionHealth(String examId) {
    final items = _repository.getRevisionItemsForExam(examId);
    if (items.isEmpty) return 0.0;

    final now = DateTime.now().dateOnly;
    final dueItems = items.where((i) => i.dueAt.dateOnly.compareTo(now) <= 0 && i.status == RevisionStatus.pending).length;
    final overdueItems = items.where((i) => i.dueAt.dateOnly.compareTo(now) < 0 && i.status == RevisionStatus.pending).length;
    final completedOnTime = items.where((i) => i.status == RevisionStatus.completed).length;

    final totalDue = dueItems + overdueItems + completedOnTime;
    if (totalDue == 0) return 1.0;

    // Health is based on how many items are not overdue
    return ((totalDue - overdueItems) / totalDue).clamp(0.0, 1.0);
  }

  /// Generates a daily study plan based on available time, priorities, and due revisions.
  DailyPlanResult generateDailyPlan({
    required String examId,
    required String userId,
    required int availableMinutes,
    required int dailyGoalMinutes,
    required int completedTodayMinutes,
    required List<DailyPlanTask> existingTasks,
    int maxOverdueRevisions = 3,
    int maxDueRevisions = 5,
    int focusBlockMinutes = 25,
    int shortBreakMinutes = 5,
    int longBreakMinutes = 15,
    int sessionsBeforeLongBreak = 4,
  }) {
    final now = DateTime.now().dateOnly;
    final exam = _repository.getExam(examId);
    if (exam == null) {
      return DailyPlanResult(
        tasks: [],
        totalEstimatedMinutes: 0,
        availableMinutes: availableMinutes,
        workloadWarning: 'Exam not found',
        examDate: null,
      );
    }

    final daysUntilExam = now.daysUntil(exam.examDate);
    if (daysUntilExam < 0) {
      return DailyPlanResult(
        tasks: [],
        totalEstimatedMinutes: 0,
        availableMinutes: availableMinutes,
        workloadWarning: 'Exam has passed',
        examDate: exam.examDate,
      );
    }

    // Calculate remaining time budget
    final remainingMinutes = availableMinutes - completedTodayMinutes;
    if (remainingMinutes <= 0) {
      return DailyPlanResult(
        tasks: existingTasks,
        totalEstimatedMinutes: existingTasks.fold(0, (sum, t) => sum + t.estimatedMinutes),
        availableMinutes: availableMinutes,
        workloadWarning: 'No available time remaining for today',
        examDate: exam.examDate,
      );
    }

    final tasks = <DailyPlanTask>[];
    var remainingTime = remainingMinutes;
    int sortOrder = 0;

    // Get existing task IDs to prevent duplicates
    final existingSourceIds = existingTasks.where((t) => t.sourceId != null).map((t) => t.sourceId!).toSet();

    // 1. Add overdue revisions first (cap at maxOverdueRevisions)
    final overdueRevisions = _repository.getOverdueRevisionItems(examId)
        .where((r) => !existingSourceIds.contains(r.id))
        .take(maxOverdueRevisions)
        .toList();

    for (final revision in overdueRevisions) {
      if (remainingTime <= 0) break;
      final estimatedMinutes = focusBlockMinutes; // Use focus block for revisions
      if (estimatedMinutes <= remainingTime) {
        tasks.add(DailyPlanTask(
          userId: userId,
          date: now,
          title: 'Revision: ${revision.title}',
          description: 'Overdue revision (due ${revision.dueAt.formattedShort})',
          type: DailyPlanTaskType.revision,
          sourceId: revision.id,
          estimatedMinutes: estimatedMinutes,
          priorityScore: _calculateRevisionPriority(revision, daysUntilExam, isOverdue: true),
          sortOrder: sortOrder++,
        ));
        remainingTime -= estimatedMinutes;
      }
    }

    // 2. Add revisions due today (cap at maxDueRevisions)
    final dueTodayRevisions = _repository.getDueRevisionItems(examId)
        .where((r) => r.dueAt.dateOnly == now && !existingSourceIds.contains(r.id))
        .take(maxDueRevisions)
        .toList();

    for (final revision in dueTodayRevisions) {
      if (remainingTime <= 0) break;
      final estimatedMinutes = focusBlockMinutes;
      if (estimatedMinutes <= remainingTime) {
        tasks.add(DailyPlanTask(
          userId: userId,
          date: now,
          title: 'Revision: ${revision.title}',
          description: 'Due today',
          type: DailyPlanTaskType.revision,
          sourceId: revision.id,
          estimatedMinutes: estimatedMinutes,
          priorityScore: _calculateRevisionPriority(revision, daysUntilExam, isOverdue: false),
          sortOrder: sortOrder++,
        ));
        remainingTime -= estimatedMinutes;
      }
    }

    // 3. Rank incomplete chapters by priority
    final incompleteChapters = _getIncompleteChaptersWithPriority(examId, daysUntilExam, existingSourceIds);

    // 4. Add chapters until time runs out
    for (final chapter in incompleteChapters) {
      if (remainingTime <= 0) break;
      // Estimate minutes based on chapter difficulty or use focus block
      final estimatedMinutes = (chapter.estimatedMinutes > 0 ? chapter.estimatedMinutes : focusBlockMinutes * 2);
      if (estimatedMinutes <= remainingTime) {
        tasks.add(DailyPlanTask(
          userId: userId,
          date: now,
          title: 'Study: ${chapter.name}',
          description: chapter.description.isNotEmpty ? chapter.description : 'Study chapter',
          type: DailyPlanTaskType.studyChapter,
          sourceId: chapter.id,
          estimatedMinutes: estimatedMinutes,
          priorityScore: _calculateChapterPriority(chapter, daysUntilExam),
          sortOrder: sortOrder++,
        ));
        remainingTime -= estimatedMinutes;
      }
    }

    // 5. Add breaks between focus blocks
    final tasksWithBreaks = _addBreaks(tasks, focusBlockMinutes, shortBreakMinutes, longBreakMinutes, sessionsBeforeLongBreak);

    // Calculate workload warning
    final totalEstimatedMinutes = tasksWithBreaks.where((t) => t.type != DailyPlanTaskType.breakTime)
        .fold(0, (sum, t) => sum + t.estimatedMinutes);
    final totalRequiredMinutes = _estimateTotalRequiredMinutes(examId, daysUntilExam);
    String? workloadWarning;
    if (totalRequiredMinutes > availableMinutes * daysUntilExam) {
      final deficit = totalRequiredMinutes - (availableMinutes * daysUntilExam);
      workloadWarning = 'Workload warning: ${deficit} minutes of study cannot fit in remaining ${daysUntilExam} days. Consider increasing daily study time or adjusting goals.';
    }

    // Sort by priority score (highest first) then by sort order
    tasksWithBreaks.sort((a, b) {
      if (a.priorityScore != b.priorityScore) {
        return b.priorityScore.compareTo(a.priorityScore);
      }
      return a.sortOrder.compareTo(b.sortOrder);
    });

    // Re-assign sort order after sorting
    for (int i = 0; i < tasksWithBreaks.length; i++) {
      tasksWithBreaks[i] = tasksWithBreaks[i].copyWith(sortOrder: i);
    }

    return DailyPlanResult(
      tasks: tasksWithBreaks,
      totalEstimatedMinutes: totalEstimatedMinutes,
      availableMinutes: availableMinutes,
      workloadWarning: workloadWarning,
      examDate: exam.examDate,
    );
  }

  int _calculateRevisionPriority(RevisionItem revision, int daysUntilExam, {required bool isOverdue}) {
    int score = 0;
    if (isOverdue) score += 1000;
    score += (30 - daysUntilExam).clamp(0, 30) * 10; // Urgency based on exam proximity
    score += (revision.repetitions * 5); // More repetitions = higher priority to maintain
    return score;
  }

  int _calculateChapterPriority(Chapter chapter, int daysUntilExam) {
    int score = 0;
    score += (30 - daysUntilExam).clamp(0, 30) * 8; // Urgency
    score += (chapter.importance * 20); // User-set importance (1-5)
    score += (chapter.difficulty * 10); // Difficulty (1-5)
    if (chapter.isInProgress) score += 50; // In progress chapters get priority
    return score;
  }

  List<Chapter> _getIncompleteChaptersWithPriority(String examId, int daysUntilExam, Set<String> existingSourceIds) {
    final chapters = _repository.getAllChaptersForExam(examId)
        .where((c) => !c.isCompleted && !existingSourceIds.contains(c.id))
        .toList();
    
    // Sort by priority
    chapters.sort((a, b) => _calculateChapterPriority(b, daysUntilExam).compareTo(_calculateChapterPriority(a, daysUntilExam)));
    return chapters;
  }

  List<DailyPlanTask> _addBreaks(
    List<DailyPlanTask> tasks,
    int focusBlockMinutes,
    int shortBreakMinutes,
    int longBreakMinutes,
    int sessionsBeforeLongBreak,
  ) {
    final result = <DailyPlanTask>[];
    int focusSessionCount = 0;

    for (final task in tasks) {
      if (task.type == DailyPlanTaskType.studyChapter || task.type == DailyPlanTaskType.revision || task.type == DailyPlanTaskType.flashcard) {
        // Check if we need a break before this task
        if (focusSessionCount > 0) {
          if (focusSessionCount % sessionsBeforeLongBreak == 0) {
            result.add(DailyPlanTask(
              userId: task.userId,
              date: task.date,
              title: 'Long Break',
              description: 'Take a long break',
              type: DailyPlanTaskType.breakTime,
              estimatedMinutes: longBreakMinutes,
              sortOrder: result.length,
            ));
          } else {
            result.add(DailyPlanTask(
              userId: task.userId,
              date: task.date,
              title: 'Short Break',
              description: 'Take a short break',
              type: DailyPlanTaskType.breakTime,
              estimatedMinutes: shortBreakMinutes,
              sortOrder: result.length,
            ));
          }
        }
        focusSessionCount++;
      }
      result.add(task);
    }

    return result;
  }

  int _estimateTotalRequiredMinutes(String examId, int daysUntilExam) {
    final chapters = _repository.getAllChaptersForExam(examId)
        .where((c) => !c.isCompleted)
        .toList();
    
    int totalMinutes = 0;
    for (final chapter in chapters) {
      totalMinutes += chapter.estimatedMinutes > 0 ? chapter.estimatedMinutes : 50; // Default 50 min per chapter
    }
    
    // Add revision time (estimate 25 min per revision item due in remaining days)
    final revisionItems = _repository.getRevisionItemsForExam(examId);
    final upcomingRevisions = revisionItems.where((r) => r.status == RevisionStatus.pending).length;
    totalMinutes += upcomingRevisions * 25;
    
    return totalMinutes;
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

/// SM-2 calculation result
class SM2Result {
  final int newIntervalDays;
  final double newEaseFactor;
  final int newRepetitions;
  final DateTime nextDueAt;

  SM2Result({
    required this.newIntervalDays,
    required this.newEaseFactor,
    required this.newRepetitions,
    required this.nextDueAt,
  });
}

/// Daily plan generation result
class DailyPlanResult {
  final List<DailyPlanTask> tasks;
  final int totalEstimatedMinutes;
  final int availableMinutes;
  final String? workloadWarning;
  final DateTime? examDate;

  DailyPlanResult({
    required this.tasks,
    required this.totalEstimatedMinutes,
    required this.availableMinutes,
    this.workloadWarning,
    this.examDate,
  });

  int get breakMinutes => tasks.where((t) => t.type == DailyPlanTaskType.breakTime)
      .fold(0, (sum, t) => sum + t.estimatedMinutes);

  int get studyMinutes => totalEstimatedMinutes;

  double get utilizationPercent => availableMinutes == 0 ? 0.0 : (totalEstimatedMinutes + breakMinutes) / availableMinutes;

  bool get hasWorkloadWarning => workloadWarning != null;
}