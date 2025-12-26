// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$departmentRepositoryHash() =>
    r'25fc83b51e1de093794825d8803da7069ff9f908';

/// Provider for DepartmentRepository
///
/// Copied from [departmentRepository].
@ProviderFor(departmentRepository)
final departmentRepositoryProvider =
    AutoDisposeProvider<DepartmentRepository>.internal(
      departmentRepository,
      name: r'departmentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$departmentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DepartmentRepositoryRef = AutoDisposeProviderRef<DepartmentRepository>;
String _$departmentsHash() => r'4f2cce4847556eeb298dc18e68d4c62e66912398';

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

/// Provider for all departments stream
///
/// Copied from [departments].
@ProviderFor(departments)
const departmentsProvider = DepartmentsFamily();

/// Provider for all departments stream
///
/// Copied from [departments].
class DepartmentsFamily extends Family<AsyncValue<List<DepartmentModel>>> {
  /// Provider for all departments stream
  ///
  /// Copied from [departments].
  const DepartmentsFamily();

  /// Provider for all departments stream
  ///
  /// Copied from [departments].
  DepartmentsProvider call({bool activeOnly = true}) {
    return DepartmentsProvider(activeOnly: activeOnly);
  }

  @override
  DepartmentsProvider getProviderOverride(
    covariant DepartmentsProvider provider,
  ) {
    return call(activeOnly: provider.activeOnly);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'departmentsProvider';
}

/// Provider for all departments stream
///
/// Copied from [departments].
class DepartmentsProvider
    extends AutoDisposeStreamProvider<List<DepartmentModel>> {
  /// Provider for all departments stream
  ///
  /// Copied from [departments].
  DepartmentsProvider({bool activeOnly = true})
    : this._internal(
        (ref) => departments(ref as DepartmentsRef, activeOnly: activeOnly),
        from: departmentsProvider,
        name: r'departmentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$departmentsHash,
        dependencies: DepartmentsFamily._dependencies,
        allTransitiveDependencies: DepartmentsFamily._allTransitiveDependencies,
        activeOnly: activeOnly,
      );

  DepartmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activeOnly,
  }) : super.internal();

  final bool activeOnly;

  @override
  Override overrideWith(
    Stream<List<DepartmentModel>> Function(DepartmentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DepartmentsProvider._internal(
        (ref) => create(ref as DepartmentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activeOnly: activeOnly,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DepartmentModel>> createElement() {
    return _DepartmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentsProvider && other.activeOnly == activeOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activeOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DepartmentsRef on AutoDisposeStreamProviderRef<List<DepartmentModel>> {
  /// The parameter `activeOnly` of this provider.
  bool get activeOnly;
}

class _DepartmentsProviderElement
    extends AutoDisposeStreamProviderElement<List<DepartmentModel>>
    with DepartmentsRef {
  _DepartmentsProviderElement(super.provider);

  @override
  bool get activeOnly => (origin as DepartmentsProvider).activeOnly;
}

String _$activeDepartmentsHash() => r'fc25e2e408ae21963d673bdee980d729b1ca62f0';

/// Provider for active departments only
///
/// Copied from [activeDepartments].
@ProviderFor(activeDepartments)
final activeDepartmentsProvider =
    AutoDisposeStreamProvider<List<DepartmentModel>>.internal(
      activeDepartments,
      name: r'activeDepartmentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeDepartmentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveDepartmentsRef =
    AutoDisposeStreamProviderRef<List<DepartmentModel>>;
String _$departmentHash() => r'0703ad60fabbfaf442b04dd2684d69ad0ad72a7b';

/// Provider for a single department
///
/// Copied from [department].
@ProviderFor(department)
const departmentProvider = DepartmentFamily();

/// Provider for a single department
///
/// Copied from [department].
class DepartmentFamily extends Family<AsyncValue<DepartmentModel?>> {
  /// Provider for a single department
  ///
  /// Copied from [department].
  const DepartmentFamily();

  /// Provider for a single department
  ///
  /// Copied from [department].
  DepartmentProvider call(String id) {
    return DepartmentProvider(id);
  }

  @override
  DepartmentProvider getProviderOverride(
    covariant DepartmentProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'departmentProvider';
}

/// Provider for a single department
///
/// Copied from [department].
class DepartmentProvider extends AutoDisposeFutureProvider<DepartmentModel?> {
  /// Provider for a single department
  ///
  /// Copied from [department].
  DepartmentProvider(String id)
    : this._internal(
        (ref) => department(ref as DepartmentRef, id),
        from: departmentProvider,
        name: r'departmentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$departmentHash,
        dependencies: DepartmentFamily._dependencies,
        allTransitiveDependencies: DepartmentFamily._allTransitiveDependencies,
        id: id,
      );

  DepartmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<DepartmentModel?> Function(DepartmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DepartmentProvider._internal(
        (ref) => create(ref as DepartmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DepartmentModel?> createElement() {
    return _DepartmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DepartmentRef on AutoDisposeFutureProviderRef<DepartmentModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DepartmentProviderElement
    extends AutoDisposeFutureProviderElement<DepartmentModel?>
    with DepartmentRef {
  _DepartmentProviderElement(super.provider);

  @override
  String get id => (origin as DepartmentProvider).id;
}

String _$departmentCountHash() => r'dc3f9f8bc9e8ef9fc059e942bd963f83d4cf7a5e';

/// Provider for department count
///
/// Copied from [departmentCount].
@ProviderFor(departmentCount)
const departmentCountProvider = DepartmentCountFamily();

/// Provider for department count
///
/// Copied from [departmentCount].
class DepartmentCountFamily extends Family<AsyncValue<int>> {
  /// Provider for department count
  ///
  /// Copied from [departmentCount].
  const DepartmentCountFamily();

  /// Provider for department count
  ///
  /// Copied from [departmentCount].
  DepartmentCountProvider call({bool activeOnly = true}) {
    return DepartmentCountProvider(activeOnly: activeOnly);
  }

  @override
  DepartmentCountProvider getProviderOverride(
    covariant DepartmentCountProvider provider,
  ) {
    return call(activeOnly: provider.activeOnly);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'departmentCountProvider';
}

/// Provider for department count
///
/// Copied from [departmentCount].
class DepartmentCountProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for department count
  ///
  /// Copied from [departmentCount].
  DepartmentCountProvider({bool activeOnly = true})
    : this._internal(
        (ref) =>
            departmentCount(ref as DepartmentCountRef, activeOnly: activeOnly),
        from: departmentCountProvider,
        name: r'departmentCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$departmentCountHash,
        dependencies: DepartmentCountFamily._dependencies,
        allTransitiveDependencies:
            DepartmentCountFamily._allTransitiveDependencies,
        activeOnly: activeOnly,
      );

  DepartmentCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activeOnly,
  }) : super.internal();

  final bool activeOnly;

  @override
  Override overrideWith(
    FutureOr<int> Function(DepartmentCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DepartmentCountProvider._internal(
        (ref) => create(ref as DepartmentCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activeOnly: activeOnly,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _DepartmentCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DepartmentCountProvider && other.activeOnly == activeOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activeOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DepartmentCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `activeOnly` of this provider.
  bool get activeOnly;
}

class _DepartmentCountProviderElement
    extends AutoDisposeFutureProviderElement<int>
    with DepartmentCountRef {
  _DepartmentCountProviderElement(super.provider);

  @override
  bool get activeOnly => (origin as DepartmentCountProvider).activeOnly;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
