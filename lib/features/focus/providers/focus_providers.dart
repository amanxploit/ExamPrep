import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/models/timer_state.dart';
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
  bool _isCompleting = false;
  DateTime? _sessionStartTime;
  
  @override
  FocusTimerState build() {
    final repo = ref.read(examRepositoryProvider);
    final savedState = repo.getTimerState();
    
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    if (savedState != null && savedState.isTimerActive) {
      _examId = savedState.examId;
      _currentType = savedState.currentType;
      _remaining = savedState.remaining;
      _completedFocusSessions = savedState.completedFocusSessions;
      _isRunning = savedState.isRunning;
      _endTime = savedState.endTime;
      _sessionStartTime = savedState.sessionStartTime;
      
      if (savedState.isRunning) {
        final elapsed = DateTime.now().difference(savedState.sessionStartTime ?? DateTime.now());
        if (elapsed >= savedState.remaining) {
          _remaining = Duration.zero;
          _isRunning = false;
          _endTime = null;
        } else {
          _isRunning = true;
          _endTime = DateTime.now().add(savedState.remaining - elapsed);
        }
      } else {
        _isRunning = false;
      }
      
      return FocusTimerState(
        remaining: _remaining,
        currentType: _currentType,
        isRunning: _isRunning,
        completedFocusSessions: _completedFocusSessions,
      );
    }
    
    return const FocusTimerState(
      remaining: Duration.zero,
      currentType: SessionType.focus,
      isRunning: false,
      completedFocusSessions: 0,
    );
  }
  
  Future<void> _saveTimerState() async {
    final repo = ref.read(examRepositoryProvider);
    final state = TimerState(
      examId: _examId,
      currentType: _currentType,
      remainingSeconds: _remaining.inSeconds,
      isRunning: _isRunning,
      completedFocusSessions: _completedFocusSessions,
      endTime: _endTime,
      sessionStartTime: _sessionStartTime,
    );
    await repo.saveTimerState(state);
  }
  
  Future<void> _clearTimerState() async {
    final repo = ref.read(examRepositoryProvider);
    await repo.clearTimerState();
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
    _sessionStartTime = null;
    _isRunning = false;
    state = FocusTimerState(
      remaining: duration,
      currentType: type,
      isRunning: false,
      completedFocusSessions: completedFocusSessions,
    );
    _saveTimerState();
  }
  
  void start() {
    if (_isRunning) return;
    
    final settings = ref.read(settingsProvider).value ?? Settings();
    _isRunning = true;
    _endTime = DateTime.now().add(_remaining);
    _sessionStartTime = DateTime.now();
    
    _scheduleNotification(settings);
    _enableWakelock();
    
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    
    state = state.copyWith(isRunning: true);
    _saveTimerState();
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
    _saveTimerState();
  }
  
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _endTime = null;
    _sessionStartTime = null;
    
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
    _saveTimerState();
  }
  
  void skip() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _endTime = null;
    _sessionStartTime = null;
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
      _sessionStartTime = null;
      _completeSession();
      return;
    }
    
    state = state.copyWith(remaining: _remaining);
    _saveTimerState();
  }
  
  void _completeSession() {
    if (_isCompleting) return;
    _isCompleting = true;
    
    _hapticFeedback();
    
    final actualElapsedMinutes = _sessionStartTime != null 
        ? DateTime.now().difference(_sessionStartTime!).inMinutes
        : _getSessionDuration(_currentType).inMinutes;
    
    final repo = ref.read(examRepositoryProvider);
    final session = FocusSession(
      examId: _examId,
      type: _currentType,
      startedAt: _sessionStartTime ?? DateTime.now().subtract(Duration(minutes: actualElapsedMinutes)),
      durationMinutes: actualElapsedMinutes,
      completed: true,
      completedAt: DateTime.now(),
    );
    repo.addSession(session);
    
    final settings = ref.read(settingsProvider).value ?? Settings();
    if (settings.sound) {
      _playSound();
    }
    
    _hapticFeedback();
    
    _advanceSession(autoStart: settings.autoStartBreaks);
    
    _isCompleting = false;
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
    _sessionStartTime = null;
    
    state = FocusTimerState(
      remaining: _remaining,
      currentType: _currentType,
      isRunning: false,
      completedFocusSessions: _completedFocusSessions,
    );
    _saveTimerState();
    
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
    _sessionStartTime = null;
    
    state = state.copyWith(
      currentType: type,
      remaining: _remaining,
      isRunning: false,
    );
    _saveTimerState();
    
    if (wasRunning) {
      Future.delayed(const Duration(milliseconds: 100), start);
    }
  }
}

Future<void> _scheduleNotification(Settings settings) async {}
  
  void _cancelNotification() {}
  
  Future<void> _enableWakelock() async {}
  
  Future<void> _disableWakelock() async {}
  
  void _hapticFeedback() {}
  
  void _playSound() {}

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

@riverpod
int completedFocusSessionsToday(CompletedFocusSessionsTodayRef ref) {
  final exam = ref.watch(activeExamProvider).value;
  final repo = ref.watch(examRepositoryProvider);
  final sessions = repo.getTodaySessions(exam?.id);
  return sessions.where((s) => s.type == SessionType.focus && s.completed).length;
}