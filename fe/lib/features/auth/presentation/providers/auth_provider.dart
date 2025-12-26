import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// Provider for authentication state (user ID)
final authStateProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

/// Check if user is signed in
final isSignedInProvider = Provider<bool>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.isSignedIn();
});
