import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'progress_providers.g.dart';

@riverpod
Map<String, int> overallProgress(OverallProgressRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) {
    return {'completed': 0, 'remaining': 0, 'total': 0};
  }
  
  final chapters = repo.getAllChaptersForExam(exam.id);
  final completed = chapters.where((c) => c.isCompleted).length;
  final total = chapters.length;
  final remaining = total - completed;
  
  return {'completed': completed, 'remaining': remaining, 'total': total};
}

@riverpod
List<int> weeklyChaptersProgress(WeeklyChaptersProgressRef ref) {
  return ref.watch(weeklyChaptersProvider);
}

@riverpod
List<int> weeklyFocusMinutesProgress(WeeklyFocusMinutesProgressRef ref) {
  return ref.watch(weeklyFocusMinutesProvider);
}

@riverpod
List<String> weeklyLabelsProgress(WeeklyLabelsProgressRef ref) {
  return ref.watch(weeklyLabelsProvider);
}

@riverpod
Map<String, dynamic> summaryStats(SummaryStatsRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  
  if (exam == null) {
    return {
      'totalTime': 0,
      'sessions': 0,
      'longestStreak': 0,
    };
  }
  
  final sessions = repo.getCompletedSessions(exam.id);
  final focusSessions = sessions.where((s) => s.type == SessionType.focus).toList();
  
  final totalMinutes = focusSessions.fold(0, (sum, s) => sum + s.durationMinutes);
  final totalSessions = focusSessions.length;
  
  // Calculate longest streak
  final chapters = repo.getAllChaptersForExam(exam.id);
  final activityDates = <DateTime>{};
  
  for (final session in focusSessions) {
    activityDates.add(session.startedAt.dateOnly);
  }
  
  for (final chapter in chapters.where((c) => c.isCompleted && c.completedAt != null)) {
    activityDates.add(chapter.completedAt!.dateOnly);
  }
  
  var longestStreak = 0;
  if (activityDates.isNotEmpty) {
    final sortedDates = activityDates.toList()..sort();
    var currentStreak = 1;
    longestStreak = 1;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final diff = sortedDates[i].difference(sortedDates[i - 1]).inDays;
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) longestStreak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }
  }
  
  return {
    'totalTime': totalMinutes,
    'sessions': totalSessions,
    'longestStreak': longestStreak,
  };
}