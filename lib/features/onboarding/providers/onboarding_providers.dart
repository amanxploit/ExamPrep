import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/settings/providers/settings_providers.dart';

part 'onboarding_providers.g.dart';

@riverpod
Future<void> completeOnboarding(CompleteOnboardingRef ref) async {
  final repo = ref.watch(examRepositoryProvider);
  final settings = await repo.getSettings();
  await repo.saveSettings(settings.copyWith(onboardingDone: true));
}

@riverpod
bool onboardingDone(OnboardingDoneRef ref) {
  final settings = ref.watch(settingsProvider).value;
  return settings?.onboardingDone ?? false;
}
