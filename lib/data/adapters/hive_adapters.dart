import 'package:hive/hive.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/models/timer_state.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ExamAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SubjectAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ChapterAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(StudyTaskAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(FocusSessionAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(SessionTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(SettingsAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(TimerStateAdapter());
  }
}

const examBoxName = 'exams';
const subjectBoxName = 'subjects';
const chapterBoxName = 'chapters';
const studyTaskBoxName = 'study_tasks';
const focusSessionBoxName = 'focus_sessions';
const settingsBoxName = 'settings';
const timerStateBoxName = 'timer_state';