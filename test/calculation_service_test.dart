import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class MockExamRepository extends Mock implements ExamRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Exam(
      id: 'test',
      name: 'Test Exam',
      examDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
      colorValue: 0xFFE9547B,
    ));
    registerFallbackValue(Subject(
      id: 'sub1',
      examId: 'exam1',
      name: 'Math',
      order: 0,
      colorValue: 0xFF34B98A,
    ));
    registerFallbackValue(Chapter(
      id: 'ch1',
      subjectId: 'sub1',
      name: 'Chapter 1',
      order: 0,
    ));
    registerFallbackValue(FocusSession(
      id: 'fs1',
      examId: 'exam1',
      type: SessionType.focus,
      startedAt: DateTime.now(),
      durationMinutes: 25,
    ));
    registerFallbackValue(Settings());
  });

  late MockExamRepository mockRepo;
  late CalculationService service;

  setUp(() {
    mockRepo = MockExamRepository();
    service = CalculationService(mockRepo);
  });

  group('CalculationService', () {
    group('calculateChapterCoverage', () {
      test('returns zero coverage when no chapters', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Test Exam',
          examDate: DateTime.now().add(const Duration(days: 30)),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        when(() => mockRepo.getAllChaptersForExam('exam1')).thenReturn([]);

        final coverage = service.calculateChapterCoverage(exam);

        expect(coverage.total, equals(0));
        expect(coverage.completed, equals(0));
        expect(coverage.remaining, equals(0));
        expect(coverage.percent, equals(0.0));
      });

      test('calculates coverage correctly with mixed chapters', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Test Exam',
          examDate: DateTime.now().add(const Duration(days: 30)),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true),
          Chapter(id: 'ch2', subjectId: 'sub1', name: 'Ch2', order: 1, isCompleted: false),
          Chapter(id: 'ch3', subjectId: 'sub1', name: 'Ch3', order: 2, isCompleted: true),
        ];

        when(() => mockRepo.getAllChaptersForExam('exam1')).thenReturn(chapters);

        final coverage = service.calculateChapterCoverage(exam);

        expect(coverage.total, equals(3));
        expect(coverage.completed, equals(2));
        expect(coverage.remaining, equals(1));
        expect(coverage.percent, equals(2 / 3));
      });

      test('returns 100% when all chapters completed', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Test Exam',
          examDate: DateTime.now().add(const Duration(days: 30)),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true),
          Chapter(id: 'ch2', subjectId: 'sub1', name: 'Ch2', order: 1, isCompleted: true),
        ];

        when(() => mockRepo.getAllChaptersForExam('exam1')).thenReturn(chapters);

        final coverage = service.calculateChapterCoverage(exam);

        expect(coverage.percent, equals(1.0));
      });
    });

    group('calculateSubjectProgress', () {
      test('calculates subject progress correctly', () {
        final subject = Subject(
          id: 'sub1',
          examId: 'exam1',
          name: 'Mathematics',
          order: 0,
          colorValue: 0xFF34B98A,
        );

        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true),
          Chapter(id: 'ch2', subjectId: 'sub1', name: 'Ch2', order: 1, isCompleted: false),
          Chapter(id: 'ch3', subjectId: 'sub1', name: 'Ch3', order: 2, isCompleted: true),
        ];

        when(() => mockRepo.getChaptersForSubject('sub1')).thenReturn(chapters);

        final progress = service.calculateSubjectProgress(subject);

        expect(progress.subjectId, equals('sub1'));
        expect(progress.subjectName, equals('Mathematics'));
        expect(progress.totalChapters, equals(3));
        expect(progress.completedChapters, equals(2));
        expect(progress.remainingChapters, equals(1));
        expect(progress.percent, equals(2 / 3));
      });

      test('returns zero for subject with no chapters', () {
        final subject = Subject(
          id: 'sub1',
          examId: 'exam1',
          name: 'Mathematics',
          order: 0,
          colorValue: 0xFF34B98A,
        );

        when(() => mockRepo.getChaptersForSubject('sub1')).thenReturn([]);

        final progress = service.calculateSubjectProgress(subject);

        expect(progress.totalChapters, equals(0));
        expect(progress.completedChapters, equals(0));
        expect(progress.percent, equals(0.0));
      });
    });

    group('calculateStudyDuration', () {
      test('sums duration of completed focus sessions', () {
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: DateTime.now().subtract(const Duration(hours: 1)),
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: DateTime.now().subtract(const Duration(hours: 2)),
            durationMinutes: 50,
            completed: true,
          ),
          FocusSession(
            id: 'fs3',
            examId: 'exam1',
            type: SessionType.shortBreak,
            startedAt: DateTime.now().subtract(const Duration(hours: 3)),
            durationMinutes: 5,
            completed: true,
          ),
        ];

        final duration = service.calculateStudyDuration(sessions);

        expect(duration.totalMinutes, equals(75));
        expect(duration.hours, equals(1));
        expect(duration.minutes, equals(15));
        expect(duration.formatted, equals('1h 15m'));
      });

      test('ignores incomplete sessions', () {
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: DateTime.now(),
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: DateTime.now(),
            durationMinutes: 25,
            completed: false,
          ),
        ];

        final duration = service.calculateStudyDuration(sessions);

        expect(duration.totalMinutes, equals(25));
      });

      test('ignores break sessions', () {
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: DateTime.now(),
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.shortBreak,
            startedAt: DateTime.now(),
            durationMinutes: 5,
            completed: true,
          ),
        ];

        final duration = service.calculateStudyDuration(sessions);

        expect(duration.totalMinutes, equals(25));
      });

      test('returns zero for empty sessions', () {
        final duration = service.calculateStudyDuration([]);

        expect(duration.totalMinutes, equals(0));
        expect(duration.formatted, equals('0m'));
      });
    });

    group('calculateTodayFocusMinutes', () {
      test('returns minutes for today only', () {
        final today = DateTime.now().dateOnly;
        final yesterday = today.subtract(const Duration(days: 1));

        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today,
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: yesterday,
            durationMinutes: 50,
            completed: true,
          ),
        ];

        final minutes = service.calculateTodayFocusMinutes(sessions);

        expect(minutes, equals(25));
      });
    });

    group('calculateDailyGoalProgress', () {
      test('calculates progress correctly', () {
        final progress = service.calculateDailyGoalProgress(
          actualMinutes: 30,
          targetMinutes: 60,
        );

        expect(progress.actualMinutes, equals(30));
        expect(progress.targetMinutes, equals(60));
        expect(progress.percent, equals(0.5));
        expect(progress.remainingMinutes, equals(30));
        expect(progress.isGoalMet, isFalse);
      });

      test('caps at 100% when goal exceeded', () {
        final progress = service.calculateDailyGoalProgress(
          actualMinutes: 150,
          targetMinutes: 60,
        );

        expect(progress.percent, equals(1.0));
        expect(progress.remainingMinutes, equals(0));
        expect(progress.isGoalMet, isTrue);
      });

      test('handles zero target', () {
        final progress = service.calculateDailyGoalProgress(
          actualMinutes: 30,
          targetMinutes: 0,
        );

        expect(progress.percent, equals(0.0));
        expect(progress.remainingMinutes, equals(0));
        expect(progress.isGoalMet, isFalse);
      });
    });

    group('calculateWeeklyTotals', () {
      test('calculates daily totals for last 7 days', () {
        final today = DateTime.now().dateOnly;
        final refDate = today;

        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true, completedAt: today),
          Chapter(id: 'ch2', subjectId: 'sub1', name: 'Ch2', order: 1, isCompleted: true, completedAt: today.subtract(const Duration(days: 1))),
          Chapter(id: 'ch3', subjectId: 'sub1', name: 'Ch3', order: 2, isCompleted: false),
        ];

        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today,
            durationMinutes: 40,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today.subtract(const Duration(days: 2)),
            durationMinutes: 60,
            completed: true,
          ),
        ];

        when(() => mockRepo.getAllChaptersForExam('exam1')).thenReturn(chapters);
        when(() => mockRepo.getCompletedSessions('exam1')).thenReturn(sessions);

        final totals = service.calculateWeeklyTotals(
          sessions: sessions,
          chapters: chapters,
          referenceDate: refDate,
        );

        expect(totals.dailyChapters.length, equals(7));
        expect(totals.dailyMinutes.length, equals(7));
        expect(totals.labels.length, equals(7));
        expect(totals.totalChapters, equals(2)); // 2 completed chapters
        expect(totals.totalMinutes, equals(100)); // 40 + 60
      });
    });

    group('calculateStreaks', () {
      test('returns zero for no activity', () {
        final streak = service.calculateStreaks(sessions: [], chapters: []);

        expect(streak.current, equals(0));
        expect(streak.longest, equals(0));
      });

      test('calculates current streak including today', () {
        final today = DateTime.now().dateOnly;
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today,
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today.subtract(const Duration(days: 1)),
            durationMinutes: 25,
            completed: true,
          ),
        ];

        final streak = service.calculateStreaks(sessions: sessions, chapters: []);

        expect(streak.current, equals(2));
        expect(streak.longest, equals(2));
      });

      test('calculates current streak ending yesterday', () {
        final today = DateTime.now().dateOnly;
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today.subtract(const Duration(days: 1)),
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today.subtract(const Duration(days: 2)),
            durationMinutes: 25,
            completed: true,
          ),
        ];

        final streak = service.calculateStreaks(sessions: sessions, chapters: []);

        expect(streak.current, equals(2));
      });

      test('breaks streak on gap', () {
        final today = DateTime.now().dateOnly;
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today,
            durationMinutes: 25,
            completed: true,
          ),
          FocusSession(
            id: 'fs2',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today.subtract(const Duration(days: 3)),
            durationMinutes: 25,
            completed: true,
          ),
        ];

        final streak = service.calculateStreaks(sessions: sessions, chapters: []);

        expect(streak.current, equals(1));
      });

      test('calculates longest streak correctly', () {
        final sessions = [
          FocusSession(id: 'fs1', examId: 'e1', type: SessionType.focus, startedAt: DateTime(2024, 1, 1), durationMinutes: 25, completed: true),
          FocusSession(id: 'fs2', examId: 'e1', type: SessionType.focus, startedAt: DateTime(2024, 1, 2), durationMinutes: 25, completed: true),
          FocusSession(id: 'fs3', examId: 'e1', type: SessionType.focus, startedAt: DateTime(2024, 1, 3), durationMinutes: 25, completed: true),
          FocusSession(id: 'fs4', examId: 'e1', type: SessionType.focus, startedAt: DateTime(2024, 1, 5), durationMinutes: 25, completed: true),
          FocusSession(id: 'fs5', examId: 'e1', type: SessionType.focus, startedAt: DateTime(2024, 1, 6), durationMinutes: 25, completed: true),
        ];

        final streak = service.calculateStreaks(sessions: sessions, chapters: []);

        expect(streak.longest, equals(3)); // Jan 1-3 is 3 days
      });

      test('counts chapter completions as activity days', () {
        final today = DateTime.now().dateOnly;
        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true, completedAt: today.subtract(const Duration(days: 1))),
          Chapter(id: 'ch2', subjectId: 'sub1', name: 'Ch2', order: 1, isCompleted: true, completedAt: today.subtract(const Duration(days: 2))),
        ];

        final streak = service.calculateStreaks(sessions: [], chapters: chapters);

        expect(streak.current, equals(2));
      });

      test('respects minimum qualifying minutes', () {
        final today = DateTime.now().dateOnly;
        final sessions = [
          FocusSession(
            id: 'fs1',
            examId: 'exam1',
            type: SessionType.focus,
            startedAt: today,
            durationMinutes: 1,
            completed: true,
          ),
        ];

        final streakWithDefault = service.calculateStreaks(sessions: sessions, chapters: [], minimumQualifyingMinutes: 1);
        final streakWithHigh = service.calculateStreaks(sessions: sessions, chapters: [], minimumQualifyingMinutes: 5);

        expect(streakWithDefault.current, equals(1));
        expect(streakWithHigh.current, equals(0)); // 1 min < 5 min threshold
      });
    });

    group('calculateExamCountdown', () {
      test('calculates days left for future exam', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Final Exam',
          examDate: DateTime.now().add(const Duration(days: 10)),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final countdown = service.calculateExamCountdown(exam);

        expect(countdown.daysLeft, equals(10));
        expect(countdown.isPast, isFalse);
        expect(countdown.displayText, equals('10 days left'));
      });

      test('shows today for exam today', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Final Exam',
          examDate: DateTime.now(),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final countdown = service.calculateExamCountdown(exam);

        expect(countdown.daysLeft, equals(0));
        expect(countdown.isPast, isFalse);
        expect(countdown.displayText, equals('Today'));
      });

      test('shows exam passed for past exams', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Final Exam',
          examDate: DateTime.now().subtract(const Duration(days: 5)),
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final countdown = service.calculateExamCountdown(exam);

        expect(countdown.daysLeft, equals(0));
        expect(countdown.isPast, isTrue);
        expect(countdown.displayText, equals('Exam passed'));
      });
    });

    group('calculateConsistencyScore', () {
      test('calculates percentage of active days in last 14 days', () {
        final today = DateTime.now().dateOnly;
        final sessions = [
          FocusSession(id: 'fs1', examId: 'e1', type: SessionType.focus, startedAt: today, durationMinutes: 25, completed: true),
          FocusSession(id: 'fs2', examId: 'e1', type: SessionType.focus, startedAt: today.subtract(const Duration(days: 3)), durationMinutes: 25, completed: true),
        ];

        final chapters = [
          Chapter(id: 'ch1', subjectId: 'sub1', name: 'Ch1', order: 0, isCompleted: true, completedAt: today.subtract(const Duration(days: 5))),
        ];

        final score = service.calculateConsistencyScore(sessions, chapters);

        // 3 active days out of 14 = ~21.4% -> rounded to 21.0
        expect(score, equals((3 / 14 * 100).roundToDouble()));
      });

      test('returns 0 for no activity', () {
        final score = service.calculateConsistencyScore([], []);
        expect(score, equals(0.0));
      });
    });

    group('calculateMilestones', () {
      test('creates milestones with correct progress', () {
        final milestones = service.calculateMilestones(
          totalFocusMinutes: 400,
          totalSessions: 10,
          longestStreak: 5,
          completedChapters: 30,
        );

        expect(milestones.length, equals(3));

        final focusMilestone = milestones.firstWhere((m) => m.id == 'focus_600');
        expect(focusMilestone.currentValue, equals(400));
        expect(focusMilestone.targetValue, equals(600));
        expect(focusMilestone.percent, equals(400 / 600));

        final streakMilestone = milestones.firstWhere((m) => m.id == 'streak_7');
        expect(streakMilestone.currentValue, equals(5));
        expect(streakMilestone.targetValue, equals(7));

        final chapterMilestone = milestones.firstWhere((m) => m.id == 'chapters_50');
        expect(chapterMilestone.currentValue, equals(30));
        expect(chapterMilestone.targetValue, equals(50));
      });

      test('marks completed milestones', () {
        final milestones = service.calculateMilestones(
          totalFocusMinutes: 700,
          totalSessions: 20,
          longestStreak: 10,
          completedChapters: 60,
        );

        final focusMilestone = milestones.firstWhere((m) => m.id == 'focus_600');
        expect(focusMilestone.isCompleted, isTrue);
        expect(focusMilestone.percent, equals(1.0));
      });
    });

    group('calculateReadinessScore', () {
      test('returns null when no data', () {
        final coverage = ChapterCoverage(total: 0, completed: 0, remaining: 0, percent: 0.0);
        final score = service.calculateReadinessScore(
          coverage: coverage,
          revisionHealth: 0.0,
          consistency: 0.0,
        );

        expect(score, isNull);
      });

      test('calculates weighted score with all components', () {
        final coverage = ChapterCoverage(total: 10, completed: 7, remaining: 3, percent: 0.7);
        final score = service.calculateReadinessScore(
          coverage: coverage,
          revisionHealth: 0.8,
          consistency: 0.5,
          practiceScore: 0.9,
        );

        expect(score, isNotNull);
        expect(score!.score, greaterThan(0));
        expect(score.score, lessThanOrEqualTo(100));
        expect(score.hasRevisionData, isTrue);
        expect(score.hasPracticeData, isTrue);
      });

      test('renormalizes weights when revision data missing', () {
        final coverage = ChapterCoverage(total: 10, completed: 7, remaining: 3, percent: 0.7);
        final score = service.calculateReadinessScore(
          coverage: coverage,
          revisionHealth: 0.0,
          consistency: 0.5,
          practiceScore: 0.9,
        );

        expect(score, isNotNull);
        // Revision weight should be redistributed
        expect(score!.weights['revision'], equals(0.0));
        // Coverage weight should increase
        expect(score.weights['coverage'], greaterThan(0.5));
      });

      test('renormalizes weights when practice data missing', () {
        final coverage = ChapterCoverage(total: 10, completed: 7, remaining: 3, percent: 0.7);
        final score = service.calculateReadinessScore(
          coverage: coverage,
          revisionHealth: 0.8,
          consistency: 0.5,
          practiceScore: null,
        );

        expect(score, isNotNull);
        expect(score!.weights['practice'], equals(0.0));
      });
    });

    group('calculateExamCountdown edge cases', () {
      test('handles leap year', () {
        final exam = Exam(
          id: 'exam1',
          name: 'Leap Year Exam',
          examDate: DateTime(2024, 2, 29), // Leap day
          createdAt: DateTime.now(),
          colorValue: 0xFFE9547B,
        );

        final countdown = service.calculateExamCountdown(exam);
        // Should not crash
        expect(countdown, isNotNull);
      });

      test('handles today exactly', () {
        final now = DateTime.now();
        final exam = Exam(
          id: 'exam1',
          name: 'Today Exam',
          examDate: DateTime(now.year, now.month, now.day),
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          colorValue: 0xFFE9547B,
        );

        final countdown = service.calculateExamCountdown(exam);
        expect(countdown.daysLeft, equals(0));
        expect(countdown.displayText, equals('Today'));
      });
    });
  });
}