// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$focusProgressHash() => r'd0dc14114941ea149544e4c60870cd472cb7f59f';

/// See also [focusProgress].
@ProviderFor(focusProgress)
final focusProgressProvider = AutoDisposeProvider<double>.internal(
  focusProgress,
  name: r'focusProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$focusProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FocusProgressRef = AutoDisposeProviderRef<double>;
String _$completedFocusSessionsTodayHash() =>
    r'26c6e86f2f65bbe3c2b5345e39673c0600450676';

/// See also [completedFocusSessionsToday].
@ProviderFor(completedFocusSessionsToday)
final completedFocusSessionsTodayProvider = AutoDisposeProvider<int>.internal(
  completedFocusSessionsToday,
  name: r'completedFocusSessionsTodayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedFocusSessionsTodayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedFocusSessionsTodayRef = AutoDisposeProviderRef<int>;
String _$focusTimerHash() => r'a8eaf6232b27e465bac68e8c9f20ad49d5d9d8bf';

/// See also [FocusTimer].
@ProviderFor(FocusTimer)
final focusTimerProvider =
    AutoDisposeNotifierProvider<FocusTimer, FocusTimerState>.internal(
  FocusTimer.new,
  name: r'focusTimerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$focusTimerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FocusTimer = AutoDisposeNotifier<FocusTimerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
