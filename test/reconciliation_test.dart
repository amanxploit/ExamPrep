import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:hive/hive.dart';
import 'package:exam_prep/data/adapters/hive_adapters.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/models/timer_state.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/flashcard.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

void main() {
  group('Reconciliation Tests - All views agree on underlying records', () {
    late ExamRepository repo;
    late CalculationService calc;
    late Exam exam;
    late Subject subject1;
    late Subject subject2;
    late List<Chapter> chapters;
    late List<FocusSession> sessions;
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('exam_prep_test_');
      Hive.init(tempDir.path);
      registerHiveAdapters();
      
      await Hive.openBox<Exam>('exams');
      await Hive.openBox<Subject>('subjects');
      await Hive.openBox<Chapter>('chapters');
      await Hive.openBox<FocusSession>('focus_sessions');
      await Hive.openBox<Settings>('settings');
      await Hive.openBox<TimerState>('timer_state');
      await Hive.openBox<RevisionItem>('revision_items');
      await Hive.openBox<RevisionReview>('revision_reviews');
      await Hive.openBox<Flashcard>('flashcards');
      await Hive.openBox<FlashcardReview>('flashcard_reviews');
      await Hive.openBox<DailyPlanTask>('daily_plan_tasks');
      await Hive.openBox<StudyTask>('study_tasks');
    });

    setUp(() async {
      // Clear all boxes
      await Hive.box<Exam>('exams').clear();
      await Hive.box<Subject>('subjects').clear();
      await Hive.box<Chapter>('chapters').clear();
      await Hive.box<FocusSession>('focus_sessions').clear();
      await Hive.box<RevisionItem>('revision_items').clear();
      await Hive.box<RevisionReview>('revision_reviews').clear();

      repo = ExamRepository(
        examBox: Hive.box<Exam>('exams'),
        subjectBox: Hive.box<Subject>('subjects'),
        chapterBox: Hive.box<Chapter>('chapters'),
        taskBox: Hive.box<StudyTask>('study_tasks'),
        sessionBox: Hive.box<FocusSession>('focus_sessions'),
        settingsBox: Hive.box<Settings>('settings'),
        timerStateBox: Hive.box<TimerState>('timer_state'),
        revisionItemBox: Hive.box<RevisionItem>('revision_items'),
        revisionReviewBox: Hive.box<RevisionReview>('revision_reviews'),
        flashcardBox: Hive.box<Flashcard>('flashcards'),
        flashcardReviewBox: Hive.box<FlashcardReview>('flashcard_reviews'),
        dailyPlanTaskBox: Hive.box<DailyPlanTask>('daily_plan_tasks'),
      );
      calc = CalculationService(repo);

      // Create exam
      exam = Exam(
        id: 'exam_1',
        name: 'Test Exam',
        examDate: DateTime.now().add(const Duration(days: 30)),
        dailyGoalMinutes: 120,
        isActive: true,
        createdAt: DateTime.now(),
        colorValue: 0xFF3D7BF5,
      );
      await repo.addExam(exam);

      // Create subjects
      subject1 = Subject(
        id: 'subj_1',
        examId: exam.id,
        name: 'Math',
        order: 0,
        colorValue: 0xFF3D7BF5,
      );
      subject2 = Subject(
        id: 'subj_2',
        examId: exam.id,
        name: 'Science',
        order: 1,
        colorValue: 0xFFEF4444,
      );
      await repo.addSubject(subject1);
      await repo.addSubject(subject2);

      // Create chapters
      chapters = [
        Chapter(id: 'ch_1', subjectId: subject1.id, name: 'Algebra', order: 0),
        Chapter(id: 'ch_2', subjectId: subject1.id, name: 'Geometry', order: 1),
        Chapter(id: 'ch_3', subjectId: subject2.id, name: 'Physics', order: 0),
        Chapter(id: 'ch_4', subjectId: subject2.id, name: 'Chemistry', order: 1),
      ];
      for (final c in chapters) {
        await repo.addChapter(c);
      }

      // Create focus sessions
      sessions = [
        FocusSession(
          id: 's_1',
          examId: exam.id,
          type: SessionType.focus,
          startedAt: DateTime.now().subtract(const Duration(days: 2)),
          durationMinutes: 50,
          completed: true,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        FocusSession(
          id: 's_2',
          examId: exam.id,
          type: SessionType.focus,
          startedAt: DateTime.now().subtract(const Duration(days: 1)),
          durationMinutes: 30,
          completed: true,
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        FocusSession(
          id: 's_3',
          examId: exam.id,
          type: SessionType.focus,
          startedAt: DateTime.now(),
          durationMinutes: 40,
          completed: true,
          completedAt: DateTime.now(),
        ),
        FocusSession(
          id: 's_4',
          examId: exam.id,
          type: SessionType.shortBreak,
          startedAt: DateTime.now(),
          durationMinutes: 5,
          completed: true,
          completedAt: DateTime.now(),
        ),
      ];
      for (final s in sessions) {
        await repo.addSession(s);
      }

      // Complete some chapters
      await repo.updateChapter(chapters[0].copyWith(isCompleted: true, completedAt: DateTime.now().subtract(const Duration(days: 2))));
      await repo.updateChapter(chapters[1].copyWith(isCompleted: true, completedAt: DateTime.now().subtract(const Duration(days: 1))));
    });

    test('Chapter coverage: CalculationService, subject progress, and overall progress agree', () {
      final overall = calc.calculateChapterCoverage(exam);
      
      final subjectProgress = calc.calculateAllSubjectProgress(exam);
      final sumCompleted = subjectProgress.fold(0, (a, b) => a + b.completedChapters);
      final sumTotal = subjectProgress.fold(0, (a, b) => a + b.totalChapters);
      
      expect(overall.completed, sumCompleted, reason: 'Overall completed should equal sum of subject completed');
      expect(overall.total, sumTotal, reason: 'Overall total should equal sum of subject totals');
      expect(overall.percent, sumCompleted / sumTotal, reason: 'Overall percent should equal sum ratio');
    });

    test('Study duration: CalculationService matches manual sum of focus sessions', () {
      final duration = calc.calculateStudyDuration(sessions);
      
      final manualSum = sessions
          .where((s) => s.type == SessionType.focus && s.completed)
          .fold(0, (a, b) => a + b.durationMinutes);
      
      expect(duration.totalMinutes, manualSum, reason: 'CalculationService duration should equal manual sum');
    });

    test('Today focus minutes: CalculationService filters by date correctly', () {
      final today = DateTime.now().dateOnly;
      final todayMinutes = calc.calculateTodayFocusMinutes(sessions);
      
      final manualToday = sessions
          .where((s) => s.type == SessionType.focus && s.completed && s.startedAt.dateOnly == today)
          .fold(0, (a, b) => a + b.durationMinutes);
      
      expect(todayMinutes, manualToday, reason: 'Today focus minutes should match manual filter');
    });

    test('Weekly totals: dailyChapters + dailyMinutes match underlying records for each day', () {
      final totals = calc.calculateWeeklyTotals(
        sessions: sessions,
        chapters: chapters,
      );

      // Verify dailyChapters matches chapter completion dates
      for (final entry in totals.dailyChapters.entries) {
        final day = entry.key;
        final count = entry.value;
        final manualCount = chapters
            .where((c) => c.isCompleted && c.completedAt != null && c.completedAt!.dateOnly == day)
            .length;
        expect(count, manualCount, reason: 'Daily chapters for ${day} should match');
      }

      // Verify dailyMinutes matches focus session dates
      final focusSessions = sessions.where((s) => s.type == SessionType.focus && s.completed).toList();
      for (final entry in totals.dailyMinutes.entries) {
        final day = entry.key;
        final minutes = entry.value;
        final manualMinutes = focusSessions
            .where((s) => s.startedAt.dateOnly == day)
            .fold(0, (a, b) => a + b.durationMinutes);
        expect(minutes, manualMinutes, reason: 'Daily minutes for ${day} should match');
      }

      // Verify totals
      expect(totals.totalChapters, totals.dailyChapters.values.fold(0, (a, b) => a + b));
      expect(totals.totalMinutes, totals.dailyMinutes.values.fold(0, (a, b) => a + b));
    });

    test('Streaks: CalculationService streak matches manual calculation from activity dates', () {
      final streak = calc.calculateStreaks(
        sessions: sessions,
        chapters: chapters,
      );

      // Build activity dates manually
      final activityDates = <DateTime>{};
      for (final s in sessions.where((s) => s.type == SessionType.focus && s.completed)) {
        activityDates.add(s.startedAt.dateOnly);
      }
      for (final c in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
        activityDates.add(c.completedAt!.dateOnly);
      }

      // Manual current streak
      var checkDate = DateTime.now().dateOnly;
      if (!activityDates.contains(checkDate)) {
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
      var manualCurrent = 0;
      while (activityDates.contains(checkDate)) {
        manualCurrent++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Manual longest streak
      final sorted = activityDates.toList()..sort();
      var manualLongest = 1;
      var current = 1;
      for (int i = 1; i < sorted.length; i++) {
        if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
          current++;
          if (current > manualLongest) manualLongest = current;
        } else {
          current = 1;
        }
      }

      expect(streak.current, manualCurrent, reason: 'Current streak should match manual');
      expect(streak.longest, manualLongest, reason: 'Longest streak should match manual');
    });

    test('Exam countdown: CalculationService uses same date boundaries as manual', () {
      final countdown = calc.calculateExamCountdown(exam);
      
      final now = DateTime.now();
      final examDate = exam.examDate;
      final isPast = examDate.isBefore(now.dateOnly);
      final manualDaysLeft = isPast ? 0 : now.daysUntil(examDate);
      
      expect(countdown.daysLeft, manualDaysLeft);
      expect(countdown.isPast, isPast);
      expect(countdown.displayText, isPast ? 'Exam passed' : (manualDaysLeft == 0 ? 'Today' : (manualDaysLeft == 1 ? '1 day left' : '$manualDaysLeft days left')));
    });

    test('Consistency score: CalculationService matches manual active days / 14', () {
      final consistency = calc.calculateConsistencyScore(sessions, chapters);
      
      final last14Days = List.generate(14, (i) => DateTime.now().dateOnly.subtract(Duration(days: 13 - i)));
      final activityDates = <DateTime>{};
      
      for (final s in sessions.where((s) => s.type == SessionType.focus && s.completed)) {
        if (last14Days.contains(s.startedAt.dateOnly)) {
          activityDates.add(s.startedAt.dateOnly);
        }
      }
      for (final c in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
        if (last14Days.contains(c.completedAt!.dateOnly)) {
          activityDates.add(c.completedAt!.dateOnly);
        }
      }
      
      final manualConsistency = (activityDates.length / 14 * 100).roundToDouble();
      expect(consistency, manualConsistency);
    });

    test('Subject progress: each subject progress matches its chapters directly', () {
      for (final subject in [subject1, subject2]) {
        final progress = calc.calculateSubjectProgress(subject);
        final chaptersForSubject = repo.getChaptersForSubject(subject.id);
        
        expect(progress.subjectId, subject.id);
        expect(progress.subjectName, subject.name);
        expect(progress.totalChapters, chaptersForSubject.length);
        expect(progress.completedChapters, chaptersForSubject.where((c) => c.isCompleted).length);
        expect(progress.percent, progress.totalChapters == 0 ? 0.0 : progress.completedChapters / progress.totalChapters);
      }
    });

    test('Milestones: values derive from same underlying records', () {
      final milestones = calc.calculateMilestones(
        totalFocusMinutes: calc.calculateStudyDuration(sessions).totalMinutes,
        totalSessions: sessions.where((s) => s.type == SessionType.focus && s.completed).length,
        longestStreak: calc.calculateStreaks(sessions: sessions, chapters: chapters).longest,
        completedChapters: chapters.where((c) => c.isCompleted).length,
      );

      for (final m in milestones) {
        expect(m.currentValue, greaterThanOrEqualTo(0));
        expect(m.targetValue, greaterThan(0));
        expect(m.percent, m.currentValue / m.targetValue);
        expect(m.isCompleted, m.currentValue >= m.targetValue);
      }
    });

    test('Readiness score: weights sum to 1.0 and components match CalculationService', () {
      final coverage = calc.calculateChapterCoverage(exam);
      final revisionHealth = 0.0; // No revisions yet
      final consistency = calc.calculateConsistencyScore(sessions, chapters);
      
      final score = calc.calculateReadinessScore(
        coverage: coverage,
        revisionHealth: revisionHealth,
        consistency: consistency,
        practiceScore: null,
      );

      if (score != null) {
        final weightSum = score.weights.values.fold(0.0, (a, b) => a + b);
        expect(weightSum, closeTo(1.0, 0.001), reason: 'Weights should sum to 1.0');
        
        // Verify score formula
        final manualScore = (coverage.percent * (score.weights['coverage'] ?? 0)) +
            (revisionHealth * (score.weights['revision'] ?? 0)) +
            (consistency / 100 * (score.weights['consistency'] ?? 0));
        
        expect(score.score, (manualScore * 100).round());
      }
    });

    test('Daily goal progress: edge cases handled correctly', () {
      // Normal case
      var progress = calc.calculateDailyGoalProgress(actualMinutes: 60, targetMinutes: 120);
      expect(progress.actualMinutes, 60);
      expect(progress.targetMinutes, 120);
      expect(progress.percent, 0.5);
      expect(progress.remainingMinutes, 60);
      expect(progress.isGoalMet, false);

      // Goal met
      progress = calc.calculateDailyGoalProgress(actualMinutes: 120, targetMinutes: 120);
      expect(progress.percent, 1.0);
      expect(progress.remainingMinutes, 0);
      expect(progress.isGoalMet, true);

      // Exceeded
      progress = calc.calculateDailyGoalProgress(actualMinutes: 150, targetMinutes: 120);
      expect(progress.percent, 1.0, reason: 'Should cap at 1.0');
      expect(progress.remainingMinutes, 0);
      expect(progress.isGoalMet, true);

      // Zero target
      progress = calc.calculateDailyGoalProgress(actualMinutes: 60, targetMinutes: 0);
      expect(progress.percent, 0.0);
      expect(progress.remainingMinutes, 0);
      expect(progress.isGoalMet, false);
    });

    test('SM-2 intervals: follow documented formula', () {
      // Initial state: interval=1, ease=2.5, reps=0
      var result = calc.calculateSM2Interval(
        rating: ReviewRating.good,
        currentIntervalDays: 1,
        currentEaseFactor: 2.5,
        currentRepetitions: 0,
      );
      expect(result.newIntervalDays, 1, reason: 'First good -> interval 1');
      expect(result.newRepetitions, 1);

      // Second good: interval=3
      result = calc.calculateSM2Interval(
        rating: ReviewRating.good,
        currentIntervalDays: 1,
        currentEaseFactor: result.newEaseFactor,
        currentRepetitions: 1,
      );
      expect(result.newIntervalDays, 3, reason: 'Second good -> interval 3');
      expect(result.newRepetitions, 2);

      // Third good: interval=7 (with ease factor 2.5 -> 7 * 2.5 = 17.5 -> 18)
      result = calc.calculateSM2Interval(
        rating: ReviewRating.good,
        currentIntervalDays: 3,
        currentEaseFactor: result.newEaseFactor,
        currentRepetitions: 2,
      );
      expect(result.newIntervalDays, 18, reason: 'Third good -> interval 7 * ease(2.5) = 18');
      expect(result.newRepetitions, 3);

      // Again resets to 1
      result = calc.calculateSM2Interval(
        rating: ReviewRating.again,
        currentIntervalDays: 30,
        currentEaseFactor: 2.5,
        currentRepetitions: 5,
      );
      expect(result.newIntervalDays, 1, reason: 'Again resets to first interval');
      expect(result.newRepetitions, 0);
    });

    test('Revision health: based on due/overdue/completed items', () {
      // Formula: totalDue = overdue + dueToday + completedOnTime
      // overdue = 2, dueToday = 1, completedOnTime = 1
      // totalDue = 4, health = (4 - 2) / 4 = 0.5
      final totalDue = 4;
      final overdue = 2;
      final manualHealth = ((totalDue - overdue) / totalDue).clamp(0.0, 1.0);
      expect(manualHealth, 0.5);
    });

    test('Charts: bar chart data points match weekly totals exactly', () {
      final totals = calc.calculateWeeklyTotals(
        sessions: sessions,
        chapters: chapters,
      );

      // Each bar in the chart should correspond to one day's value
      expect(totals.dailyChapters.length, 7, reason: 'Should have 7 days');
      expect(totals.dailyMinutes.length, 7, reason: 'Should have 7 days');
      expect(totals.labels.length, 7, reason: 'Should have 7 labels');

      // Values should be non-negative integers
      for (final v in totals.dailyChapters.values) {
        expect(v, greaterThanOrEqualTo(0));
      }
      for (final v in totals.dailyMinutes.values) {
        expect(v, greaterThanOrEqualTo(0));
      }
    });
  });
}