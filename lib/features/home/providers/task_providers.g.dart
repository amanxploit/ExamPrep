// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examTasksHash() => r'2066e09cc94579d08eed1494f412e1b1be7ac4c2';

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

/// See also [examTasks].
@ProviderFor(examTasks)
const examTasksProvider = ExamTasksFamily();

/// See also [examTasks].
class ExamTasksFamily extends Family<AsyncValue<List<StudyTask>>> {
  /// See also [examTasks].
  const ExamTasksFamily();

  /// See also [examTasks].
  ExamTasksProvider call(
    String examId,
  ) {
    return ExamTasksProvider(
      examId,
    );
  }

  @override
  ExamTasksProvider getProviderOverride(
    covariant ExamTasksProvider provider,
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
  String? get name => r'examTasksProvider';
}

/// See also [examTasks].
class ExamTasksProvider extends AutoDisposeStreamProvider<List<StudyTask>> {
  /// See also [examTasks].
  ExamTasksProvider(
    String examId,
  ) : this._internal(
          (ref) => examTasks(
            ref as ExamTasksRef,
            examId,
          ),
          from: examTasksProvider,
          name: r'examTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$examTasksHash,
          dependencies: ExamTasksFamily._dependencies,
          allTransitiveDependencies: ExamTasksFamily._allTransitiveDependencies,
          examId: examId,
        );

  ExamTasksProvider._internal(
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
    Stream<List<StudyTask>> Function(ExamTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExamTasksProvider._internal(
        (ref) => create(ref as ExamTasksRef),
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
  AutoDisposeStreamProviderElement<List<StudyTask>> createElement() {
    return _ExamTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamTasksProvider && other.examId == examId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ExamTasksRef on AutoDisposeStreamProviderRef<List<StudyTask>> {
  /// The parameter `examId` of this provider.
  String get examId;
}

class _ExamTasksProviderElement
    extends AutoDisposeStreamProviderElement<List<StudyTask>>
    with ExamTasksRef {
  _ExamTasksProviderElement(super.provider);

  @override
  String get examId => (origin as ExamTasksProvider).examId;
}

String _$addTaskHash() => r'0cc7eb308ee2784e421bfdea5e394070eaefb111';

/// See also [addTask].
@ProviderFor(addTask)
const addTaskProvider = AddTaskFamily();

/// See also [addTask].
class AddTaskFamily extends Family<AsyncValue<void>> {
  /// See also [addTask].
  const AddTaskFamily();

  /// See also [addTask].
  AddTaskProvider call({
    required String examId,
    required String title,
    String? subjectId,
    String? chapterId,
    required DateTime dueDate,
  }) {
    return AddTaskProvider(
      examId: examId,
      title: title,
      subjectId: subjectId,
      chapterId: chapterId,
      dueDate: dueDate,
    );
  }

  @override
  AddTaskProvider getProviderOverride(
    covariant AddTaskProvider provider,
  ) {
    return call(
      examId: provider.examId,
      title: provider.title,
      subjectId: provider.subjectId,
      chapterId: provider.chapterId,
      dueDate: provider.dueDate,
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
  String? get name => r'addTaskProvider';
}

/// See also [addTask].
class AddTaskProvider extends AutoDisposeFutureProvider<void> {
  /// See also [addTask].
  AddTaskProvider({
    required String examId,
    required String title,
    String? subjectId,
    String? chapterId,
    required DateTime dueDate,
  }) : this._internal(
          (ref) => addTask(
            ref as AddTaskRef,
            examId: examId,
            title: title,
            subjectId: subjectId,
            chapterId: chapterId,
            dueDate: dueDate,
          ),
          from: addTaskProvider,
          name: r'addTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addTaskHash,
          dependencies: AddTaskFamily._dependencies,
          allTransitiveDependencies: AddTaskFamily._allTransitiveDependencies,
          examId: examId,
          title: title,
          subjectId: subjectId,
          chapterId: chapterId,
          dueDate: dueDate,
        );

  AddTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.examId,
    required this.title,
    required this.subjectId,
    required this.chapterId,
    required this.dueDate,
  }) : super.internal();

  final String examId;
  final String title;
  final String? subjectId;
  final String? chapterId;
  final DateTime dueDate;

  @override
  Override overrideWith(
    FutureOr<void> Function(AddTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddTaskProvider._internal(
        (ref) => create(ref as AddTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        examId: examId,
        title: title,
        subjectId: subjectId,
        chapterId: chapterId,
        dueDate: dueDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AddTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddTaskProvider &&
        other.examId == examId &&
        other.title == title &&
        other.subjectId == subjectId &&
        other.chapterId == chapterId &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, examId.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, dueDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `examId` of this provider.
  String get examId;

  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `subjectId` of this provider.
  String? get subjectId;

  /// The parameter `chapterId` of this provider.
  String? get chapterId;

  /// The parameter `dueDate` of this provider.
  DateTime get dueDate;
}

class _AddTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with AddTaskRef {
  _AddTaskProviderElement(super.provider);

  @override
  String get examId => (origin as AddTaskProvider).examId;
  @override
  String get title => (origin as AddTaskProvider).title;
  @override
  String? get subjectId => (origin as AddTaskProvider).subjectId;
  @override
  String? get chapterId => (origin as AddTaskProvider).chapterId;
  @override
  DateTime get dueDate => (origin as AddTaskProvider).dueDate;
}

String _$updateTaskHash() => r'2f93301df9354b99ebd6fb9474ee766fb1ea5226';

/// See also [updateTask].
@ProviderFor(updateTask)
const updateTaskProvider = UpdateTaskFamily();

/// See also [updateTask].
class UpdateTaskFamily extends Family<AsyncValue<void>> {
  /// See also [updateTask].
  const UpdateTaskFamily();

  /// See also [updateTask].
  UpdateTaskProvider call(
    StudyTask task,
  ) {
    return UpdateTaskProvider(
      task,
    );
  }

  @override
  UpdateTaskProvider getProviderOverride(
    covariant UpdateTaskProvider provider,
  ) {
    return call(
      provider.task,
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
  String? get name => r'updateTaskProvider';
}

/// See also [updateTask].
class UpdateTaskProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateTask].
  UpdateTaskProvider(
    StudyTask task,
  ) : this._internal(
          (ref) => updateTask(
            ref as UpdateTaskRef,
            task,
          ),
          from: updateTaskProvider,
          name: r'updateTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateTaskHash,
          dependencies: UpdateTaskFamily._dependencies,
          allTransitiveDependencies:
              UpdateTaskFamily._allTransitiveDependencies,
          task: task,
        );

  UpdateTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.task,
  }) : super.internal();

  final StudyTask task;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateTaskProvider._internal(
        (ref) => create(ref as UpdateTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        task: task,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateTaskProvider && other.task == task;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, task.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `task` of this provider.
  StudyTask get task;
}

class _UpdateTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with UpdateTaskRef {
  _UpdateTaskProviderElement(super.provider);

  @override
  StudyTask get task => (origin as UpdateTaskProvider).task;
}

String _$deleteTaskHash() => r'2dcdac56795e7e49e122437bd348f041b41a2473';

/// See also [deleteTask].
@ProviderFor(deleteTask)
const deleteTaskProvider = DeleteTaskFamily();

/// See also [deleteTask].
class DeleteTaskFamily extends Family<AsyncValue<void>> {
  /// See also [deleteTask].
  const DeleteTaskFamily();

  /// See also [deleteTask].
  DeleteTaskProvider call(
    String taskId,
  ) {
    return DeleteTaskProvider(
      taskId,
    );
  }

  @override
  DeleteTaskProvider getProviderOverride(
    covariant DeleteTaskProvider provider,
  ) {
    return call(
      provider.taskId,
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
  String? get name => r'deleteTaskProvider';
}

/// See also [deleteTask].
class DeleteTaskProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteTask].
  DeleteTaskProvider(
    String taskId,
  ) : this._internal(
          (ref) => deleteTask(
            ref as DeleteTaskRef,
            taskId,
          ),
          from: deleteTaskProvider,
          name: r'deleteTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteTaskHash,
          dependencies: DeleteTaskFamily._dependencies,
          allTransitiveDependencies:
              DeleteTaskFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  DeleteTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteTaskProvider._internal(
        (ref) => create(ref as DeleteTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteTaskProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _DeleteTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteTaskRef {
  _DeleteTaskProviderElement(super.provider);

  @override
  String get taskId => (origin as DeleteTaskProvider).taskId;
}

String _$toggleTaskHash() => r'e32f0b04a4fe8c50d5d0c84ba1dbcd3da76227f4';

/// See also [toggleTask].
@ProviderFor(toggleTask)
const toggleTaskProvider = ToggleTaskFamily();

/// See also [toggleTask].
class ToggleTaskFamily extends Family<AsyncValue<void>> {
  /// See also [toggleTask].
  const ToggleTaskFamily();

  /// See also [toggleTask].
  ToggleTaskProvider call(
    StudyTask task,
  ) {
    return ToggleTaskProvider(
      task,
    );
  }

  @override
  ToggleTaskProvider getProviderOverride(
    covariant ToggleTaskProvider provider,
  ) {
    return call(
      provider.task,
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
  String? get name => r'toggleTaskProvider';
}

/// See also [toggleTask].
class ToggleTaskProvider extends AutoDisposeFutureProvider<void> {
  /// See also [toggleTask].
  ToggleTaskProvider(
    StudyTask task,
  ) : this._internal(
          (ref) => toggleTask(
            ref as ToggleTaskRef,
            task,
          ),
          from: toggleTaskProvider,
          name: r'toggleTaskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$toggleTaskHash,
          dependencies: ToggleTaskFamily._dependencies,
          allTransitiveDependencies:
              ToggleTaskFamily._allTransitiveDependencies,
          task: task,
        );

  ToggleTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.task,
  }) : super.internal();

  final StudyTask task;

  @override
  Override overrideWith(
    FutureOr<void> Function(ToggleTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ToggleTaskProvider._internal(
        (ref) => create(ref as ToggleTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        task: task,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ToggleTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ToggleTaskProvider && other.task == task;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, task.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ToggleTaskRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `task` of this provider.
  StudyTask get task;
}

class _ToggleTaskProviderElement extends AutoDisposeFutureProviderElement<void>
    with ToggleTaskRef {
  _ToggleTaskProviderElement(super.provider);

  @override
  StudyTask get task => (origin as ToggleTaskProvider).task;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
