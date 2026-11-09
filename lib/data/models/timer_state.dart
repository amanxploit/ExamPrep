import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:exam_prep/data/models/focus_session.dart';

part 'timer_state.g.dart';

@HiveType(typeId: 7)
class TimerState {
  @HiveField(0)
  String? examId;

  @HiveField(1)
  SessionType currentType;

  @HiveField(2)
  int remainingSeconds;

  @HiveField(3)
  bool isRunning;

  @HiveField(4)
  int completedFocusSessions;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  DateTime? sessionStartTime;

  TimerState({
    this.examId,
    required this.currentType,
    required this.remainingSeconds,
    required this.isRunning,
    required this.completedFocusSessions,
    this.endTime,
    this.sessionStartTime,
  });

  Duration get remaining => Duration(seconds: remainingSeconds);

  TimerState copyWith({
    String? examId,
    SessionType? currentType,
    int? remainingSeconds,
    bool? isRunning,
    int? completedFocusSessions,
    DateTime? endTime,
    DateTime? sessionStartTime,
  }) {
    return TimerState(
      examId: examId ?? this.examId,
      currentType: currentType ?? this.currentType,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      completedFocusSessions:
          completedFocusSessions ?? this.completedFocusSessions,
      endTime: endTime ?? this.endTime,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
    );
  }

  bool get isTimerActive => isRunning && remainingSeconds > 0;
}
