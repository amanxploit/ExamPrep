import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String examId;

  @HiveField(2)
  String name;

  @HiveField(3)
  int order;

  @HiveField(4)
  int colorValue;

  Subject({
    String? id,
    required this.examId,
    required this.name,
    required this.order,
    required this.colorValue,
  }) : id = id ?? const Uuid().v4();

  Subject copyWith({
    String? id,
    String? examId,
    String? name,
    int? order,
    int? colorValue,
  }) {
    return Subject(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      name: name ?? this.name,
      order: order ?? this.order,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Color get color => Color(colorValue);

  @override
  String toString() => 'Subject(id: $id, name: $name, order: $order)';
}
