import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 4)
class FocusSession extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String? examId;
  
  @HiveField(2)
  SessionType type;
  
  @HiveField(3)
  DateTime startedAt;
  
  @HiveField(4)
  int durationMinutes;
  
  @HiveField(5)
  bool completed;
  
  @HiveField(6)
  DateTime? completedAt;
  
  FocusSession({
    String? id,
    this.examId,
    required this.type,
    required this.startedAt,
    required this.durationMinutes,
    this.completed = false,
    this.completedAt,
  }) : id = id ?? const Uuid().v4();
  
  FocusSession copyWith({
    String? id,
    String? examId,
    SessionType? type,
    DateTime? startedAt,
    int? durationMinutes,
    bool? completed,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return FocusSession(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completed: completed ?? this.completed,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
  
  void markCompleted() {
    completed = true;
    completedAt = DateTime.now();
  }
  
  Duration get duration => Duration(minutes: durationMinutes);
  
  @override
  String toString() => 'FocusSession(id: $id, type: $type, completed: $completed)';
}

@HiveType(typeId: 5)
enum SessionType {
  @HiveField(0)
  focus,
  @HiveField(1)
  shortBreak,
  @HiveField(2)
  longBreak,
}

extension SessionTypeExtensions on SessionType {
  String get label {
    switch (this) {
      case SessionType.focus:
        return 'FOCUS';
      case SessionType.shortBreak:
        return 'SHORT BREAK';
      case SessionType.longBreak:
        return 'LONG BREAK';
    }
  }
  
  String get subtitle {
    switch (this) {
      case SessionType.focus:
        return 'Deep work';
      case SessionType.shortBreak:
        return 'Stretch';
      case SessionType.longBreak:
        return 'Recharge';
    }
  }
  
  Color get color {
    switch (this) {
      case SessionType.focus:
        return const Color(0xFFE9547B);
      case SessionType.shortBreak:
      case SessionType.longBreak:
        return const Color(0xFF34B98A);
    }
  }
}