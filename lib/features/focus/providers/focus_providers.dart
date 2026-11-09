import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/extensions/extensions.dart';
import 'package:exam_prep/features/settings/providers/settings_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';

part 'focus_providers.g.dart';

@riverpod
class FocusTimer extends _$FocusTimer {
  Timer? _timer;
  DateTime? _endTime;
  late Duration _remaining;
  SessionType _currentType = SessionType.focus;
  int _completedFocusSessions = 0;
  bool _isRunning = false;
  String? _examId;
  
  @override
  FocusTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const FocusTimerState(
      remaining: Duration.zero,
      currentType: SessionType.focus,
      isRunning: false,
      completedFocusSessions: 0,
    );
  }
  
  void initialize({
    required SessionType type,
    required Duration duration,
    required int completedFocusSessions,
    String? examId,
  }) {
    _currentType = type;
    _remaining = duration;
    _completedFocusSessions = completedFocusSessions;
    _examId = examId;
    _endTime = null;
    _isRunning = false;
    state = FocusTimerState(
      remaining: duration,
      currentType: type,
      isRunning: false,
      completedFocusSessions: completedFocusSessions,
    );
  }
  
  void start() {
    if (_isRunning) return;
    
    final settings = ref.read(settingsProvider).value ?? Settings();
    _isRunning = true;
    _endTime = DateTime.now().add(_remaining);
    
    // Schedule notification
    _scheduleNotification(settings);
    
    // Keep screen awake
    _enableWakelock();
    
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    
    state = state.copyWith(isRunning: true);
  }
  
  void pause() {
    if (!_isRunning) return;
    
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    
    if (_endTime != null) {
      _remaining = _endTime!.difference(DateTime.now());
      if (_remaining.isNegative) _remaining = Duration.zero;
    }
    _endTime = null;
    
    _cancelNotification();
    _disableWakelock();
    
    state = state.copyWith(isRunning: false, remaining: _remaining);
  }
  
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _endTime = null;
    
    final settings = ref.read(settingsProvider).value ?? Settings();
    Duration duration;
    switch (_currentType) {
      case SessionType.focus:
        duration = settings.focusDuration;
        break;
      case SessionType.shortBreak:
        duration = settings.shortBreakDuration;
        break;
      case SessionType.longBreak:
        duration = settings.longBreakDuration;
        break;
    }
    
    _remaining = duration;
    _cancelNotification();
    _disableWakelock();
    
    state = state.copyWith(
      isRunning: false,
      remaining: duration,
      currentType: _currentType,
    );
  }
  
  void skip() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _endTime = null;
    _cancelNotification();
    _disableWakelock();
    
    _advanceSession(autoStart: false);
  }
  
  void _tick(Timer timer) {
    if (_endTime == null) return;
    
    _remaining = _endTime!.difference(DateTime.now());
    
    if (_remaining <= Duration.zero) {
      _remaining = Duration.zero;
      _timer?.cancel();
      _timer = null;
      _isRunning = false;
      _endTime = null;
      _completeSession();
      return;
    }
    
    state = state.copyWith(remaining: _remaining);
  }
  
  void _completeSession() {
    // Haptic feedback
    _hapticFeedback();
    
    // Save completed session
    final repo = ref.read(examRepositoryProvider);
    final session = FocusSession(
      examId: _examId,
      type: _currentType,
      startedAt: DateTime.now().subtract(_getSessionDuration(_currentType)),
      durationMinutes: _getSessionDuration(_currentType).inMinutes,
      completed: true,
      completedAt: DateTime.now(),
    );
    repo.addSession(session);
    
    // Play sound if enabled
    final settings = ref.read(settingsProvider).value ?? Settings();
    if (settings.sound) {
      _playSound();
    }
    
    // Advance to next session
    _advanceSession(autoStart: settings.autoStartBreaks);
  }
  
  Duration _getSessionDuration(SessionType type) {
    final settings = ref.read(settingsProvider).value ?? Settings();
    switch (type) {
      case SessionType.focus:
        return settings.focusDuration;
      case SessionType.shortBreak:
        return settings.shortBreakDuration;
      case SessionType.longBreak:
        return settings.longBreakDuration;
    }
  }
  
  void _advanceSession({required bool autoStart}) {
    SessionType nextType;
    int nextCompletedFocusSessions = _completedFocusSessions;
    
    final settings = ref.read(settingsProvider).value ?? Settings();
    
    switch (_currentType) {
      case SessionType.focus:
        nextCompletedFocusSessions++;
        if (nextCompletedFocusSessions % settings.sessionsBeforeLongBreak == 0) {
          nextType = SessionType.longBreak;
        } else {
          nextType = SessionType.shortBreak;
        }
        break;
      case SessionType.shortBreak:
      case SessionType.longBreak:
        nextType = SessionType.focus;
        break;
    }
    
    _currentType = nextType;
    _completedFocusSessions = nextCompletedFocusSessions;
    _remaining = _getSessionDuration(nextType);
    _isRunning = false;
    _endTime = null;
    
    state = FocusTimerState(
      remaining: _remaining,
      currentType: _currentType,
      isRunning: false,
      completedFocusSessions: _completedFocusSessions,
    );
    
    if (autoStart) {
      Future.delayed(const Duration(milliseconds: 500), start);
    }
  }
  
  void setType(SessionType type) {
    final wasRunning = _isRunning;
    if (wasRunning) pause();
    
    _currentType = type;
    _remaining = _getSessionDuration(type);
    _endTime = null;
    
    state = state.copyWith(
      currentType: type,
      remaining: _remaining,
      isRunning: false,
    );
    
    if (wasRunning) {
      Future.delayed(const Duration(milliseconds: 100), start);
    }
  }
  
  Future<void> _scheduleNotification(Settings settings) async {
    // TODO: Implement local notification scheduling
  }
  
  void _cancelNotification() {
    // TODO: Implement notification cancellation
  }
  
  Future<void> _enableWakelock() async {
    // TODO: Implement wakelock
  }
  
  Future<void> _disableWakelock() async {
    // TODO: Implement wakelock release
  }
  
  void _hapticFeedback() {
    // TODO: Implement haptic feedback
  }
  
  void _playSound() {
    // TODO: Implement sound playback
  }
}

class FocusTimerState {
  final Duration remaining;
  final SessionType currentType;
  final bool isRunning;
  final int completedFocusSessions;
  
  const FocusTimerState({
    required this.remaining,
    required this.currentType,
    required this.isRunning,
    required this.completedFocusSessions,
  });
  
  FocusTimerState copyWith({
    Duration? remaining,
    SessionType? currentType,
    bool? isRunning,
    int? completedFocusSessions,
  }) {
    return FocusTimerState(
      remaining: remaining ?? this.remaining,
      currentType: currentType ?? this.currentType,
      isRunning: isRunning ?? this.isRunning,
      completedFocusSessions: completedFocusSessions ?? this.completedFocusSessions,
    );
  }
}

// This won't work because we can't use ref in the model. Let's move progress calculation to a provider.

@riverpod
double focusProgress(FocusProgressRef ref) {
  final state = ref.watch(focusTimerProvider);
  final settings = ref.watch(settingsProvider).value ?? Settings();
  Duration total;
  switch (state.currentType) {
    case SessionType.focus:
      total = settings.focusDuration;
      break;
    case SessionType.shortBreak:
      total = settings.shortBreakDuration;
      break;
    case SessionType.longBreak:
      total = settings.longBreakDuration;
      break;
  }
  if (total.inSeconds == 0) return 0.0;
  return 1.0 - (state.remaining.inSeconds / total.inSeconds);
}

// Completed focus sessions today (for session dots)
@riverpod
int completedFocusSessionsToday(CompletedFocusSessionsTodayRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  final sessions = repo.getTodaySessions(exam?.id);
  return sessions.where((s) => s.type == SessionType.focus && s.completed).length;
}