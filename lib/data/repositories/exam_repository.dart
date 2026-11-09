import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/adapters/hive_adapters.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/models/timer_state.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/data/models/flashcard.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'exam_repository.g.dart';

class ExamRepository {
  final Box<Exam> _examBox;
  final Box<Subject> _subjectBox;
  final Box<Chapter> _chapterBox;
  final Box<StudyTask> _taskBox;
  final Box<FocusSession> _sessionBox;
  final Box<Settings> _settingsBox;
  final Box<TimerState> _timerStateBox;
  final Box<RevisionItem> _revisionItemBox;
  final Box<RevisionReview> _revisionReviewBox;
  final Box<Flashcard> _flashcardBox;
  final Box<FlashcardReview> _flashcardReviewBox;
  final Box<DailyPlanTask> _dailyPlanTaskBox;

  ExamRepository({
    required Box<Exam> examBox,
    required Box<Subject> subjectBox,
    required Box<Chapter> chapterBox,
    required Box<StudyTask> taskBox,
    required Box<FocusSession> sessionBox,
    required Box<Settings> settingsBox,
    required Box<TimerState> timerStateBox,
    required Box<RevisionItem> revisionItemBox,
    required Box<RevisionReview> revisionReviewBox,
    required Box<Flashcard> flashcardBox,
    required Box<FlashcardReview> flashcardReviewBox,
    required Box<DailyPlanTask> dailyPlanTaskBox,
  })  : _examBox = examBox,
        _subjectBox = subjectBox,
        _chapterBox = chapterBox,
        _taskBox = taskBox,
        _sessionBox = sessionBox,
        _settingsBox = settingsBox,
        _timerStateBox = timerStateBox,
        _revisionItemBox = revisionItemBox,
        _revisionReviewBox = revisionReviewBox,
        _flashcardBox = flashcardBox,
        _flashcardReviewBox = flashcardReviewBox,
        _dailyPlanTaskBox = dailyPlanTaskBox;

  // Exam operations
  List<Exam> getAllExams() => _examBox.values.toList()
    ..sort((a, b) => a.examDate.compareTo(b.examDate));

  Exam? getActiveExam() {
    try {
      return _examBox.values.firstWhere((e) => e.isActive);
    } catch (_) {
      return null;
    }
  }

  Exam? getExam(String id) => _examBox.get(id);

  Future<void> addExam(Exam exam) async {
    // If this is the first exam, make it active
    if (_examBox.isEmpty) {
      exam = exam.copyWith(isActive: true);
    }
    await _examBox.put(exam.id, exam);
  }

  Future<void> updateExam(Exam exam) async {
    await _examBox.put(exam.id, exam);
  }

  Future<void> deleteExam(String id) async {
    final exam = _examBox.get(id);
    if (exam != null) {
      // Delete related data
      final subjects = _subjectBox.values.where((s) => s.examId == id).toList();
      for (final subject in subjects) {
        final chapters =
            _chapterBox.values.where((c) => c.subjectId == subject.id).toList();
        for (final chapter in chapters) {
          await _chapterBox.delete(chapter.id);
        }
        await _subjectBox.delete(subject.id);
      }

      final tasks = _taskBox.values.where((t) => t.examId == id).toList();
      for (final task in tasks) {
        await _taskBox.delete(task.id);
      }

      final sessions = _sessionBox.values.where((s) => s.examId == id).toList();
      for (final session in sessions) {
        await _sessionBox.delete(session.id);
      }

      await _examBox.delete(id);
    }
  }

  Future<void> setActiveExam(String id) async {
    for (final exam in _examBox.values) {
      if (exam.id == id) {
        await _examBox.put(exam.id, exam.copyWith(isActive: true));
      } else if (exam.isActive) {
        await _examBox.put(exam.id, exam.copyWith(isActive: false));
      }
    }
  }

  // Subject operations
  List<Subject> getSubjectsForExam(String examId) =>
      _subjectBox.values.where((s) => s.examId == examId).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

  Subject? getSubject(String id) => _subjectBox.get(id);

  Future<void> addSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
  }

  Future<void> updateSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
  }

  Future<void> deleteSubject(String id) async {
    final chapters =
        _chapterBox.values.where((c) => c.subjectId == id).toList();
    for (final chapter in chapters) {
      await _chapterBox.delete(chapter.id);
    }
    await _subjectBox.delete(id);
  }

  Future<void> reorderSubjects(List<Subject> subjects) async {
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].order != i) {
        await _subjectBox.put(subjects[i].id, subjects[i].copyWith(order: i));
      }
    }
  }

  // Chapter operations
  List<Chapter> getChaptersForSubject(String subjectId) =>
      _chapterBox.values.where((c) => c.subjectId == subjectId).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

  List<Chapter> getAllChaptersForExam(String examId) {
    final subjectIds = _subjectBox.values
        .where((s) => s.examId == examId)
        .map((s) => s.id)
        .toSet();
    return _chapterBox.values
        .where((c) => subjectIds.contains(c.subjectId))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Chapter? getChapter(String id) => _chapterBox.get(id);

  Future<void> addChapter(Chapter chapter) async {
    await _chapterBox.put(chapter.id, chapter);
  }

  Future<void> updateChapter(Chapter chapter) async {
    await _chapterBox.put(chapter.id, chapter);
  }

  Future<void> deleteChapter(String id) async {
    await _chapterBox.delete(id);
  }

  Future<void> reorderChapters(List<Chapter> chapters) async {
    for (int i = 0; i < chapters.length; i++) {
      if (chapters[i].order != i) {
        await _chapterBox.put(chapters[i].id, chapters[i].copyWith(order: i));
      }
    }
  }

  // StudyTask operations
  List<StudyTask> getTasksForExam(String examId) =>
      _taskBox.values.where((t) => t.examId == examId).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<StudyTask> getTasksForDate(String examId, DateTime date) {
    final dateOnly = date.dateOnly;
    return _taskBox.values
        .where((t) => t.examId == examId && t.dueDate.dateOnly == dateOnly)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  List<StudyTask> getTodayTasks(String examId) =>
      getTasksForDate(examId, DateTime.now());

  StudyTask? getTask(String id) => _taskBox.get(id);

  Future<void> addTask(StudyTask task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(StudyTask task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  // FocusSession operations
  List<FocusSession> getSessionsForExam(String examId) =>
      _sessionBox.values.where((s) => s.examId == examId).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

  List<FocusSession> getSessionsForDate(String? examId, DateTime date) {
    final dateOnly = date.dateOnly;
    return _sessionBox.values
        .where((s) =>
            (examId == null || s.examId == examId) &&
            s.startedAt.dateOnly == dateOnly &&
            s.completed)
        .toList()
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
  }

  List<FocusSession> getTodaySessions(String? examId) =>
      getSessionsForDate(examId, DateTime.now());

  List<FocusSession> getCompletedSessions(String? examId) => _sessionBox.values
      .where((s) => (examId == null || s.examId == examId) && s.completed)
      .toList()
    ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

  FocusSession? getSession(String id) => _sessionBox.get(id);

  Future<void> addSession(FocusSession session) async {
    await _sessionBox.put(session.id, session);
  }

  Future<void> updateSession(FocusSession session) async {
    await _sessionBox.put(session.id, session);
  }

  // Settings operations
  Settings getSettings() {
    return _settingsBox.get('settings') ?? Settings();
  }

  Future<void> saveSettings(Settings settings) async {
    await _settingsBox.put('settings', settings);
  }

  // Timer state operations
  TimerState? getTimerState() {
    return _timerStateBox.get('timer_state');
  }

  Future<void> saveTimerState(TimerState state) async {
    await _timerStateBox.put('timer_state', state);
  }

  Future<void> clearTimerState() async {
    await _timerStateBox.delete('timer_state');
  }

  // RevisionItem operations
  List<RevisionItem> getRevisionItemsForExam(String examId) {
    final chapterIds = _chapterBox.values
        .where((c) => _subjectBox.values
            .any((s) => s.examId == examId && s.id == c.subjectId))
        .map((c) => c.id)
        .toSet();
    return _revisionItemBox.values
        .where((r) =>
            chapterIds.contains(r.chapterId) &&
            r.status != RevisionStatus.archived)
        .toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  }

  List<RevisionItem> getDueRevisionItems(String examId) {
    final now = DateTime.now().dateOnly;
    return getRevisionItemsForExam(examId)
        .where((r) =>
            r.dueAt.dateOnly.compareTo(now) <= 0 &&
            r.status == RevisionStatus.pending)
        .toList();
  }

  List<RevisionItem> getOverdueRevisionItems(String examId) {
    final now = DateTime.now().dateOnly;
    return getRevisionItemsForExam(examId)
        .where((r) =>
            r.dueAt.dateOnly.compareTo(now) < 0 &&
            r.status == RevisionStatus.pending)
        .toList();
  }

  List<RevisionItem> getUpcomingRevisionItems(String examId) {
    final now = DateTime.now().dateOnly;
    return getRevisionItemsForExam(examId)
        .where((r) =>
            r.dueAt.dateOnly.compareTo(now) > 0 &&
            r.status == RevisionStatus.pending)
        .toList();
  }

  RevisionItem? getRevisionItem(String id) => _revisionItemBox.get(id);

  Future<void> addRevisionItem(RevisionItem item) async {
    await _revisionItemBox.put(item.id, item);
  }

  Future<void> updateRevisionItem(RevisionItem item) async {
    await _revisionItemBox.put(
        item.id, item.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteRevisionItem(String id) async {
    await _revisionItemBox.delete(id);
  }

  // RevisionReview operations
  List<RevisionReview> getReviewsForItem(String revisionItemId) =>
      _revisionReviewBox.values
          .where((r) => r.revisionItemId == revisionItemId)
          .toList()
        ..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));

  List<RevisionReview> getAllReviewsForExam(String examId) {
    final itemIds = getRevisionItemsForExam(examId).map((i) => i.id).toSet();
    return _revisionReviewBox.values
        .where((r) => itemIds.contains(r.revisionItemId))
        .toList()
      ..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));
  }

  Future<void> addRevisionReview(RevisionReview review) async {
    await _revisionReviewBox.put(review.id, review);
  }

  // Flashcard operations
  List<Flashcard> getFlashcardsForExam(String examId) {
    final chapterIds = _chapterBox.values
        .where((c) => _subjectBox.values
            .any((s) => s.examId == examId && s.id == c.subjectId))
        .map((c) => c.id)
        .toSet();
    return _flashcardBox.values
        .where((f) =>
            (f.chapterId != null && chapterIds.contains(f.chapterId!)) ||
            (f.revisionItemId != null &&
                _revisionItemBox.values.any((r) =>
                    r.id == f.revisionItemId &&
                    chapterIds.contains(r.chapterId))))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Flashcard> getFlashcardsForChapter(String chapterId) =>
      _flashcardBox.values.where((f) => f.chapterId == chapterId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Flashcard? getFlashcard(String id) => _flashcardBox.get(id);

  Future<void> addFlashcard(Flashcard flashcard) async {
    await _flashcardBox.put(flashcard.id, flashcard);
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    await _flashcardBox.put(
        flashcard.id, flashcard.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteFlashcard(String id) async {
    await _flashcardBox.delete(id);
  }

  // FlashcardReview operations
  List<FlashcardReview> getFlashcardReviews(String flashcardId) =>
      _flashcardReviewBox.values
          .where((r) => r.flashcardId == flashcardId)
          .toList()
        ..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));

  Future<void> addFlashcardReview(FlashcardReview review) async {
    await _flashcardReviewBox.put(review.id, review);
  }

  // DailyPlanTask operations
  List<DailyPlanTask> getDailyPlanTasks(String userId, DateTime date) {
    final dateOnly = date.dateOnly;
    return _dailyPlanTaskBox.values
        .where((t) => t.userId == userId && t.date.dateOnly == dateOnly)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<DailyPlanTask> getTodaysTasks(String userId) =>
      getDailyPlanTasks(userId, DateTime.now());

  DailyPlanTask? getDailyPlanTask(String id) => _dailyPlanTaskBox.get(id);

  Future<void> addDailyPlanTask(DailyPlanTask task) async {
    await _dailyPlanTaskBox.put(task.id, task);
  }

  Future<void> updateDailyPlanTask(DailyPlanTask task) async {
    await _dailyPlanTaskBox.put(
        task.id, task.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteDailyPlanTask(String id) async {
    await _dailyPlanTaskBox.delete(id);
  }

  Future<void> reorderDailyPlanTasks(List<DailyPlanTask> tasks) async {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].sortOrder != i) {
        await _dailyPlanTaskBox.put(tasks[i].id,
            tasks[i].copyWith(sortOrder: i, updatedAt: DateTime.now()));
      }
    }
  }

  // Stream providers
  Stream<List<Exam>> watchExams() => _examBox.watch().map((_) => getAllExams());

  Stream<Exam?> watchActiveExam() =>
      _examBox.watch().map((_) => getActiveExam());

  Stream<List<Subject>> watchSubjects(String examId) =>
      _subjectBox.watch().map((_) => getSubjectsForExam(examId));

  Stream<List<Chapter>> watchChapters(String subjectId) =>
      _chapterBox.watch().map((_) => getChaptersForSubject(subjectId));

  Stream<List<StudyTask>> watchTasks(String examId) =>
      _taskBox.watch().map((_) => getTasksForExam(examId));

  Stream<List<FocusSession>> watchSessions(String? examId) =>
      _sessionBox.watch().map((_) => getCompletedSessions(examId));

  Stream<Settings> watchSettings() =>
      _settingsBox.watch().map((_) => getSettings());

  Stream<List<RevisionItem>> watchRevisionItems(String examId) =>
      _revisionItemBox.watch().map((_) => getRevisionItemsForExam(examId));

  Stream<List<RevisionReview>> watchRevisionReviews(String revisionItemId) =>
      _revisionReviewBox.watch().map((_) => getReviewsForItem(revisionItemId));

  Stream<List<Flashcard>> watchFlashcards(String examId) =>
      _flashcardBox.watch().map((_) => getFlashcardsForExam(examId));

  Stream<List<DailyPlanTask>> watchDailyPlanTasks(
          String userId, DateTime date) =>
      _dailyPlanTaskBox.watch().map((_) => getDailyPlanTasks(userId, date));
}

@riverpod
ExamRepository examRepository(ExamRepositoryRef ref) {
  return ExamRepository(
    examBox: Hive.box<Exam>(examBoxName),
    subjectBox: Hive.box<Subject>(subjectBoxName),
    chapterBox: Hive.box<Chapter>(chapterBoxName),
    taskBox: Hive.box<StudyTask>(studyTaskBoxName),
    sessionBox: Hive.box<FocusSession>(focusSessionBoxName),
    settingsBox: Hive.box<Settings>(settingsBoxName),
    timerStateBox: Hive.box<TimerState>(timerStateBoxName),
    revisionItemBox: Hive.box<RevisionItem>(revisionItemBoxName),
    revisionReviewBox: Hive.box<RevisionReview>(revisionReviewBoxName),
    flashcardBox: Hive.box<Flashcard>(flashcardBoxName),
    flashcardReviewBox: Hive.box<FlashcardReview>(flashcardReviewBoxName),
    dailyPlanTaskBox: Hive.box<DailyPlanTask>(dailyPlanTaskBoxName),
  );
}
