// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dept_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deptEmployeesHash() => r'044ac01d018b91013ccb75827953b9e229cf09cb';

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

/// Provider for department employees
///
/// Copied from [deptEmployees].
@ProviderFor(deptEmployees)
const deptEmployeesProvider = DeptEmployeesFamily();

/// Provider for department employees
///
/// Copied from [deptEmployees].
class DeptEmployeesFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Provider for department employees
  ///
  /// Copied from [deptEmployees].
  const DeptEmployeesFamily();

  /// Provider for department employees
  ///
  /// Copied from [deptEmployees].
  DeptEmployeesProvider call(String departmentId) {
    return DeptEmployeesProvider(departmentId);
  }

  @override
  DeptEmployeesProvider getProviderOverride(
    covariant DeptEmployeesProvider provider,
  ) {
    return call(provider.departmentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deptEmployeesProvider';
}

/// Provider for department employees
///
/// Copied from [deptEmployees].
class DeptEmployeesProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// Provider for department employees
  ///
  /// Copied from [deptEmployees].
  DeptEmployeesProvider(String departmentId)
    : this._internal(
        (ref) => deptEmployees(ref as DeptEmployeesRef, departmentId),
        from: deptEmployeesProvider,
        name: r'deptEmployeesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deptEmployeesHash,
        dependencies: DeptEmployeesFamily._dependencies,
        allTransitiveDependencies:
            DeptEmployeesFamily._allTransitiveDependencies,
        departmentId: departmentId,
      );

  DeptEmployeesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.departmentId,
  }) : super.internal();

  final String departmentId;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(DeptEmployeesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeptEmployeesProvider._internal(
        (ref) => create(ref as DeptEmployeesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        departmentId: departmentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _DeptEmployeesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeptEmployeesProvider && other.departmentId == departmentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, departmentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeptEmployeesRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `departmentId` of this provider.
  String get departmentId;
}

class _DeptEmployeesProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with DeptEmployeesRef {
  _DeptEmployeesProviderElement(super.provider);

  @override
  String get departmentId => (origin as DeptEmployeesProvider).departmentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
