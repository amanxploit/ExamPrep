import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/router.dart';
import 'app/theme.dart';
import 'data/adapters/hive_adapters.dart';
import 'data/models/exam.dart';
import 'data/models/subject.dart';
import 'data/models/chapter.dart';
import 'data/models/study_task.dart';
import 'data/models/focus_session.dart';
import 'data/models/settings.dart';
import 'data/models/timer_state.dart';
import 'data/models/revision_item.dart';
import 'data/models/revision_review.dart';
import 'data/models/flashcard.dart';
import 'data/models/daily_plan_task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone for notifications
  tz.initializeTimeZones();

  // Initialize date formatting
  await initializeDateFormatting();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  registerHiveAdapters();

  // Open boxes
  await Hive.openBox<Exam>(examBoxName);
  await Hive.openBox<Subject>(subjectBoxName);
  await Hive.openBox<Chapter>(chapterBoxName);
  await Hive.openBox<StudyTask>(studyTaskBoxName);
  await Hive.openBox<FocusSession>(focusSessionBoxName);
  await Hive.openBox<Settings>(settingsBoxName);
  await Hive.openBox<TimerState>(timerStateBoxName);
  await Hive.openBox<RevisionItem>(revisionItemBoxName);
  await Hive.openBox<RevisionReview>(revisionReviewBoxName);
  await Hive.openBox<Flashcard>(flashcardBoxName);
  await Hive.openBox<FlashcardReview>(flashcardReviewBoxName);
  await Hive.openBox<DailyPlanTask>(dailyPlanTaskBoxName);

  // Set preferred orientations
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // System UI overlay style for light status bar on pink background
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.dark,
  //   statusBarBrightness: Brightness.light,
  // ));

  runApp(const ProviderScope(child: ExamPrepApp()));
}

class ExamPrepApp extends ConsumerWidget {
  const ExamPrepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ExamPrep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        final textScaler = MediaQuery.of(context).textScaler;
        final clampedScale = textScaler.scale(1.0).clamp(1.0, 1.3);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(clampedScale),
          ),
          child: child!,
        );
      },
    );
  }
}
