// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'syllabus_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subjectsHash() => r'd68a2cb342e596377350bff27de803f9edc000b0';

/// See also [subjects].
@ProviderFor(subjects)
final subjectsProvider = AutoDisposeStreamProvider<List<Subject>>.internal(
  subjects,
  name: r'subjectsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$subjectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubjectsRef = AutoDisposeStreamProviderRef<List<Subject>>;
String _$chaptersForSubjectHash() =>
    r'f4a8b79be6402f23b00ceb655c8f4125f82288ec';

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

/// See also [chaptersForSubject].
@ProviderFor(chaptersForSubject)
const chaptersForSubjectProvider = ChaptersForSubjectFamily();

/// See also [chaptersForSubject].
class ChaptersForSubjectFamily extends Family<AsyncValue<List<Chapter>>> {
  /// See also [chaptersForSubject].
  const ChaptersForSubjectFamily();

  /// See also [chaptersForSubject].
  ChaptersForSubjectProvider call(
    String subjectId,
  ) {
    return ChaptersForSubjectProvider(
      subjectId,
    );
  }

  @override
  ChaptersForSubjectProvider getProviderOverride(
    covariant ChaptersForSubjectProvider provider,
  ) {
    return call(
      provider.subjectId,
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
  String? get name => r'chaptersForSubjectProvider';
}

/// See also [chaptersForSubject].
class ChaptersForSubjectProvider
    extends AutoDisposeStreamProvider<List<Chapter>> {
  /// See also [chaptersForSubject].
  ChaptersForSubjectProvider(
    String subjectId,
  ) : this._internal(
          (ref) => chaptersForSubject(
            ref as ChaptersForSubjectRef,
            subjectId,
          ),
          from: chaptersForSubjectProvider,
          name: r'chaptersForSubjectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chaptersForSubjectHash,
          dependencies: ChaptersForSubjectFamily._dependencies,
          allTransitiveDependencies:
              ChaptersForSubjectFamily._allTransitiveDependencies,
          subjectId: subjectId,
        );

  ChaptersForSubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
  }) : super.internal();

  final String subjectId;

  @override
  Override overrideWith(
    Stream<List<Chapter>> Function(ChaptersForSubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChaptersForSubjectProvider._internal(
        (ref) => create(ref as ChaptersForSubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Chapter>> createElement() {
    return _ChaptersForSubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChaptersForSubjectProvider && other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChaptersForSubjectRef on AutoDisposeStreamProviderRef<List<Chapter>> {
  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _ChaptersForSubjectProviderElement
    extends AutoDisposeStreamProviderElement<List<Chapter>>
    with ChaptersForSubjectRef {
  _ChaptersForSubjectProviderElement(super.provider);

  @override
  String get subjectId => (origin as ChaptersForSubjectProvider).subjectId;
}

String _$subjectStatusesHash() => r'107128877953c67966aefaa7d74eb2ff784fa81b';

/// See also [subjectStatuses].
@ProviderFor(subjectStatuses)
final subjectStatusesProvider =
    AutoDisposeProvider<Map<String, String>>.internal(
  subjectStatuses,
  name: r'subjectStatusesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subjectStatusesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubjectStatusesRef = AutoDisposeProviderRef<Map<String, String>>;
String _$addSubjectHash() => r'f2da4a4bda0a46e255eaa2370e3d0545f394b21b';

/// See also [addSubject].
@ProviderFor(addSubject)
const addSubjectProvider = AddSubjectFamily();

/// See also [addSubject].
class AddSubjectFamily extends Family<AsyncValue<void>> {
  /// See also [addSubject].
  const AddSubjectFamily();

  /// See also [addSubject].
  AddSubjectProvider call({
    required String examId,
    required String subjectName,
    required int colorValue,
    List<String>? bulkChapters,
  }) {
    return AddSubjectProvider(
      examId: examId,
      subjectName: subjectName,
      colorValue: colorValue,
      bulkChapters: bulkChapters,
    );
  }

  @override
  AddSubjectProvider getProviderOverride(
    covariant AddSubjectProvider provider,
  ) {
    return call(
      examId: provider.examId,
      subjectName: provider.subjectName,
      colorValue: provider.colorValue,
      bulkChapters: provider.bulkChapters,
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
  String? get name => r'addSubjectProvider';
}

/// See also [addSubject].
class AddSubjectProvider extends AutoDisposeFutureProvider<void> {
  /// See also [addSubject].
  AddSubjectProvider({
    required String examId,
    required String subjectName,
    required int colorValue,
    List<String>? bulkChapters,
  }) : this._internal(
          (ref) => addSubject(
            ref as AddSubjectRef,
            examId: examId,
            subjectName: subjectName,
            colorValue: colorValue,
            bulkChapters: bulkChapters,
          ),
          from: addSubjectProvider,
          name: r'addSubjectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addSubjectHash,
          dependencies: AddSubjectFamily._dependencies,
          allTransitiveDependencies:
              AddSubjectFamily._allTransitiveDependencies,
          examId: examId,
          subjectName: subjectName,
          colorValue: colorValue,
          bulkChapters: bulkChapters,
        );

  AddSubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
    required this.subjectName,
    required this.colorValue,
    required this.bulkChapters,
  }) : super.internal();

  final String examId;
  final String subjectName;
  final int colorValue;
  final List<String>? bulkChapters;

  @override
  Override overrideWith(
    FutureOr<void> Function(AddSubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddSubjectProvider._internal(
        (ref) => create(ref as AddSubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
        subjectName: subjectName,
        colorValue: colorValue,
        bulkChapters: bulkChapters,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddSubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddSubjectProvider &&
        other.examId == examId &&
        other.subjectName == subjectName &&
        other.colorValue == colorValue &&
        other.bulkChapters == bulkChapters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);
    hash = _SystemHash.combine(hash, subjectName.hashCode);
    hash = _SystemHash.combine(hash, colorValue.hashCode);
    hash = _SystemHash.combine(hash, bulkChapters.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddSubjectRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `examId` of this provider.
  String get examId;

  /// The parameter `subjectName` of this provider.
  String get subjectName;

  /// The parameter `colorValue` of this provider.
  int get colorValue;

  /// The parameter `bulkChapters` of this provider.
  List<String>? get bulkChapters;
}

class _AddSubjectProviderElement extends AutoDisposeFutureProviderElement<void>
    with AddSubjectRef {
  _AddSubjectProviderElement(super.provider);

  @override
  String get examId => (origin as AddSubjectProvider).examId;
  @override
  String get subjectName => (origin as AddSubjectProvider).subjectName;
  @override
  int get colorValue => (origin as AddSubjectProvider).colorValue;
  @override
  List<String>? get bulkChapters => (origin as AddSubjectProvider).bulkChapters;
}

String _$updateSubjectHash() => r'15fd8bb1fdec9792d16edb9c14062209b24c640e';

/// See also [updateSubject].
@ProviderFor(updateSubject)
const updateSubjectProvider = UpdateSubjectFamily();

/// See also [updateSubject].
class UpdateSubjectFamily extends Family<AsyncValue<void>> {
  /// See also [updateSubject].
  const UpdateSubjectFamily();

  /// See also [updateSubject].
  UpdateSubjectProvider call(
    Subject subject,
  ) {
    return UpdateSubjectProvider(
      subject,
    );
  }

  @override
  UpdateSubjectProvider getProviderOverride(
    covariant UpdateSubjectProvider provider,
  ) {
    return call(
      provider.subject,
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
  String? get name => r'updateSubjectProvider';
}

/// See also [updateSubject].
class UpdateSubjectProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateSubject].
  UpdateSubjectProvider(
    Subject subject,
  ) : this._internal(
          (ref) => updateSubject(
            ref as UpdateSubjectRef,
            subject,
          ),
          from: updateSubjectProvider,
          name: r'updateSubjectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateSubjectHash,
          dependencies: UpdateSubjectFamily._dependencies,
          allTransitiveDependencies:
              UpdateSubjectFamily._allTransitiveDependencies,
          subject: subject,
        );

  UpdateSubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subject,
  }) : super.internal();

  final Subject subject;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateSubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateSubjectProvider._internal(
        (ref) => create(ref as UpdateSubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subject: subject,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateSubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateSubjectProvider && other.subject == subject;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subject.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateSubjectRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `subject` of this provider.
  Subject get subject;
}

class _UpdateSubjectProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateSubjectRef {
  _UpdateSubjectProviderElement(super.provider);

  @override
  Subject get subject => (origin as UpdateSubjectProvider).subject;
}

String _$deleteSubjectHash() => r'84431c1b2706f6607af8af0367e64464446e0f1f';

/// See also [deleteSubject].
@ProviderFor(deleteSubject)
const deleteSubjectProvider = DeleteSubjectFamily();

/// See also [deleteSubject].
class DeleteSubjectFamily extends Family<AsyncValue<void>> {
  /// See also [deleteSubject].
  const DeleteSubjectFamily();

  /// See also [deleteSubject].
  DeleteSubjectProvider call(
    String subjectId,
  ) {
    return DeleteSubjectProvider(
      subjectId,
    );
  }

  @override
  DeleteSubjectProvider getProviderOverride(
    covariant DeleteSubjectProvider provider,
  ) {
    return call(
      provider.subjectId,
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
  String? get name => r'deleteSubjectProvider';
}

/// See also [deleteSubject].
class DeleteSubjectProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteSubject].
  DeleteSubjectProvider(
    String subjectId,
  ) : this._internal(
          (ref) => deleteSubject(
            ref as DeleteSubjectRef,
            subjectId,
          ),
          from: deleteSubjectProvider,
          name: r'deleteSubjectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteSubjectHash,
          dependencies: DeleteSubjectFamily._dependencies,
          allTransitiveDependencies:
              DeleteSubjectFamily._allTransitiveDependencies,
          subjectId: subjectId,
        );

  DeleteSubjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
  }) : super.internal();

  final String subjectId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteSubjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteSubjectProvider._internal(
        (ref) => create(ref as DeleteSubjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteSubjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteSubjectProvider && other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteSubjectRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `subjectId` of this provider.
  String get subjectId;
}

class _DeleteSubjectProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteSubjectRef {
  _DeleteSubjectProviderElement(super.provider);

  @override
  String get subjectId => (origin as DeleteSubjectProvider).subjectId;
}

String _$reorderSubjectsHash() => r'63b224deae5bda58347daf11a3e61ced8fd2a11d';

/// See also [reorderSubjects].
@ProviderFor(reorderSubjects)
const reorderSubjectsProvider = ReorderSubjectsFamily();

/// See also [reorderSubjects].
class ReorderSubjectsFamily extends Family<AsyncValue<void>> {
  /// See also [reorderSubjects].
  const ReorderSubjectsFamily();

  /// See also [reorderSubjects].
  ReorderSubjectsProvider call(
    List<Subject> subjects,
  ) {
    return ReorderSubjectsProvider(
      subjects,
    );
  }

  @override
  ReorderSubjectsProvider getProviderOverride(
    covariant ReorderSubjectsProvider provider,
  ) {
    return call(
      provider.subjects,
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
  String? get name => r'reorderSubjectsProvider';
}

/// See also [reorderSubjects].
class ReorderSubjectsProvider extends AutoDisposeFutureProvider<void> {
  /// See also [reorderSubjects].
  ReorderSubjectsProvider(
    List<Subject> subjects,
  ) : this._internal(
          (ref) => reorderSubjects(
            ref as ReorderSubjectsRef,
            subjects,
          ),
          from: reorderSubjectsProvider,
          name: r'reorderSubjectsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reorderSubjectsHash,
          dependencies: ReorderSubjectsFamily._dependencies,
          allTransitiveDependencies:
              ReorderSubjectsFamily._allTransitiveDependencies,
          subjects: subjects,
        );

  ReorderSubjectsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjects,
  }) : super.internal();

  final List<Subject> subjects;

  @override
  Override overrideWith(
    FutureOr<void> Function(ReorderSubjectsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReorderSubjectsProvider._internal(
        (ref) => create(ref as ReorderSubjectsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjects: subjects,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ReorderSubjectsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReorderSubjectsProvider && other.subjects == subjects;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjects.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReorderSubjectsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `subjects` of this provider.
  List<Subject> get subjects;
}

class _ReorderSubjectsProviderElement
    extends AutoDisposeFutureProviderElement<void> with ReorderSubjectsRef {
  _ReorderSubjectsProviderElement(super.provider);

  @override
  List<Subject> get subjects => (origin as ReorderSubjectsProvider).subjects;
}

String _$addChapterHash() => r'ba26ad5472ac2717d7b5afec015a9c6f70ff5aaa';

/// See also [addChapter].
@ProviderFor(addChapter)
const addChapterProvider = AddChapterFamily();

/// See also [addChapter].
class AddChapterFamily extends Family<AsyncValue<void>> {
  /// See also [addChapter].
  const AddChapterFamily();

  /// See also [addChapter].
  AddChapterProvider call({
    required String subjectId,
    required String chapterName,
  }) {
    return AddChapterProvider(
      subjectId: subjectId,
      chapterName: chapterName,
    );
  }

  @override
  AddChapterProvider getProviderOverride(
    covariant AddChapterProvider provider,
  ) {
    return call(
      subjectId: provider.subjectId,
      chapterName: provider.chapterName,
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
  String? get name => r'addChapterProvider';
}

/// See also [addChapter].
class AddChapterProvider extends AutoDisposeFutureProvider<void> {
  /// See also [addChapter].
  AddChapterProvider({
    required String subjectId,
    required String chapterName,
  }) : this._internal(
          (ref) => addChapter(
            ref as AddChapterRef,
            subjectId: subjectId,
            chapterName: chapterName,
          ),
          from: addChapterProvider,
          name: r'addChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addChapterHash,
          dependencies: AddChapterFamily._dependencies,
          allTransitiveDependencies:
              AddChapterFamily._allTransitiveDependencies,
          subjectId: subjectId,
          chapterName: chapterName,
        );

  AddChapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
    required this.chapterName,
  }) : super.internal();

  final String subjectId;
  final String chapterName;

  @override
  Override overrideWith(
    FutureOr<void> Function(AddChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddChapterProvider._internal(
        (ref) => create(ref as AddChapterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
        chapterName: chapterName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddChapterProvider &&
        other.subjectId == subjectId &&
        other.chapterName == chapterName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, chapterName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddChapterRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `subjectId` of this provider.
  String get subjectId;

  /// The parameter `chapterName` of this provider.
  String get chapterName;
}

class _AddChapterProviderElement extends AutoDisposeFutureProviderElement<void>
    with AddChapterRef {
  _AddChapterProviderElement(super.provider);

  @override
  String get subjectId => (origin as AddChapterProvider).subjectId;
  @override
  String get chapterName => (origin as AddChapterProvider).chapterName;
}

String _$updateChapterHash() => r'851f08487821eb7455037a1ddf7953bb72a5f1d9';

/// See also [updateChapter].
@ProviderFor(updateChapter)
const updateChapterProvider = UpdateChapterFamily();

/// See also [updateChapter].
class UpdateChapterFamily extends Family<AsyncValue<void>> {
  /// See also [updateChapter].
  const UpdateChapterFamily();

  /// See also [updateChapter].
  UpdateChapterProvider call(
    Chapter chapter,
  ) {
    return UpdateChapterProvider(
      chapter,
    );
  }

  @override
  UpdateChapterProvider getProviderOverride(
    covariant UpdateChapterProvider provider,
  ) {
    return call(
      provider.chapter,
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
  String? get name => r'updateChapterProvider';
}

/// See also [updateChapter].
class UpdateChapterProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateChapter].
  UpdateChapterProvider(
    Chapter chapter,
  ) : this._internal(
          (ref) => updateChapter(
            ref as UpdateChapterRef,
            chapter,
          ),
          from: updateChapterProvider,
          name: r'updateChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateChapterHash,
          dependencies: UpdateChapterFamily._dependencies,
          allTransitiveDependencies:
              UpdateChapterFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  UpdateChapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateChapterProvider._internal(
        (ref) => create(ref as UpdateChapterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateChapterProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateChapterRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _UpdateChapterProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateChapterRef {
  _UpdateChapterProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as UpdateChapterProvider).chapter;
}

String _$toggleChapterHash() => r'd13294dd557d189e6f6f83432b289e6d2f8a41fa';

/// See also [toggleChapter].
@ProviderFor(toggleChapter)
const toggleChapterProvider = ToggleChapterFamily();

/// See also [toggleChapter].
class ToggleChapterFamily extends Family<AsyncValue<void>> {
  /// See also [toggleChapter].
  const ToggleChapterFamily();

  /// See also [toggleChapter].
  ToggleChapterProvider call(
    Chapter chapter,
  ) {
    return ToggleChapterProvider(
      chapter,
    );
  }

  @override
  ToggleChapterProvider getProviderOverride(
    covariant ToggleChapterProvider provider,
  ) {
    return call(
      provider.chapter,
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
  String? get name => r'toggleChapterProvider';
}

/// See also [toggleChapter].
class ToggleChapterProvider extends AutoDisposeFutureProvider<void> {
  /// See also [toggleChapter].
  ToggleChapterProvider(
    Chapter chapter,
  ) : this._internal(
          (ref) => toggleChapter(
            ref as ToggleChapterRef,
            chapter,
          ),
          from: toggleChapterProvider,
          name: r'toggleChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$toggleChapterHash,
          dependencies: ToggleChapterFamily._dependencies,
          allTransitiveDependencies:
              ToggleChapterFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  ToggleChapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  Override overrideWith(
    FutureOr<void> Function(ToggleChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ToggleChapterProvider._internal(
        (ref) => create(ref as ToggleChapterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ToggleChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToggleChapterProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ToggleChapterRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _ToggleChapterProviderElement
    extends AutoDisposeFutureProviderElement<void> with ToggleChapterRef {
  _ToggleChapterProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as ToggleChapterProvider).chapter;
}

String _$deleteChapterHash() => r'9d1d35234bc958b606643d57eebc304eb43e3a4a';

/// See also [deleteChapter].
@ProviderFor(deleteChapter)
const deleteChapterProvider = DeleteChapterFamily();

/// See also [deleteChapter].
class DeleteChapterFamily extends Family<AsyncValue<void>> {
  /// See also [deleteChapter].
  const DeleteChapterFamily();

  /// See also [deleteChapter].
  DeleteChapterProvider call(
    String chapterId,
  ) {
    return DeleteChapterProvider(
      chapterId,
    );
  }

  @override
  DeleteChapterProvider getProviderOverride(
    covariant DeleteChapterProvider provider,
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
  String? get name => r'deleteChapterProvider';
}

/// See also [deleteChapter].
class DeleteChapterProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteChapter].
  DeleteChapterProvider(
    String chapterId,
  ) : this._internal(
          (ref) => deleteChapter(
            ref as DeleteChapterRef,
            chapterId,
          ),
          from: deleteChapterProvider,
          name: r'deleteChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteChapterHash,
          dependencies: DeleteChapterFamily._dependencies,
          allTransitiveDependencies:
              DeleteChapterFamily._allTransitiveDependencies,
          chapterId: chapterId,
        );

  DeleteChapterProvider._internal(
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
  Override overrideWith(
    FutureOr<void> Function(DeleteChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteChapterProvider._internal(
        (ref) => create(ref as DeleteChapterRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteChapterProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteChapterRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _DeleteChapterProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteChapterRef {
  _DeleteChapterProviderElement(super.provider);

  @override
  String get chapterId => (origin as DeleteChapterProvider).chapterId;
}

String _$reorderChaptersHash() => r'c982bd0eef607432f58081e914077c818834e670';

/// See also [reorderChapters].
@ProviderFor(reorderChapters)
const reorderChaptersProvider = ReorderChaptersFamily();

/// See also [reorderChapters].
class ReorderChaptersFamily extends Family<AsyncValue<void>> {
  /// See also [reorderChapters].
  const ReorderChaptersFamily();

  /// See also [reorderChapters].
  ReorderChaptersProvider call(
    List<Chapter> chapters,
  ) {
    return ReorderChaptersProvider(
      chapters,
    );
  }

  @override
  ReorderChaptersProvider getProviderOverride(
    covariant ReorderChaptersProvider provider,
  ) {
    return call(
      provider.chapters,
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
  String? get name => r'reorderChaptersProvider';
}

/// See also [reorderChapters].
class ReorderChaptersProvider extends AutoDisposeFutureProvider<void> {
  /// See also [reorderChapters].
  ReorderChaptersProvider(
    List<Chapter> chapters,
  ) : this._internal(
          (ref) => reorderChapters(
            ref as ReorderChaptersRef,
            chapters,
          ),
          from: reorderChaptersProvider,
          name: r'reorderChaptersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reorderChaptersHash,
          dependencies: ReorderChaptersFamily._dependencies,
          allTransitiveDependencies:
              ReorderChaptersFamily._allTransitiveDependencies,
          chapters: chapters,
        );

  ReorderChaptersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapters,
  }) : super.internal();

  final List<Chapter> chapters;

  @override
  Override overrideWith(
    FutureOr<void> Function(ReorderChaptersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReorderChaptersProvider._internal(
        (ref) => create(ref as ReorderChaptersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapters: chapters,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ReorderChaptersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReorderChaptersProvider && other.chapters == chapters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapters.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReorderChaptersRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chapters` of this provider.
  List<Chapter> get chapters;
}

class _ReorderChaptersProviderElement
    extends AutoDisposeFutureProviderElement<void> with ReorderChaptersRef {
  _ReorderChaptersProviderElement(super.provider);

  @override
  List<Chapter> get chapters => (origin as ReorderChaptersProvider).chapters;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
