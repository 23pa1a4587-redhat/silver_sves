// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'85254bb39f51f0976f264fe33c17df8cde126fee';

/// Provider for UserRepository (admin operations)
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$usersHash() => r'd7f3be011d1cfa4bb055303599c41a4ecced0d32';

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

/// Provider for all users stream
///
/// Copied from [users].
@ProviderFor(users)
const usersProvider = UsersFamily();

/// Provider for all users stream
///
/// Copied from [users].
class UsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Provider for all users stream
  ///
  /// Copied from [users].
  const UsersFamily();

  /// Provider for all users stream
  ///
  /// Copied from [users].
  UsersProvider call({
    bool activeOnly = false,
    UserRole? role,
    String? departmentId,
  }) {
    return UsersProvider(
      activeOnly: activeOnly,
      role: role,
      departmentId: departmentId,
    );
  }

  @override
  UsersProvider getProviderOverride(covariant UsersProvider provider) {
    return call(
      activeOnly: provider.activeOnly,
      role: provider.role,
      departmentId: provider.departmentId,
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
  String? get name => r'usersProvider';
}

/// Provider for all users stream
///
/// Copied from [users].
class UsersProvider extends AutoDisposeStreamProvider<List<UserModel>> {
  /// Provider for all users stream
  ///
  /// Copied from [users].
  UsersProvider({bool activeOnly = false, UserRole? role, String? departmentId})
    : this._internal(
        (ref) => users(
          ref as UsersRef,
          activeOnly: activeOnly,
          role: role,
          departmentId: departmentId,
        ),
        from: usersProvider,
        name: r'usersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$usersHash,
        dependencies: UsersFamily._dependencies,
        allTransitiveDependencies: UsersFamily._allTransitiveDependencies,
        activeOnly: activeOnly,
        role: role,
        departmentId: departmentId,
      );

  UsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activeOnly,
    required this.role,
    required this.departmentId,
  }) : super.internal();

  final bool activeOnly;
  final UserRole? role;
  final String? departmentId;

  @override
  Override overrideWith(
    Stream<List<UserModel>> Function(UsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersProvider._internal(
        (ref) => create(ref as UsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activeOnly: activeOnly,
        role: role,
        departmentId: departmentId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _UsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersProvider &&
        other.activeOnly == activeOnly &&
        other.role == role &&
        other.departmentId == departmentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activeOnly.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);
    hash = _SystemHash.combine(hash, departmentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `activeOnly` of this provider.
  bool get activeOnly;

  /// The parameter `role` of this provider.
  UserRole? get role;

  /// The parameter `departmentId` of this provider.
  String? get departmentId;
}

class _UsersProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with UsersRef {
  _UsersProviderElement(super.provider);

  @override
  bool get activeOnly => (origin as UsersProvider).activeOnly;
  @override
  UserRole? get role => (origin as UsersProvider).role;
  @override
  String? get departmentId => (origin as UsersProvider).departmentId;
}

String _$userHash() => r'4e09b566e631efddb08f689160ec5fcdaf7c6995';

/// Provider for a single user
///
/// Copied from [user].
@ProviderFor(user)
const userProvider = UserFamily();

/// Provider for a single user
///
/// Copied from [user].
class UserFamily extends Family<AsyncValue<UserModel?>> {
  /// Provider for a single user
  ///
  /// Copied from [user].
  const UserFamily();

  /// Provider for a single user
  ///
  /// Copied from [user].
  UserProvider call(String id) {
    return UserProvider(id);
  }

  @override
  UserProvider getProviderOverride(covariant UserProvider provider) {
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
  String? get name => r'userProvider';
}

/// Provider for a single user
///
/// Copied from [user].
class UserProvider extends AutoDisposeFutureProvider<UserModel?> {
  /// Provider for a single user
  ///
  /// Copied from [user].
  UserProvider(String id)
    : this._internal(
        (ref) => user(ref as UserRef, id),
        from: userProvider,
        name: r'userProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userHash,
        dependencies: UserFamily._dependencies,
        allTransitiveDependencies: UserFamily._allTransitiveDependencies,
        id: id,
      );

  UserProvider._internal(
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
    FutureOr<UserModel?> Function(UserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProvider._internal(
        (ref) => create(ref as UserRef),
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
  AutoDisposeFutureProviderElement<UserModel?> createElement() {
    return _UserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.id == id;
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
mixin UserRef on AutoDisposeFutureProviderRef<UserModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserProviderElement extends AutoDisposeFutureProviderElement<UserModel?>
    with UserRef {
  _UserProviderElement(super.provider);

  @override
  String get id => (origin as UserProvider).id;
}

String _$searchUsersHash() => r'8adcf983ac7ef60f2183ccfebc00a272769c7eae';

/// Provider for user search
///
/// Copied from [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// Provider for user search
///
/// Copied from [searchUsers].
class SearchUsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// Provider for user search
  ///
  /// Copied from [searchUsers].
  const SearchUsersFamily();

  /// Provider for user search
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider call(String query) {
    return SearchUsersProvider(query);
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchUsersProvider';
}

/// Provider for user search
///
/// Copied from [searchUsers].
class SearchUsersProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// Provider for user search
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider(String query)
    : this._internal(
        (ref) => searchUsers(ref as SearchUsersRef, query),
        from: searchUsersProvider,
        name: r'searchUsersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchUsersHash,
        dependencies: SearchUsersFamily._dependencies,
        allTransitiveDependencies: SearchUsersFamily._allTransitiveDependencies,
        query: query,
      );

  SearchUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<UserModel>> Function(SearchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get query => (origin as SearchUsersProvider).query;
}

String _$userCountHash() => r'9336b206a130028ce792b9f604746a7c1e5bd02c';

/// Provider for user count
///
/// Copied from [userCount].
@ProviderFor(userCount)
const userCountProvider = UserCountFamily();

/// Provider for user count
///
/// Copied from [userCount].
class UserCountFamily extends Family<AsyncValue<int>> {
  /// Provider for user count
  ///
  /// Copied from [userCount].
  const UserCountFamily();

  /// Provider for user count
  ///
  /// Copied from [userCount].
  UserCountProvider call({bool activeOnly = true}) {
    return UserCountProvider(activeOnly: activeOnly);
  }

  @override
  UserCountProvider getProviderOverride(covariant UserCountProvider provider) {
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
  String? get name => r'userCountProvider';
}

/// Provider for user count
///
/// Copied from [userCount].
class UserCountProvider extends AutoDisposeFutureProvider<int> {
  /// Provider for user count
  ///
  /// Copied from [userCount].
  UserCountProvider({bool activeOnly = true})
    : this._internal(
        (ref) => userCount(ref as UserCountRef, activeOnly: activeOnly),
        from: userCountProvider,
        name: r'userCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userCountHash,
        dependencies: UserCountFamily._dependencies,
        allTransitiveDependencies: UserCountFamily._allTransitiveDependencies,
        activeOnly: activeOnly,
      );

  UserCountProvider._internal(
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
  Override overrideWith(FutureOr<int> Function(UserCountRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: UserCountProvider._internal(
        (ref) => create(ref as UserCountRef),
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
    return _UserCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserCountProvider && other.activeOnly == activeOnly;
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
mixin UserCountRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `activeOnly` of this provider.
  bool get activeOnly;
}

class _UserCountProviderElement extends AutoDisposeFutureProviderElement<int>
    with UserCountRef {
  _UserCountProviderElement(super.provider);

  @override
  bool get activeOnly => (origin as UserCountProvider).activeOnly;
}

String _$userCountByRoleHash() => r'90f5b67d123727062a1a6fb7f0c98ad4dac50d9a';

/// Provider for user count by role
///
/// Copied from [userCountByRole].
@ProviderFor(userCountByRole)
const userCountByRoleProvider = UserCountByRoleFamily();

/// Provider for user count by role
///
/// Copied from [userCountByRole].
class UserCountByRoleFamily extends Family<AsyncValue<Map<UserRole, int>>> {
  /// Provider for user count by role
  ///
  /// Copied from [userCountByRole].
  const UserCountByRoleFamily();

  /// Provider for user count by role
  ///
  /// Copied from [userCountByRole].
  UserCountByRoleProvider call({bool activeOnly = true}) {
    return UserCountByRoleProvider(activeOnly: activeOnly);
  }

  @override
  UserCountByRoleProvider getProviderOverride(
    covariant UserCountByRoleProvider provider,
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
  String? get name => r'userCountByRoleProvider';
}

/// Provider for user count by role
///
/// Copied from [userCountByRole].
class UserCountByRoleProvider
    extends AutoDisposeFutureProvider<Map<UserRole, int>> {
  /// Provider for user count by role
  ///
  /// Copied from [userCountByRole].
  UserCountByRoleProvider({bool activeOnly = true})
    : this._internal(
        (ref) =>
            userCountByRole(ref as UserCountByRoleRef, activeOnly: activeOnly),
        from: userCountByRoleProvider,
        name: r'userCountByRoleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userCountByRoleHash,
        dependencies: UserCountByRoleFamily._dependencies,
        allTransitiveDependencies:
            UserCountByRoleFamily._allTransitiveDependencies,
        activeOnly: activeOnly,
      );

  UserCountByRoleProvider._internal(
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
    FutureOr<Map<UserRole, int>> Function(UserCountByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserCountByRoleProvider._internal(
        (ref) => create(ref as UserCountByRoleRef),
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
  AutoDisposeFutureProviderElement<Map<UserRole, int>> createElement() {
    return _UserCountByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserCountByRoleProvider && other.activeOnly == activeOnly;
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
mixin UserCountByRoleRef on AutoDisposeFutureProviderRef<Map<UserRole, int>> {
  /// The parameter `activeOnly` of this provider.
  bool get activeOnly;
}

class _UserCountByRoleProviderElement
    extends AutoDisposeFutureProviderElement<Map<UserRole, int>>
    with UserCountByRoleRef {
  _UserCountByRoleProviderElement(super.provider);

  @override
  bool get activeOnly => (origin as UserCountByRoleProvider).activeOnly;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
