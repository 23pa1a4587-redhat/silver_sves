import '../../data/models/user_model.dart';

/// Authentication repository interface (Domain layer)
abstract class AuthRepository {
  /// Get current user ID from Firebase Auth
  String? getCurrentUserId();

  /// Sign in with phone number
  /// Returns verification ID for OTP verification
  Future<String> signInWithPhone(String phoneNumber);

  /// Verify OTP code
  /// Returns user data from Firestore
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String otpCode,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Get current user data from Firestore
  Future<UserModel?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<String?> authStateChanges();

  /// Check if user is signed in
  bool isSignedIn();
}
