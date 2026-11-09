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
  
  ExamRepository({
    required Box<Exam> examBox,
    required Box<Subject> subjectBox,
    required Box<Chapter> chapterBox,
    required Box<StudyTask> taskBox,
    required Box<FocusSession> sessionBox,
    required Box<Settings> settingsBox,
    required Box<TimerState> timerStateBox,
  }) : _examBox = examBox,
       _subjectBox = subjectBox,
       _chapterBox = chapterBox,
       _taskBox = taskBox,
       _sessionBox = sessionBox,
       _settingsBox = settingsBox,
       _timerStateBox = timerStateBox;
  
  // Exam operations
  List<Exam> getAllExams() => _examBox.values.toList()..sort((a, b) => a.examDate.compareTo(b.examDate));
  
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
        final chapters = _chapterBox.values.where((c) => c.subjectId == subject.id).toList();
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
      _subjectBox.values.where((s) => s.examId == examId).toList()..sort((a, b) => a.order.compareTo(b.order));
  
  Subject? getSubject(String id) => _subjectBox.get(id);
  
  Future<void> addSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
  }
  
  Future<void> updateSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
  }
  
  Future<void> deleteSubject(String id) async {
    final chapters = _chapterBox.values.where((c) => c.subjectId == id).toList();
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
      _chapterBox.values.where((c) => c.subjectId == subjectId).toList()..sort((a, b) => a.order.compareTo(b.order));
  
  List<Chapter> getAllChaptersForExam(String examId) {
    final subjectIds = _subjectBox.values.where((s) => s.examId == examId).map((s) => s.id).toSet();
    return _chapterBox.values.where((c) => subjectIds.contains(c.subjectId)).toList()
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
      _taskBox.values.where((t) => t.examId == examId).toList()..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  
  List<StudyTask> getTasksForDate(String examId, DateTime date) {
    final dateOnly = date.dateOnly;
    return _taskBox.values
        .where((t) => t.examId == examId && t.dueDate.dateOnly == dateOnly)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
  
  List<StudyTask> getTodayTasks(String examId) => getTasksForDate(examId, DateTime.now());
  
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
      _sessionBox.values.where((s) => s.examId == examId).toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  
  List<FocusSession> getSessionsForDate(String? examId, DateTime date) {
    final dateOnly = date.dateOnly;
    return _sessionBox.values
        .where((s) => (examId == null || s.examId == examId) && s.startedAt.dateOnly == dateOnly && s.completed)
        .toList()
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
  }
  
  List<FocusSession> getTodaySessions(String? examId) => getSessionsForDate(examId, DateTime.now());
  
  List<FocusSession> getCompletedSessions(String? examId) => 
      _sessionBox.values.where((s) => (examId == null || s.examId == examId) && s.completed).toList()
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
  
  // Stream providers
  Stream<List<Exam>> watchExams() => _examBox.watch().map((_) => getAllExams());
  
  Stream<Exam?> watchActiveExam() => _examBox.watch().map((_) => getActiveExam());
  
  Stream<List<Subject>> watchSubjects(String examId) => _subjectBox.watch().map((_) => getSubjectsForExam(examId));
  
  Stream<List<Chapter>> watchChapters(String subjectId) => _chapterBox.watch().map((_) => getChaptersForSubject(subjectId));
  
  Stream<List<StudyTask>> watchTasks(String examId) => _taskBox.watch().map((_) => getTasksForExam(examId));
  
  Stream<List<FocusSession>> watchSessions(String? examId) => _sessionBox.watch().map((_) => getCompletedSessions(examId));
  
  Stream<Settings> watchSettings() => _settingsBox.watch().map((_) => getSettings());
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
  );
}