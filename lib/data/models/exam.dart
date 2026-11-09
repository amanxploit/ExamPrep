import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

part 'exam.g.dart';

@HiveType(typeId: 0)
class Exam extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  DateTime examDate;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  bool isActive;
  
  @HiveField(5)
  int colorValue;
  
  @HiveField(6)
  int dailyGoalMinutes;
  
  Exam({
    String? id,
    required this.name,
    required this.examDate,
    required this.createdAt,
    this.isActive = false,
    required this.colorValue,
    this.dailyGoalMinutes = 120,
  }) : id = id ?? const Uuid().v4();
  
  Exam copyWith({
    String? id,
    String? name,
    DateTime? examDate,
    DateTime? createdAt,
    bool? isActive,
    int? colorValue,
    int? dailyGoalMinutes,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      examDate: examDate ?? this.examDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      colorValue: colorValue ?? this.colorValue,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    );
  }
  
  Color get color => Color(colorValue);
  
  int get daysLeft {
    final now = DateTime.now().dateOnly;
    final examDay = examDate.dateOnly;
    final diff = examDay.difference(now).inDays;
    return diff.clamp(0, double.infinity).toInt();
  }
  
  bool get isUpcoming => examDate.isAfter(DateTime.now());
  
  @override
  String toString() => 'Exam(id: $id, name: $name, examDate: $examDate, isActive: $isActive)';
}