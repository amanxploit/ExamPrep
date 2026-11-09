// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsHash() => r'3303381778bdabfcda04585a5d3cf56d7d8b2c60';

/// See also [settings].
@ProviderFor(settings)
final settingsProvider = AutoDisposeStreamProvider<Settings>.internal(
  settings,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsRef = AutoDisposeStreamProviderRef<Settings>;
String _$updateSettingsHash() => r'9cffffa5508e7604b54bacd8e245b90f787c1ae1';

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

/// See also [updateSettings].
@ProviderFor(updateSettings)
const updateSettingsProvider = UpdateSettingsFamily();

/// See also [updateSettings].
class UpdateSettingsFamily extends Family<AsyncValue<void>> {
  /// See also [updateSettings].
  const UpdateSettingsFamily();

  /// See also [updateSettings].
  UpdateSettingsProvider call(
    Settings settings,
  ) {
    return UpdateSettingsProvider(
      settings,
    );
  }

  @override
  UpdateSettingsProvider getProviderOverride(
    covariant UpdateSettingsProvider provider,
  ) {
    return call(
      provider.settings,
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
  String? get name => r'updateSettingsProvider';
}

/// See also [updateSettings].
class UpdateSettingsProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateSettings].
  UpdateSettingsProvider(
    Settings settings,
  ) : this._internal(
          (ref) => updateSettings(
            ref as UpdateSettingsRef,
            settings,
          ),
          from: updateSettingsProvider,
          name: r'updateSettingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateSettingsHash,
          dependencies: UpdateSettingsFamily._dependencies,
          allTransitiveDependencies:
              UpdateSettingsFamily._allTransitiveDependencies,
          settings: settings,
        );

  UpdateSettingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.settings,
  }) : super.internal();

  final Settings settings;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateSettingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateSettingsProvider._internal(
        (ref) => create(ref as UpdateSettingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateSettingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateSettingsProvider && other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateSettingsRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _UpdateSettingsProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateSettingsRef {
  _UpdateSettingsProviderElement(super.provider);

  @override
  Settings get settings => (origin as UpdateSettingsProvider).settings;
}

String _$resetAllDataHash() => r'864f9395ecb92aed7be11b61f2ba3a065dfc150e';

/// See also [resetAllData].
@ProviderFor(resetAllData)
final resetAllDataProvider = AutoDisposeFutureProvider<void>.internal(
  resetAllData,
  name: r'resetAllDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resetAllDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ResetAllDataRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
