import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/repositories/firebase_user_repository.dart';
import '../../domain/repositories/user_repository.dart';

part 'user_provider.g.dart';

/// Provider for UserRepository (admin operations)
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return FirebaseUserRepository(firestore: FirebaseFirestore.instance);
}

/// Provider for all users stream
@riverpod
Stream<List<UserModel>> users(
  UsersRef ref, {
  bool activeOnly = false,
  UserRole? role,
  String? departmentId,
}) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUsers(
    activeOnly: activeOnly,
    role: role,
    departmentId: departmentId,
  );
}

/// Provider for a single user
@riverpod
Future<UserModel?> user(UserRef ref, String id) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(id);
}

/// Provider for user search
@riverpod
Future<List<UserModel>> searchUsers(SearchUsersRef ref, String query) async {
  final repository = ref.watch(userRepositoryProvider);
  if (query.isEmpty) return [];
  return repository.searchUsers(query);
}

/// Provider for user count
@riverpod
Future<int> userCount(UserCountRef ref, {bool activeOnly = true}) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserCount(activeOnly: activeOnly);
}

/// Provider for user count by role
@riverpod
Future<Map<UserRole, int>> userCountByRole(
  UserCountByRoleRef ref, {
  bool activeOnly = true,
}) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserCountByRole(activeOnly: activeOnly);
}
