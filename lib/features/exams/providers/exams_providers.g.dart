// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allExamsHash() => r'03dc1aa2c9ae9a5e204a2a69173da55a9608c152';

/// See also [allExams].
@ProviderFor(allExams)
final allExamsProvider = AutoDisposeStreamProvider<List<Exam>>.internal(
  allExams,
  name: r'allExamsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allExamsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllExamsRef = AutoDisposeStreamProviderRef<List<Exam>>;
String _$createExamHash() => r'94da33748544d2a634bde4e8e8c5b7bb4b0752dc';

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

/// See also [createExam].
@ProviderFor(createExam)
const createExamProvider = CreateExamFamily();

/// See also [createExam].
class CreateExamFamily extends Family<AsyncValue<void>> {
  /// See also [createExam].
  const CreateExamFamily();

  /// See also [createExam].
  CreateExamProvider call({
    required String examName,
    required DateTime examDate,
    required int colorValue,
    int dailyGoalMinutes = 120,
  }) {
    return CreateExamProvider(
      examName: examName,
      examDate: examDate,
      colorValue: colorValue,
      dailyGoalMinutes: dailyGoalMinutes,
    );
  }

  @override
  CreateExamProvider getProviderOverride(
    covariant CreateExamProvider provider,
  ) {
    return call(
      examName: provider.examName,
      examDate: provider.examDate,
      colorValue: provider.colorValue,
      dailyGoalMinutes: provider.dailyGoalMinutes,
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
  String? get name => r'createExamProvider';
}

/// See also [createExam].
class CreateExamProvider extends AutoDisposeFutureProvider<void> {
  /// See also [createExam].
  CreateExamProvider({
    required String examName,
    required DateTime examDate,
    required int colorValue,
    int dailyGoalMinutes = 120,
  }) : this._internal(
          (ref) => createExam(
            ref as CreateExamRef,
            examName: examName,
            examDate: examDate,
            colorValue: colorValue,
            dailyGoalMinutes: dailyGoalMinutes,
          ),
          from: createExamProvider,
          name: r'createExamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createExamHash,
          dependencies: CreateExamFamily._dependencies,
          allTransitiveDependencies:
              CreateExamFamily._allTransitiveDependencies,
          examName: examName,
          examDate: examDate,
          colorValue: colorValue,
          dailyGoalMinutes: dailyGoalMinutes,
        );

  CreateExamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examName,
    required this.examDate,
    required this.colorValue,
    required this.dailyGoalMinutes,
  }) : super.internal();

  final String examName;
  final DateTime examDate;
  final int colorValue;
  final int dailyGoalMinutes;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateExamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateExamProvider._internal(
        (ref) => create(ref as CreateExamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examName: examName,
        examDate: examDate,
        colorValue: colorValue,
        dailyGoalMinutes: dailyGoalMinutes,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateExamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateExamProvider &&
        other.examName == examName &&
        other.examDate == examDate &&
        other.colorValue == colorValue &&
        other.dailyGoalMinutes == dailyGoalMinutes;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examName.hashCode);
    hash = _SystemHash.combine(hash, examDate.hashCode);
    hash = _SystemHash.combine(hash, colorValue.hashCode);
    hash = _SystemHash.combine(hash, dailyGoalMinutes.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreateExamRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `examName` of this provider.
  String get examName;

  /// The parameter `examDate` of this provider.
  DateTime get examDate;

  /// The parameter `colorValue` of this provider.
  int get colorValue;

  /// The parameter `dailyGoalMinutes` of this provider.
  int get dailyGoalMinutes;
}

class _CreateExamProviderElement extends AutoDisposeFutureProviderElement<void>
    with CreateExamRef {
  _CreateExamProviderElement(super.provider);

  @override
  String get examName => (origin as CreateExamProvider).examName;
  @override
  DateTime get examDate => (origin as CreateExamProvider).examDate;
  @override
  int get colorValue => (origin as CreateExamProvider).colorValue;
  @override
  int get dailyGoalMinutes => (origin as CreateExamProvider).dailyGoalMinutes;
}

String _$updateExamHash() => r'030945c88bd4cacb19ccd6563075cb208e0fd839';

/// See also [updateExam].
@ProviderFor(updateExam)
const updateExamProvider = UpdateExamFamily();

/// See also [updateExam].
class UpdateExamFamily extends Family<AsyncValue<void>> {
  /// See also [updateExam].
  const UpdateExamFamily();

  /// See also [updateExam].
  UpdateExamProvider call(
    Exam exam,
  ) {
    return UpdateExamProvider(
      exam,
    );
  }

  @override
  UpdateExamProvider getProviderOverride(
    covariant UpdateExamProvider provider,
  ) {
    return call(
      provider.exam,
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
  String? get name => r'updateExamProvider';
}

/// See also [updateExam].
class UpdateExamProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateExam].
  UpdateExamProvider(
    Exam exam,
  ) : this._internal(
          (ref) => updateExam(
            ref as UpdateExamRef,
            exam,
          ),
          from: updateExamProvider,
          name: r'updateExamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateExamHash,
          dependencies: UpdateExamFamily._dependencies,
          allTransitiveDependencies:
              UpdateExamFamily._allTransitiveDependencies,
          exam: exam,
        );

  UpdateExamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exam,
  }) : super.internal();

  final Exam exam;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateExamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateExamProvider._internal(
        (ref) => create(ref as UpdateExamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exam: exam,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateExamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateExamProvider && other.exam == exam;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exam.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateExamRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `exam` of this provider.
  Exam get exam;
}

class _UpdateExamProviderElement extends AutoDisposeFutureProviderElement<void>
    with UpdateExamRef {
  _UpdateExamProviderElement(super.provider);

  @override
  Exam get exam => (origin as UpdateExamProvider).exam;
}

String _$deleteExamHash() => r'f0d3f85ff6603948899d653867a1771daaddb749';

/// See also [deleteExam].
@ProviderFor(deleteExam)
const deleteExamProvider = DeleteExamFamily();

/// See also [deleteExam].
class DeleteExamFamily extends Family<AsyncValue<void>> {
  /// See also [deleteExam].
  const DeleteExamFamily();

  /// See also [deleteExam].
  DeleteExamProvider call(
    String examId,
  ) {
    return DeleteExamProvider(
      examId,
    );
  }

  @override
  DeleteExamProvider getProviderOverride(
    covariant DeleteExamProvider provider,
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
  String? get name => r'deleteExamProvider';
}

/// See also [deleteExam].
class DeleteExamProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteExam].
  DeleteExamProvider(
    String examId,
  ) : this._internal(
          (ref) => deleteExam(
            ref as DeleteExamRef,
            examId,
          ),
          from: deleteExamProvider,
          name: r'deleteExamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteExamHash,
          dependencies: DeleteExamFamily._dependencies,
          allTransitiveDependencies:
              DeleteExamFamily._allTransitiveDependencies,
          examId: examId,
        );

  DeleteExamProvider._internal(
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
    FutureOr<void> Function(DeleteExamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteExamProvider._internal(
        (ref) => create(ref as DeleteExamRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteExamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteExamProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteExamRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _DeleteExamProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteExamRef {
  _DeleteExamProviderElement(super.provider);

  @override
  String get examId => (origin as DeleteExamProvider).examId;
}

String _$setActiveExamHash() => r'39730bbfdb018a43702bb86a47f7de2c17268b41';

/// See also [setActiveExam].
@ProviderFor(setActiveExam)
const setActiveExamProvider = SetActiveExamFamily();

/// See also [setActiveExam].
class SetActiveExamFamily extends Family<AsyncValue<void>> {
  /// See also [setActiveExam].
  const SetActiveExamFamily();

  /// See also [setActiveExam].
  SetActiveExamProvider call(
    String examId,
  ) {
    return SetActiveExamProvider(
      examId,
    );
  }

  @override
  SetActiveExamProvider getProviderOverride(
    covariant SetActiveExamProvider provider,
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
  String? get name => r'setActiveExamProvider';
}

/// See also [setActiveExam].
class SetActiveExamProvider extends AutoDisposeFutureProvider<void> {
  /// See also [setActiveExam].
  SetActiveExamProvider(
    String examId,
  ) : this._internal(
          (ref) => setActiveExam(
            ref as SetActiveExamRef,
            examId,
          ),
          from: setActiveExamProvider,
          name: r'setActiveExamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setActiveExamHash,
          dependencies: SetActiveExamFamily._dependencies,
          allTransitiveDependencies:
              SetActiveExamFamily._allTransitiveDependencies,
          examId: examId,
        );

  SetActiveExamProvider._internal(
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
    FutureOr<void> Function(SetActiveExamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SetActiveExamProvider._internal(
        (ref) => create(ref as SetActiveExamRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SetActiveExamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SetActiveExamProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SetActiveExamRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _SetActiveExamProviderElement
    extends AutoDisposeFutureProviderElement<void> with SetActiveExamRef {
  _SetActiveExamProviderElement(super.provider);

  @override
  String get examId => (origin as SetActiveExamProvider).examId;
}

String _$subjectsForExamHash() => r'1d5f534087d7c4680ef3d27b0542f115e65b65d3';

/// See also [subjectsForExam].
@ProviderFor(subjectsForExam)
const subjectsForExamProvider = SubjectsForExamFamily();

/// See also [subjectsForExam].
class SubjectsForExamFamily extends Family<List<Subject>> {
  /// See also [subjectsForExam].
  const SubjectsForExamFamily();

  /// See also [subjectsForExam].
  SubjectsForExamProvider call(
    String examId,
  ) {
    return SubjectsForExamProvider(
      examId,
    );
  }

  @override
  SubjectsForExamProvider getProviderOverride(
    covariant SubjectsForExamProvider provider,
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
  String? get name => r'subjectsForExamProvider';
}

/// See also [subjectsForExam].
class SubjectsForExamProvider extends AutoDisposeProvider<List<Subject>> {
  /// See also [subjectsForExam].
  SubjectsForExamProvider(
    String examId,
  ) : this._internal(
          (ref) => subjectsForExam(
            ref as SubjectsForExamRef,
            examId,
          ),
          from: subjectsForExamProvider,
          name: r'subjectsForExamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subjectsForExamHash,
          dependencies: SubjectsForExamFamily._dependencies,
          allTransitiveDependencies:
              SubjectsForExamFamily._allTransitiveDependencies,
          examId: examId,
        );

  SubjectsForExamProvider._internal(
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
    List<Subject> Function(SubjectsForExamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubjectsForExamProvider._internal(
        (ref) => create(ref as SubjectsForExamRef),
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
  AutoDisposeProviderElement<List<Subject>> createElement() {
    return _SubjectsForExamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectsForExamProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SubjectsForExamRef on AutoDisposeProviderRef<List<Subject>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _SubjectsForExamProviderElement
    extends AutoDisposeProviderElement<List<Subject>> with SubjectsForExamRef {
  _SubjectsForExamProviderElement(super.provider);

  @override
  String get examId => (origin as SubjectsForExamProvider).examId;
}

String _$examStatsHash() => r'b070156e64e5f51ec3cce86e93da9496a094d2d7';

/// See also [examStats].
@ProviderFor(examStats)
const examStatsProvider = ExamStatsFamily();

/// See also [examStats].
class ExamStatsFamily extends Family<Map<String, int>> {
  /// See also [examStats].
  const ExamStatsFamily();

  /// See also [examStats].
  ExamStatsProvider call(
    String examId,
  ) {
    return ExamStatsProvider(
      examId,
    );
  }

  @override
  ExamStatsProvider getProviderOverride(
    covariant ExamStatsProvider provider,
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
  String? get name => r'examStatsProvider';
}

/// See also [examStats].
class ExamStatsProvider extends AutoDisposeProvider<Map<String, int>> {
  /// See also [examStats].
  ExamStatsProvider(
    String examId,
  ) : this._internal(
          (ref) => examStats(
            ref as ExamStatsRef,
            examId,
          ),
          from: examStatsProvider,
          name: r'examStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$examStatsHash,
          dependencies: ExamStatsFamily._dependencies,
          allTransitiveDependencies: ExamStatsFamily._allTransitiveDependencies,
          examId: examId,
        );

  ExamStatsProvider._internal(
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
    Map<String, int> Function(ExamStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExamStatsProvider._internal(
        (ref) => create(ref as ExamStatsRef),
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
  AutoDisposeProviderElement<Map<String, int>> createElement() {
    return _ExamStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamStatsProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExamStatsRef on AutoDisposeProviderRef<Map<String, int>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _ExamStatsProviderElement
    extends AutoDisposeProviderElement<Map<String, int>> with ExamStatsRef {
  _ExamStatsProviderElement(super.provider);

  @override
  String get examId => (origin as ExamStatsProvider).examId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
