import 'package:hive/hive.dart';
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
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(RevisionItemAdapter());
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(RevisionStatusAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(RevisionReviewAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ReviewRatingAdapter());
  }
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(FlashcardAdapter());
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(FlashcardReviewAdapter());
  }
  if (!Hive.isAdapterRegistered(14)) {
    Hive.registerAdapter(DailyPlanTaskAdapter());
  }
  if (!Hive.isAdapterRegistered(15)) {
    Hive.registerAdapter(DailyPlanTaskTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(16)) {
    Hive.registerAdapter(DailyPlanTaskStatusAdapter());
  }
}

const examBoxName = 'exams';
const subjectBoxName = 'subjects';
const chapterBoxName = 'chapters';
const studyTaskBoxName = 'study_tasks';
const focusSessionBoxName = 'focus_sessions';
const settingsBoxName = 'settings';
const timerStateBoxName = 'timer_state';
const revisionItemBoxName = 'revision_items';
const revisionReviewBoxName = 'revision_reviews';
const flashcardBoxName = 'flashcards';
const flashcardReviewBoxName = 'flashcard_reviews';
const dailyPlanTaskBoxName = 'daily_plan_tasks';
