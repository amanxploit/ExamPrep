import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/data/models/flashcard.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'revision_providers.g.dart';

// Revision Items
@riverpod
class RevisionItems extends _$RevisionItems {
  @override
  List<RevisionItem> build(String examId) {
    final repo = ref.watch(examRepositoryProvider);
    return repo.getRevisionItemsForExam(examId);
  }

  Future<void> addRevisionItem(RevisionItem item) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addRevisionItem(item);
    state = [...state, item]..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  }

  Future<void> updateRevisionItem(RevisionItem item) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.updateRevisionItem(item);
    state = state.map((i) => i.id == item.id ? item : i).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  }

  Future<void> deleteRevisionItem(String id) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.deleteRevisionItem(id);
    state = state.where((i) => i.id != id).toList();
  }
}

// Revision Reviews
@riverpod
class RevisionReviews extends _$RevisionReviews {
  @override
  List<RevisionReview> build(String revisionItemId) {
    final repo = ref.read(examRepositoryProvider);
    return repo.getReviewsForItem(revisionItemId);
  }

  Future<void> addRevisionReview(RevisionReview review) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addRevisionReview(review);
    state = [...state, review]..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));
  }
}

// Due revisions (due today or overdue)
@riverpod
List<RevisionItem> dueRevisions(DueRevisionsRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getDueRevisionItems(examId);
}

// Overdue revisions
@riverpod
List<RevisionItem> overdueRevisions(OverdueRevisionsRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getOverdueRevisionItems(examId);
}

// Upcoming revisions
@riverpod
List<RevisionItem> upcomingRevisions(UpcomingRevisionsRef ref, String examId) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getUpcomingRevisionItems(examId);
}

// Revision health
@riverpod
double revisionHealth(RevisionHealthRef ref, String examId) {
  final calc = ref.watch(calculationServiceProvider);
  return calc.calculateRevisionHealth(examId);
}

// Flashcards
@riverpod
class Flashcards extends _$Flashcards {
  @override
  List<Flashcard> build(String examId) {
    final repo = ref.watch(examRepositoryProvider);
    return repo.getFlashcardsForExam(examId);
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addFlashcard(flashcard);
    state = [...state, flashcard]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.updateFlashcard(flashcard);
    state = state.map((f) => f.id == flashcard.id ? flashcard : f).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteFlashcard(String id) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.deleteFlashcard(id);
    state = state.where((f) => f.id != id).toList();
  }
}

// Flashcards for a specific chapter
@riverpod
class ChapterFlashcards extends _$ChapterFlashcards {
  @override
  List<Flashcard> build(String chapterId) {
    final repo = ref.watch(examRepositoryProvider);
    return repo.getFlashcardsForChapter(chapterId);
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addFlashcard(flashcard);
    if (flashcard.chapterId == chapterId) {
      state = [...state, flashcard]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.updateFlashcard(flashcard);
    if (flashcard.chapterId == chapterId) {
      state = state.map((f) => f.id == flashcard.id ? flashcard : f).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  Future<void> deleteFlashcard(String id) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.deleteFlashcard(id);
    state = state.where((f) => f.id != id).toList();
  }
}

// Flashcard Reviews
@riverpod
class FlashcardReviews extends _$FlashcardReviews {
  @override
  List<FlashcardReview> build(String flashcardId) {
    final repo = ref.read(examRepositoryProvider);
    return repo.getFlashcardReviews(flashcardId);
  }

  Future<void> addFlashcardReview(FlashcardReview review) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addFlashcardReview(review);
    state = [...state, review]..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));
  }
}

// Daily Plan Tasks
@riverpod
class DailyPlanTasks extends _$DailyPlanTasks {
  @override
  List<DailyPlanTask> build(String userId, DateTime date) {
    final repo = ref.read(examRepositoryProvider);
    return repo.getDailyPlanTasks(userId, date);
  }

  Future<void> addTask(DailyPlanTask task) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.addDailyPlanTask(task);
    state = [...state, task]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<void> updateTask(DailyPlanTask task) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.updateDailyPlanTask(task);
    state = state.map((t) => t.id == task.id ? task : t).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<void> deleteTask(String id) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.deleteDailyPlanTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  Future<void> reorderTasks(List<DailyPlanTask> tasks) async {
    final repo = ref.read(examRepositoryProvider);
    await repo.reorderDailyPlanTasks(tasks);
    state = [...tasks]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}

// Today's tasks
@riverpod
List<DailyPlanTask> todaysTasks(TodaysTasksRef ref, String userId) {
  final repo = ref.read(examRepositoryProvider);
  return repo.getTodaysTasks(userId);
}

// Calculation Service Provider
@riverpod
CalculationService calculationService(CalculationServiceRef ref) {
  final repo = ref.watch(examRepositoryProvider);
  return CalculationService(repo);
}