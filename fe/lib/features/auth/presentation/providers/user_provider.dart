import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import 'auth_provider.dart';

/// Provider for current user data
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);

  // Watch auth state to refresh when user signs in/out
  final authState = ref.watch(authStateProvider);

  final userId = authState.valueOrNull;
  if (userId == null) return null;

  return await authRepository.getCurrentUser();
});

/// Provider for user role
final userRoleProvider = Provider<UserRole?>((ref) {
  final userAsync = ref.watch(currentUserProvider);

  return userAsync.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (_, _) => null,
  );
});
