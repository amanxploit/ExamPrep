import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'settings.g.dart';

@HiveType(typeId: 6)
class Settings extends HiveObject {
  @HiveField(0)
  int focusMinutes;
  
  @HiveField(1)
  int shortBreakMinutes;
  
  @HiveField(2)
  int longBreakMinutes;
  
  @HiveField(3)
  int sessionsBeforeLongBreak;
  
  @HiveField(4)
  bool autoStartBreaks;
  
  @HiveField(5)
  bool sound;
  
  @HiveField(6)
  bool vibration;
  
  @HiveField(7)
  String? dailyReminderTime; // HH:mm format
  
  @HiveField(8)
  bool onboardingDone;
  
  Settings({
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.sound = true,
    this.vibration = true,
    this.dailyReminderTime,
    this.onboardingDone = false,
  });
  
  Settings copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? sound,
    bool? vibration,
    String? dailyReminderTime,
    bool? onboardingDone,
    bool clearReminderTime = false,
  }) {
    return Settings(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      sessionsBeforeLongBreak: sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      dailyReminderTime: clearReminderTime ? null : (dailyReminderTime ?? this.dailyReminderTime),
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
  
  Duration get focusDuration => Duration(minutes: focusMinutes);
  Duration get shortBreakDuration => Duration(minutes: shortBreakMinutes);
  Duration get longBreakDuration => Duration(minutes: longBreakMinutes);
  
  TimeOfDay? get reminderTimeOfDay {
    if (dailyReminderTime == null) return null;
    final parts = dailyReminderTime!.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}