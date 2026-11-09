import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/data/adapters/hive_adapters.dart';

part 'settings_providers.g.dart';

@riverpod
Stream<Settings> settings(SettingsRef ref) {
  final repo = ref.watch(examRepositoryProvider);
  return repo.watchSettings();
}

@riverpod
Future<void> updateSettings(UpdateSettingsRef ref, Settings settings) async {
  final repo = ref.watch(examRepositoryProvider);
  await repo.saveSettings(settings);
}

@riverpod
Future<void> resetAllData(ResetAllDataRef ref) async {
  final repo = ref.watch(examRepositoryProvider);
  // Delete all boxes
  await Hive.box<Exam>(examBoxName).clear();
  await Hive.box<Subject>(subjectBoxName).clear();
  await Hive.box<Chapter>(chapterBoxName).clear();
  await Hive.box<StudyTask>(studyTaskBoxName).clear();
  await Hive.box<FocusSession>(focusSessionBoxName).clear();
  await Hive.box<Settings>(settingsBoxName).clear();
  // Reset to defaults
  await repo.saveSettings(Settings());
}
