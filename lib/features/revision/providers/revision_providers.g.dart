// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dueRevisionsHash() => r'8455d4b6c3f489ec7fb179be7c295c49657af960';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [dueRevisions].
@ProviderFor(dueRevisions)
const dueRevisionsProvider = DueRevisionsFamily();

/// See also [dueRevisions].
class DueRevisionsFamily extends Family<List<RevisionItem>> {
  /// See also [dueRevisions].
  const DueRevisionsFamily();

  /// See also [dueRevisions].
  DueRevisionsProvider call(
    String examId,
  ) {
    return DueRevisionsProvider(
      examId,
    );
  }

  @override
  DueRevisionsProvider getProviderOverride(
    covariant DueRevisionsProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dueRevisionsProvider';
}

/// See also [dueRevisions].
class DueRevisionsProvider extends AutoDisposeProvider<List<RevisionItem>> {
  /// See also [dueRevisions].
  DueRevisionsProvider(
    String examId,
  ) : this._internal(
          (ref) => dueRevisions(
            ref as DueRevisionsRef,
            examId,
          ),
          from: dueRevisionsProvider,
          name: r'dueRevisionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dueRevisionsHash,
          dependencies: DueRevisionsFamily._dependencies,
          allTransitiveDependencies:
              DueRevisionsFamily._allTransitiveDependencies,
          examId: examId,
        );

  DueRevisionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  Override overrideWith(
    List<RevisionItem> Function(DueRevisionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DueRevisionsProvider._internal(
        (ref) => create(ref as DueRevisionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<RevisionItem>> createElement() {
    return _DueRevisionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DueRevisionsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DueRevisionsRef on AutoDisposeProviderRef<List<RevisionItem>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _DueRevisionsProviderElement
    extends AutoDisposeProviderElement<List<RevisionItem>>
    with DueRevisionsRef {
  _DueRevisionsProviderElement(super.provider);

  @override
  String get examId => (origin as DueRevisionsProvider).examId;
}

String _$overdueRevisionsHash() => r'99208a2bb45351ab808db2ef61378ea4efcd3c46';

/// See also [overdueRevisions].
@ProviderFor(overdueRevisions)
const overdueRevisionsProvider = OverdueRevisionsFamily();

/// See also [overdueRevisions].
class OverdueRevisionsFamily extends Family<List<RevisionItem>> {
  /// See also [overdueRevisions].
  const OverdueRevisionsFamily();

  /// See also [overdueRevisions].
  OverdueRevisionsProvider call(
    String examId,
  ) {
    return OverdueRevisionsProvider(
      examId,
    );
  }

  @override
  OverdueRevisionsProvider getProviderOverride(
    covariant OverdueRevisionsProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'overdueRevisionsProvider';
}

/// See also [overdueRevisions].
class OverdueRevisionsProvider extends AutoDisposeProvider<List<RevisionItem>> {
  /// See also [overdueRevisions].
  OverdueRevisionsProvider(
    String examId,
  ) : this._internal(
          (ref) => overdueRevisions(
            ref as OverdueRevisionsRef,
            examId,
          ),
          from: overdueRevisionsProvider,
          name: r'overdueRevisionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$overdueRevisionsHash,
          dependencies: OverdueRevisionsFamily._dependencies,
          allTransitiveDependencies:
              OverdueRevisionsFamily._allTransitiveDependencies,
          examId: examId,
        );

  OverdueRevisionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  Override overrideWith(
    List<RevisionItem> Function(OverdueRevisionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OverdueRevisionsProvider._internal(
        (ref) => create(ref as OverdueRevisionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<RevisionItem>> createElement() {
    return _OverdueRevisionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OverdueRevisionsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OverdueRevisionsRef on AutoDisposeProviderRef<List<RevisionItem>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _OverdueRevisionsProviderElement
    extends AutoDisposeProviderElement<List<RevisionItem>>
    with OverdueRevisionsRef {
  _OverdueRevisionsProviderElement(super.provider);

  @override
  String get examId => (origin as OverdueRevisionsProvider).examId;
}

String _$upcomingRevisionsHash() => r'4b6b824dc9ea1ef1bb1131e5529bd8385de94f23';

/// See also [upcomingRevisions].
@ProviderFor(upcomingRevisions)
const upcomingRevisionsProvider = UpcomingRevisionsFamily();

/// See also [upcomingRevisions].
class UpcomingRevisionsFamily extends Family<List<RevisionItem>> {
  /// See also [upcomingRevisions].
  const UpcomingRevisionsFamily();

  /// See also [upcomingRevisions].
  UpcomingRevisionsProvider call(
    String examId,
  ) {
    return UpcomingRevisionsProvider(
      examId,
    );
  }

  @override
  UpcomingRevisionsProvider getProviderOverride(
    covariant UpcomingRevisionsProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upcomingRevisionsProvider';
}

/// See also [upcomingRevisions].
class UpcomingRevisionsProvider
    extends AutoDisposeProvider<List<RevisionItem>> {
  /// See also [upcomingRevisions].
  UpcomingRevisionsProvider(
    String examId,
  ) : this._internal(
          (ref) => upcomingRevisions(
            ref as UpcomingRevisionsRef,
            examId,
          ),
          from: upcomingRevisionsProvider,
          name: r'upcomingRevisionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upcomingRevisionsHash,
          dependencies: UpcomingRevisionsFamily._dependencies,
          allTransitiveDependencies:
              UpcomingRevisionsFamily._allTransitiveDependencies,
          examId: examId,
        );

  UpcomingRevisionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  Override overrideWith(
    List<RevisionItem> Function(UpcomingRevisionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpcomingRevisionsProvider._internal(
        (ref) => create(ref as UpcomingRevisionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<RevisionItem>> createElement() {
    return _UpcomingRevisionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingRevisionsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpcomingRevisionsRef on AutoDisposeProviderRef<List<RevisionItem>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _UpcomingRevisionsProviderElement
    extends AutoDisposeProviderElement<List<RevisionItem>>
    with UpcomingRevisionsRef {
  _UpcomingRevisionsProviderElement(super.provider);

  @override
  String get examId => (origin as UpcomingRevisionsProvider).examId;
}

String _$revisionHealthHash() => r'dd6fdce5515cd0bd515dc0b0131eb3fd6419ac8d';

/// See also [revisionHealth].
@ProviderFor(revisionHealth)
const revisionHealthProvider = RevisionHealthFamily();

/// See also [revisionHealth].
class RevisionHealthFamily extends Family<double> {
  /// See also [revisionHealth].
  const RevisionHealthFamily();

  /// See also [revisionHealth].
  RevisionHealthProvider call(
    String examId,
  ) {
    return RevisionHealthProvider(
      examId,
    );
  }

  @override
  RevisionHealthProvider getProviderOverride(
    covariant RevisionHealthProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'revisionHealthProvider';
}

/// See also [revisionHealth].
class RevisionHealthProvider extends AutoDisposeProvider<double> {
  /// See also [revisionHealth].
  RevisionHealthProvider(
    String examId,
  ) : this._internal(
          (ref) => revisionHealth(
            ref as RevisionHealthRef,
            examId,
          ),
          from: revisionHealthProvider,
          name: r'revisionHealthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$revisionHealthHash,
          dependencies: RevisionHealthFamily._dependencies,
          allTransitiveDependencies:
              RevisionHealthFamily._allTransitiveDependencies,
          examId: examId,
        );

  RevisionHealthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  Override overrideWith(
    double Function(RevisionHealthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RevisionHealthProvider._internal(
        (ref) => create(ref as RevisionHealthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _RevisionHealthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevisionHealthProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RevisionHealthRef on AutoDisposeProviderRef<double> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _RevisionHealthProviderElement extends AutoDisposeProviderElement<double>
    with RevisionHealthRef {
  _RevisionHealthProviderElement(super.provider);

  @override
  String get examId => (origin as RevisionHealthProvider).examId;
}

String _$todaysTasksHash() => r'90d3fb1e0925cc5e94c7ee92cd663066ccd9cc19';

/// See also [todaysTasks].
@ProviderFor(todaysTasks)
const todaysTasksProvider = TodaysTasksFamily();

/// See also [todaysTasks].
class TodaysTasksFamily extends Family<List<DailyPlanTask>> {
  /// See also [todaysTasks].
  const TodaysTasksFamily();

  /// See also [todaysTasks].
  TodaysTasksProvider call(
    String userId,
  ) {
    return TodaysTasksProvider(
      userId,
    );
  }

  @override
  TodaysTasksProvider getProviderOverride(
    covariant TodaysTasksProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todaysTasksProvider';
}

/// See also [todaysTasks].
class TodaysTasksProvider extends AutoDisposeProvider<List<DailyPlanTask>> {
  /// See also [todaysTasks].
  TodaysTasksProvider(
    String userId,
  ) : this._internal(
          (ref) => todaysTasks(
            ref as TodaysTasksRef,
            userId,
          ),
          from: todaysTasksProvider,
          name: r'todaysTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$todaysTasksHash,
          dependencies: TodaysTasksFamily._dependencies,
          allTransitiveDependencies:
              TodaysTasksFamily._allTransitiveDependencies,
          userId: userId,
        );

  TodaysTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    List<DailyPlanTask> Function(TodaysTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodaysTasksProvider._internal(
        (ref) => create(ref as TodaysTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DailyPlanTask>> createElement() {
    return _TodaysTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodaysTasksProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TodaysTasksRef on AutoDisposeProviderRef<List<DailyPlanTask>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _TodaysTasksProviderElement
    extends AutoDisposeProviderElement<List<DailyPlanTask>>
    with TodaysTasksRef {
  _TodaysTasksProviderElement(super.provider);

  @override
  String get userId => (origin as TodaysTasksProvider).userId;
}

String _$calculationServiceHash() =>
    r'790913d1afd3894d9d71b1a4f0bda712c09d3876';

/// See also [calculationService].
@ProviderFor(calculationService)
final calculationServiceProvider =
    AutoDisposeProvider<CalculationService>.internal(
  calculationService,
  name: r'calculationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calculationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalculationServiceRef = AutoDisposeProviderRef<CalculationService>;
String _$revisionItemsHash() => r'7bb1d7b902c90e52b9c9fcdc4ab2b28c625f4e3b';

abstract class _$RevisionItems
    extends BuildlessAutoDisposeNotifier<List<RevisionItem>> {
  late final String examId;

  List<RevisionItem> build(
    String examId,
  );
}

/// See also [RevisionItems].
@ProviderFor(RevisionItems)
const revisionItemsProvider = RevisionItemsFamily();

/// See also [RevisionItems].
class RevisionItemsFamily extends Family<List<RevisionItem>> {
  /// See also [RevisionItems].
  const RevisionItemsFamily();

  /// See also [RevisionItems].
  RevisionItemsProvider call(
    String examId,
  ) {
    return RevisionItemsProvider(
      examId,
    );
  }

  @override
  RevisionItemsProvider getProviderOverride(
    covariant RevisionItemsProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'revisionItemsProvider';
}

/// See also [RevisionItems].
class RevisionItemsProvider
    extends AutoDisposeNotifierProviderImpl<RevisionItems, List<RevisionItem>> {
  /// See also [RevisionItems].
  RevisionItemsProvider(
    String examId,
  ) : this._internal(
          () => RevisionItems()..examId = examId,
          from: revisionItemsProvider,
          name: r'revisionItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$revisionItemsHash,
          dependencies: RevisionItemsFamily._dependencies,
          allTransitiveDependencies:
              RevisionItemsFamily._allTransitiveDependencies,
          examId: examId,
        );

  RevisionItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  List<RevisionItem> runNotifierBuild(
    covariant RevisionItems notifier,
  ) {
    return notifier.build(
      examId,
    );
  }

  @override
  Override overrideWith(RevisionItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: RevisionItemsProvider._internal(
        () => create()..examId = examId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RevisionItems, List<RevisionItem>>
      createElement() {
    return _RevisionItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevisionItemsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RevisionItemsRef on AutoDisposeNotifierProviderRef<List<RevisionItem>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _RevisionItemsProviderElement extends AutoDisposeNotifierProviderElement<
    RevisionItems, List<RevisionItem>> with RevisionItemsRef {
  _RevisionItemsProviderElement(super.provider);

  @override
  String get examId => (origin as RevisionItemsProvider).examId;
}

String _$revisionReviewsHash() => r'a40d26a51fb1c3d69c734aeaa1c8f8ad869307c6';

abstract class _$RevisionReviews
    extends BuildlessAutoDisposeNotifier<List<RevisionReview>> {
  late final String revisionItemId;

  List<RevisionReview> build(
    String revisionItemId,
  );
}

/// See also [RevisionReviews].
@ProviderFor(RevisionReviews)
const revisionReviewsProvider = RevisionReviewsFamily();

/// See also [RevisionReviews].
class RevisionReviewsFamily extends Family<List<RevisionReview>> {
  /// See also [RevisionReviews].
  const RevisionReviewsFamily();

  /// See also [RevisionReviews].
  RevisionReviewsProvider call(
    String revisionItemId,
  ) {
    return RevisionReviewsProvider(
      revisionItemId,
    );
  }

  @override
  RevisionReviewsProvider getProviderOverride(
    covariant RevisionReviewsProvider provider,
  ) {
    return call(
      provider.revisionItemId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'revisionReviewsProvider';
}

/// See also [RevisionReviews].
class RevisionReviewsProvider extends AutoDisposeNotifierProviderImpl<
    RevisionReviews, List<RevisionReview>> {
  /// See also [RevisionReviews].
  RevisionReviewsProvider(
    String revisionItemId,
  ) : this._internal(
          () => RevisionReviews()..revisionItemId = revisionItemId,
          from: revisionReviewsProvider,
          name: r'revisionReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$revisionReviewsHash,
          dependencies: RevisionReviewsFamily._dependencies,
          allTransitiveDependencies:
              RevisionReviewsFamily._allTransitiveDependencies,
          revisionItemId: revisionItemId,
        );

  RevisionReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.revisionItemId,
  }) : super.internal();

  final String revisionItemId;

  @override
  List<RevisionReview> runNotifierBuild(
    covariant RevisionReviews notifier,
  ) {
    return notifier.build(
      revisionItemId,
    );
  }

  @override
  Override overrideWith(RevisionReviews Function() create) {
    return ProviderOverride(
      origin: this,
      override: RevisionReviewsProvider._internal(
        () => create()..revisionItemId = revisionItemId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        revisionItemId: revisionItemId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RevisionReviews, List<RevisionReview>>
      createElement() {
    return _RevisionReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevisionReviewsProvider &&
        other.revisionItemId == revisionItemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, revisionItemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RevisionReviewsRef
    on AutoDisposeNotifierProviderRef<List<RevisionReview>> {
  /// The parameter `revisionItemId` of this provider.
  String get revisionItemId;
}

class _RevisionReviewsProviderElement
    extends AutoDisposeNotifierProviderElement<RevisionReviews,
        List<RevisionReview>> with RevisionReviewsRef {
  _RevisionReviewsProviderElement(super.provider);

  @override
  String get revisionItemId =>
      (origin as RevisionReviewsProvider).revisionItemId;
}

String _$flashcardsHash() => r'08422f2ca400dd01af2845ea0cf2ef126af4a825';

abstract class _$Flashcards
    extends BuildlessAutoDisposeNotifier<List<Flashcard>> {
  late final String examId;

  List<Flashcard> build(
    String examId,
  );
}

/// See also [Flashcards].
@ProviderFor(Flashcards)
const flashcardsProvider = FlashcardsFamily();

/// See also [Flashcards].
class FlashcardsFamily extends Family<List<Flashcard>> {
  /// See also [Flashcards].
  const FlashcardsFamily();

  /// See also [Flashcards].
  FlashcardsProvider call(
    String examId,
  ) {
    return FlashcardsProvider(
      examId,
    );
  }

  @override
  FlashcardsProvider getProviderOverride(
    covariant FlashcardsProvider provider,
  ) {
    return call(
      provider.examId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'flashcardsProvider';
}

/// See also [Flashcards].
class FlashcardsProvider
    extends AutoDisposeNotifierProviderImpl<Flashcards, List<Flashcard>> {
  /// See also [Flashcards].
  FlashcardsProvider(
    String examId,
  ) : this._internal(
          () => Flashcards()..examId = examId,
          from: flashcardsProvider,
          name: r'flashcardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$flashcardsHash,
          dependencies: FlashcardsFamily._dependencies,
          allTransitiveDependencies:
              FlashcardsFamily._allTransitiveDependencies,
          examId: examId,
        );

  FlashcardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
  }) : super.internal();

  final String examId;

  @override
  List<Flashcard> runNotifierBuild(
    covariant Flashcards notifier,
  ) {
    return notifier.build(
      examId,
    );
  }

  @override
  Override overrideWith(Flashcards Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlashcardsProvider._internal(
        () => create()..examId = examId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Flashcards, List<Flashcard>>
      createElement() {
    return _FlashcardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FlashcardsRef on AutoDisposeNotifierProviderRef<List<Flashcard>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _FlashcardsProviderElement
    extends AutoDisposeNotifierProviderElement<Flashcards, List<Flashcard>>
    with FlashcardsRef {
  _FlashcardsProviderElement(super.provider);

  @override
  String get examId => (origin as FlashcardsProvider).examId;
}

String _$chapterFlashcardsHash() => r'b2b5fdd580007bf3a82417740b3647431eb89d8a';

abstract class _$ChapterFlashcards
    extends BuildlessAutoDisposeNotifier<List<Flashcard>> {
  late final String chapterId;

  List<Flashcard> build(
    String chapterId,
  );
}

/// See also [ChapterFlashcards].
@ProviderFor(ChapterFlashcards)
const chapterFlashcardsProvider = ChapterFlashcardsFamily();

/// See also [ChapterFlashcards].
class ChapterFlashcardsFamily extends Family<List<Flashcard>> {
  /// See also [ChapterFlashcards].
  const ChapterFlashcardsFamily();

  /// See also [ChapterFlashcards].
  ChapterFlashcardsProvider call(
    String chapterId,
  ) {
    return ChapterFlashcardsProvider(
      chapterId,
    );
  }

  @override
  ChapterFlashcardsProvider getProviderOverride(
    covariant ChapterFlashcardsProvider provider,
  ) {
    return call(
      provider.chapterId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterFlashcardsProvider';
}

/// See also [ChapterFlashcards].
class ChapterFlashcardsProvider extends AutoDisposeNotifierProviderImpl<
    ChapterFlashcards, List<Flashcard>> {
  /// See also [ChapterFlashcards].
  ChapterFlashcardsProvider(
    String chapterId,
  ) : this._internal(
          () => ChapterFlashcards()..chapterId = chapterId,
          from: chapterFlashcardsProvider,
          name: r'chapterFlashcardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFlashcardsHash,
          dependencies: ChapterFlashcardsFamily._dependencies,
          allTransitiveDependencies:
              ChapterFlashcardsFamily._allTransitiveDependencies,
          chapterId: chapterId,
        );

  ChapterFlashcardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
  }) : super.internal();

  final String chapterId;

  @override
  List<Flashcard> runNotifierBuild(
    covariant ChapterFlashcards notifier,
  ) {
    return notifier.build(
      chapterId,
    );
  }

  @override
  Override overrideWith(ChapterFlashcards Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterFlashcardsProvider._internal(
        () => create()..chapterId = chapterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterFlashcards, List<Flashcard>>
      createElement() {
    return _ChapterFlashcardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFlashcardsProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChapterFlashcardsRef on AutoDisposeNotifierProviderRef<List<Flashcard>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _ChapterFlashcardsProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterFlashcards,
        List<Flashcard>> with ChapterFlashcardsRef {
  _ChapterFlashcardsProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterFlashcardsProvider).chapterId;
}

String _$flashcardReviewsHash() => r'f0edb46cda2c3bf6fa8457f333d374331690877f';

abstract class _$FlashcardReviews
    extends BuildlessAutoDisposeNotifier<List<FlashcardReview>> {
  late final String flashcardId;

  List<FlashcardReview> build(
    String flashcardId,
  );
}

/// See also [FlashcardReviews].
@ProviderFor(FlashcardReviews)
const flashcardReviewsProvider = FlashcardReviewsFamily();

/// See also [FlashcardReviews].
class FlashcardReviewsFamily extends Family<List<FlashcardReview>> {
  /// See also [FlashcardReviews].
  const FlashcardReviewsFamily();

  /// See also [FlashcardReviews].
  FlashcardReviewsProvider call(
    String flashcardId,
  ) {
    return FlashcardReviewsProvider(
      flashcardId,
    );
  }

  @override
  FlashcardReviewsProvider getProviderOverride(
    covariant FlashcardReviewsProvider provider,
  ) {
    return call(
      provider.flashcardId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'flashcardReviewsProvider';
}

/// See also [FlashcardReviews].
class FlashcardReviewsProvider extends AutoDisposeNotifierProviderImpl<
    FlashcardReviews, List<FlashcardReview>> {
  /// See also [FlashcardReviews].
  FlashcardReviewsProvider(
    String flashcardId,
  ) : this._internal(
          () => FlashcardReviews()..flashcardId = flashcardId,
          from: flashcardReviewsProvider,
          name: r'flashcardReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$flashcardReviewsHash,
          dependencies: FlashcardReviewsFamily._dependencies,
          allTransitiveDependencies:
              FlashcardReviewsFamily._allTransitiveDependencies,
          flashcardId: flashcardId,
        );

  FlashcardReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.flashcardId,
  }) : super.internal();

  final String flashcardId;

  @override
  List<FlashcardReview> runNotifierBuild(
    covariant FlashcardReviews notifier,
  ) {
    return notifier.build(
      flashcardId,
    );
  }

  @override
  Override overrideWith(FlashcardReviews Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlashcardReviewsProvider._internal(
        () => create()..flashcardId = flashcardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        flashcardId: flashcardId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FlashcardReviews, List<FlashcardReview>>
      createElement() {
    return _FlashcardReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlashcardReviewsProvider &&
        other.flashcardId == flashcardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, flashcardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FlashcardReviewsRef
    on AutoDisposeNotifierProviderRef<List<FlashcardReview>> {
  /// The parameter `flashcardId` of this provider.
  String get flashcardId;
}

class _FlashcardReviewsProviderElement
    extends AutoDisposeNotifierProviderElement<FlashcardReviews,
        List<FlashcardReview>> with FlashcardReviewsRef {
  _FlashcardReviewsProviderElement(super.provider);

  @override
  String get flashcardId => (origin as FlashcardReviewsProvider).flashcardId;
}

String _$dailyPlanTasksHash() => r'5c226f8be6bc29650c6d2ec0100ec2cdf61e7c06';

abstract class _$DailyPlanTasks
    extends BuildlessAutoDisposeNotifier<List<DailyPlanTask>> {
  late final String userId;
  late final DateTime date;

  List<DailyPlanTask> build(
    String userId,
    DateTime date,
  );
}

/// See also [DailyPlanTasks].
@ProviderFor(DailyPlanTasks)
const dailyPlanTasksProvider = DailyPlanTasksFamily();

/// See also [DailyPlanTasks].
class DailyPlanTasksFamily extends Family<List<DailyPlanTask>> {
  /// See also [DailyPlanTasks].
  const DailyPlanTasksFamily();

  /// See also [DailyPlanTasks].
  DailyPlanTasksProvider call(
    String userId,
    DateTime date,
  ) {
    return DailyPlanTasksProvider(
      userId,
      date,
    );
  }

  @override
  DailyPlanTasksProvider getProviderOverride(
    covariant DailyPlanTasksProvider provider,
  ) {
    return call(
      provider.userId,
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyPlanTasksProvider';
}

/// See also [DailyPlanTasks].
class DailyPlanTasksProvider extends AutoDisposeNotifierProviderImpl<
    DailyPlanTasks, List<DailyPlanTask>> {
  /// See also [DailyPlanTasks].
  DailyPlanTasksProvider(
    String userId,
    DateTime date,
  ) : this._internal(
          () => DailyPlanTasks()
            ..userId = userId
            ..date = date,
          from: dailyPlanTasksProvider,
          name: r'dailyPlanTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyPlanTasksHash,
          dependencies: DailyPlanTasksFamily._dependencies,
          allTransitiveDependencies:
              DailyPlanTasksFamily._allTransitiveDependencies,
          userId: userId,
          date: date,
        );

  DailyPlanTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.date,
  }) : super.internal();

  final String userId;
  final DateTime date;

  @override
  List<DailyPlanTask> runNotifierBuild(
    covariant DailyPlanTasks notifier,
  ) {
    return notifier.build(
      userId,
      date,
    );
  }

  @override
  Override overrideWith(DailyPlanTasks Function() create) {
    return ProviderOverride(
      origin: this,
      override: DailyPlanTasksProvider._internal(
        () => create()
          ..userId = userId
          ..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DailyPlanTasks, List<DailyPlanTask>>
      createElement() {
    return _DailyPlanTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPlanTasksProvider &&
        other.userId == userId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DailyPlanTasksRef on AutoDisposeNotifierProviderRef<List<DailyPlanTask>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyPlanTasksProviderElement extends AutoDisposeNotifierProviderElement<
    DailyPlanTasks, List<DailyPlanTask>> with DailyPlanTasksRef {
  _DailyPlanTasksProviderElement(super.provider);

  @override
  String get userId => (origin as DailyPlanTasksProvider).userId;
  @override
  DateTime get date => (origin as DailyPlanTasksProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
