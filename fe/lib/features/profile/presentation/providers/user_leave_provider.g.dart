// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_leave_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userLeaveApplicationsHash() =>
    r'292406c3ec9c563cdd56a1a7a52ac9c84db996f5';

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

/// Provider for a specific user's leave applications
///
/// Copied from [userLeaveApplications].
@ProviderFor(userLeaveApplications)
const userLeaveApplicationsProvider = UserLeaveApplicationsFamily();

/// Provider for a specific user's leave applications
///
/// Copied from [userLeaveApplications].
class UserLeaveApplicationsFamily
    extends Family<AsyncValue<List<LeaveApplication>>> {
  /// Provider for a specific user's leave applications
  ///
  /// Copied from [userLeaveApplications].
  const UserLeaveApplicationsFamily();

  /// Provider for a specific user's leave applications
  ///
  /// Copied from [userLeaveApplications].
  UserLeaveApplicationsProvider call(String userId) {
    return UserLeaveApplicationsProvider(userId);
  }

  @override
  UserLeaveApplicationsProvider getProviderOverride(
    covariant UserLeaveApplicationsProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userLeaveApplicationsProvider';
}

/// Provider for a specific user's leave applications
///
/// Copied from [userLeaveApplications].
class UserLeaveApplicationsProvider
    extends AutoDisposeStreamProvider<List<LeaveApplication>> {
  /// Provider for a specific user's leave applications
  ///
  /// Copied from [userLeaveApplications].
  UserLeaveApplicationsProvider(String userId)
    : this._internal(
        (ref) => userLeaveApplications(ref as UserLeaveApplicationsRef, userId),
        from: userLeaveApplicationsProvider,
        name: r'userLeaveApplicationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userLeaveApplicationsHash,
        dependencies: UserLeaveApplicationsFamily._dependencies,
        allTransitiveDependencies:
            UserLeaveApplicationsFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserLeaveApplicationsProvider._internal(
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
    Stream<List<LeaveApplication>> Function(UserLeaveApplicationsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserLeaveApplicationsProvider._internal(
        (ref) => create(ref as UserLeaveApplicationsRef),
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
  AutoDisposeStreamProviderElement<List<LeaveApplication>> createElement() {
    return _UserLeaveApplicationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserLeaveApplicationsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserLeaveApplicationsRef
    on AutoDisposeStreamProviderRef<List<LeaveApplication>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserLeaveApplicationsProviderElement
    extends AutoDisposeStreamProviderElement<List<LeaveApplication>>
    with UserLeaveApplicationsRef {
  _UserLeaveApplicationsProviderElement(super.provider);

  @override
  String get userId => (origin as UserLeaveApplicationsProvider).userId;
}

String _$userLeaveBalanceHash() => r'a94633921f4826c9f200a6a026b6d1d6eea1d83e';

/// Provider for calculating user's leave balance (uses Firestore config)
///
/// Copied from [userLeaveBalance].
@ProviderFor(userLeaveBalance)
const userLeaveBalanceProvider = UserLeaveBalanceFamily();

/// Provider for calculating user's leave balance (uses Firestore config)
///
/// Copied from [userLeaveBalance].
class UserLeaveBalanceFamily
    extends Family<AsyncValue<Map<LeaveType, LeaveBalance>>> {
  /// Provider for calculating user's leave balance (uses Firestore config)
  ///
  /// Copied from [userLeaveBalance].
  const UserLeaveBalanceFamily();

  /// Provider for calculating user's leave balance (uses Firestore config)
  ///
  /// Copied from [userLeaveBalance].
  UserLeaveBalanceProvider call(String userId) {
    return UserLeaveBalanceProvider(userId);
  }

  @override
  UserLeaveBalanceProvider getProviderOverride(
    covariant UserLeaveBalanceProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userLeaveBalanceProvider';
}

/// Provider for calculating user's leave balance (uses Firestore config)
///
/// Copied from [userLeaveBalance].
class UserLeaveBalanceProvider
    extends AutoDisposeFutureProvider<Map<LeaveType, LeaveBalance>> {
  /// Provider for calculating user's leave balance (uses Firestore config)
  ///
  /// Copied from [userLeaveBalance].
  UserLeaveBalanceProvider(String userId)
    : this._internal(
        (ref) => userLeaveBalance(ref as UserLeaveBalanceRef, userId),
        from: userLeaveBalanceProvider,
        name: r'userLeaveBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userLeaveBalanceHash,
        dependencies: UserLeaveBalanceFamily._dependencies,
        allTransitiveDependencies:
            UserLeaveBalanceFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserLeaveBalanceProvider._internal(
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
    FutureOr<Map<LeaveType, LeaveBalance>> Function(
      UserLeaveBalanceRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserLeaveBalanceProvider._internal(
        (ref) => create(ref as UserLeaveBalanceRef),
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
  AutoDisposeFutureProviderElement<Map<LeaveType, LeaveBalance>>
  createElement() {
    return _UserLeaveBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserLeaveBalanceProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserLeaveBalanceRef
    on AutoDisposeFutureProviderRef<Map<LeaveType, LeaveBalance>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserLeaveBalanceProviderElement
    extends AutoDisposeFutureProviderElement<Map<LeaveType, LeaveBalance>>
    with UserLeaveBalanceRef {
  _UserLeaveBalanceProviderElement(super.provider);

  @override
  String get userId => (origin as UserLeaveBalanceProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
