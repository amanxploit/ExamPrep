import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';

part 'daily_plan_providers.g.dart';

@riverpod
DailyPlanResult? dailyPlanResult(DailyPlanResultRef ref) {
  // This will be populated after generating a plan
  return null;
}