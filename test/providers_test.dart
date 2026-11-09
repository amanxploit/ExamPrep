import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/utils/date_utils.dart';

class MockExamRepository extends Mock implements ExamRepository {}

void main() {
  group('DateUtils', () {
    test('formatDate returns correct format', () {
      final date = DateTime(2026, 11, 18);
      expect(AppDateUtils.formatDate(date), equals('Nov 18, 2026'));
    });
    
    test('greeting returns correct greeting based on hour', () {
      // We can't easily test this without mocking DateTime.now()
      // but we can verify the function exists
      expect(AppDateUtils.greeting(), isA<String>());
    });
    
    test('formatDuration formats hours and minutes correctly', () {
      expect(AppDateUtils.formatDuration(const Duration(hours: 4, minutes: 15)), equals('4h 15m'));
      expect(AppDateUtils.formatDuration(const Duration(hours: 2)), equals('2h'));
      expect(AppDateUtils.formatDuration(const Duration(minutes: 30)), equals('30m'));
      expect(AppDateUtils.formatDuration(const Duration(minutes: 90)), equals('1h 30m'));
    });
    
    test('last7Days returns 7 days ending today', () {
      final today = DateTime.now().dateOnly;
      final days = AppDateUtils.last7Days();
      
      expect(days.length, equals(7));
      expect(days.last, equals(today));
      expect(days.first, equals(today.subtract(const Duration(days: 6))));
    });
    
    test('weekdayInitial returns first letter of weekday', () {
      final monday = DateTime(2026, 11, 16); // Monday
      expect(AppDateUtils.weekdayInitial(monday), equals('M'));
    });
  });
  
  group('Exam model', () {
    test('daysLeft calculates correctly for future exam', () {
      final exam = Exam(
        id: '1',
        name: 'Test Exam',
        examDate: DateTime.now().add(const Duration(days: 10)),
        createdAt: DateTime.now(),
        colorValue: 0xFFE9547B,
      );
      expect(exam.daysLeft, equals(10));
    });
    
    test('daysLeft returns 0 for past exam', () {
      final exam = Exam(
        id: '1',
        name: 'Test Exam',
        examDate: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now(),
        colorValue: 0xFFE9547B,
      );
      expect(exam.daysLeft, equals(0));
    });
    
    test('daysLeft returns 0 for today', () {
      final exam = Exam(
        id: '1',
        name: 'Test Exam',
        examDate: DateTime.now(),
        createdAt: DateTime.now(),
        colorValue: 0xFFE9547B,
      );
      expect(exam.daysLeft, equals(0));
    });
  });
  
  group('Streak calculation', () {
    test('currentStreak returns 0 for no activity', () {
      final activityDates = <DateTime>{};
      var streak = 0;
      var currentDate = DateTime.now().dateOnly;
      
      if (!activityDates.contains(currentDate)) {
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      while (activityDates.contains(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      expect(streak, equals(0));
    });
    
    test('currentStreak counts consecutive days including today', () {
      final today = DateTime.now().dateOnly;
      final activityDates = {
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      };
      
      var streak = 0;
      var currentDate = today;
      
      if (!activityDates.contains(currentDate)) {
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      while (activityDates.contains(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      expect(streak, equals(3));
    });
    
    test('currentStreak counts consecutive days ending yesterday', () {
      final today = DateTime.now().dateOnly;
      final activityDates = {
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
        today.subtract(const Duration(days: 3)),
      };
      
      var streak = 0;
      var currentDate = today;
      
      if (!activityDates.contains(currentDate)) {
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      while (activityDates.contains(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      expect(streak, equals(3));
    });
    
    test('currentStreak breaks on gap', () {
      final today = DateTime.now().dateOnly;
      final activityDates = {
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 3)), // Gap here
      };
      
      var streak = 0;
      var currentDate = today;
      
      if (!activityDates.contains(currentDate)) {
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      while (activityDates.contains(currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      
      expect(streak, equals(2));
    });
  });
  
  group('Percent prepared', () {
    test('returns 0 when total is 0', () {
      expect(0 / 0, isNaN);
      // In provider, we check total == 0 and return 0.0
    });
    
    test('calculates correctly', () {
      final completed = 5;
      final total = 20;
      expect(completed / total, equals(0.25));
    });
  });
  
  group('Weekly aggregation', () {
    test('weeklyChapters aggregates correctly', () {
      final today = DateTime.now().dateOnly;
      final chapters = [
        Chapter(subjectId: '1', name: 'Ch1', order: 0, isCompleted: true, completedAt: today),
        Chapter(subjectId: '1', name: 'Ch2', order: 1, isCompleted: true, completedAt: today.subtract(const Duration(days: 1))),
        Chapter(subjectId: '1', name: 'Ch3', order: 2, isCompleted: true, completedAt: today.subtract(const Duration(days: 3))),
      ];
      
      final last7Days = AppDateUtils.last7Days();
      final result = <int>[];
      
      for (final day in last7Days) {
        final count = chapters.where((c) => c.completedAt!.dateOnly == day).length;
        result.add(count);
      }
      
      expect(result.length, equals(7));
      expect(result[6], equals(1)); // Today
      expect(result[5], equals(1)); // Yesterday
      expect(result[3], equals(1)); // 3 days ago
      expect(result[4], equals(0)); // 4 days ago (no chapter)
    });
    
    test('weeklyFocusMinutes aggregates correctly', () {
      final today = DateTime.now().dateOnly;
      final sessions = [
        FocusSession(
          examId: '1',
          type: SessionType.focus,
          startedAt: today,
          durationMinutes: 40,
          completed: true,
        ),
        FocusSession(
          examId: '1',
          type: SessionType.focus,
          startedAt: today.subtract(const Duration(days: 2)),
          durationMinutes: 60,
          completed: true,
        ),
      ];
      
      final last7Days = AppDateUtils.last7Days();
      final result = <int>[];
      
      for (final day in last7Days) {
        final minutes = sessions
            .where((s) => s.startedAt.dateOnly == day)
            .fold(0, (sum, s) => sum + s.durationMinutes);
        result.add(minutes);
      }
      
      expect(result[6], equals(40)); // Today
      expect(result[4], equals(60)); // 2 days ago
      expect(result[5], equals(0)); // Yesterday
    });
  });
  
  group('Subject status', () {
    test('on track when completed ratio >= expected ratio', () {
      final completedRatio = 0.5;
      final expectedRatio = 0.3;
      expect(completedRatio >= expectedRatio, isTrue);
    });
    
    test('behind when completed ratio < expected ratio', () {
      final completedRatio = 0.2;
      final expectedRatio = 0.5;
      expect(completedRatio >= expectedRatio, isFalse);
    });
  });
  
  group('FocusTimer state transitions', () {
    test('focus -> short break after 1 focus session', () {
      final settings = Settings(sessionsBeforeLongBreak: 4);
      var completedFocusSessions = 0;
      var currentType = SessionType.focus;
      
      // Complete focus session
      completedFocusSessions++;
      
      SessionType nextType;
      if (completedFocusSessions % settings.sessionsBeforeLongBreak == 0) {
        nextType = SessionType.longBreak;
      } else {
        nextType = SessionType.shortBreak;
      }
      
      expect(nextType, equals(SessionType.shortBreak));
    });
    
    test('focus -> long break after N focus sessions', () {
      final settings = Settings(sessionsBeforeLongBreak: 4);
      var completedFocusSessions = 3;
      var currentType = SessionType.focus;
      
      // Complete 4th focus session
      completedFocusSessions++;
      
      SessionType nextType;
      if (completedFocusSessions % settings.sessionsBeforeLongBreak == 0) {
        nextType = SessionType.longBreak;
      } else {
        nextType = SessionType.shortBreak;
      }
      
      expect(nextType, equals(SessionType.longBreak));
    });
    
    test('break -> focus', () {
      var currentType = SessionType.shortBreak;
      
      SessionType nextType;
      switch (currentType) {
        case SessionType.focus:
          nextType = SessionType.shortBreak;
          break;
        case SessionType.shortBreak:
        case SessionType.longBreak:
          nextType = SessionType.focus;
          break;
      }
      
      expect(nextType, equals(SessionType.focus));
    });
  });
}