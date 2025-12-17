import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../../../core/constants/firebase_constants.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      String? verificationId;

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw _handleAuthException(e);
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );

      // Wait for verification ID
      int attempts = 0;
      while (verificationId == null && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (verificationId == null) {
        throw Exception('Failed to get verification ID');
      }

      return verificationId!;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      // Create credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      // Sign in with credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw Exception('Authentication failed');
      }

      final phoneNumber = userCredential.user!.phoneNumber;
      if (phoneNumber == null) {
        throw Exception('Phone number not found');
      }

      // Look up user by phone number (not UID)
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FirebaseConstants.phoneField, isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
          'User not found. Please contact your administrator to create your account.',
        );
      }

      // Get user document
      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      // Parse user model
      final user = UserModel.fromJson({...userData, 'id': userDoc.id});

      // Check if user is active
      if (!user.isActive) {
        // Sign out the user
        await _firebaseAuth.signOut();
        throw Exception(
          'Your account has been deactivated. Please contact your administrator.',
        );
      }

      // Update lastUsed timestamp
      await userDoc.reference.update({
        FirebaseConstants.lastUsedField: FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final phoneNumber = currentUser.phoneNumber;
      if (phoneNumber == null) return null;

      // Look up user by phone number
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FirebaseConstants.phoneField, isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      return UserModel.fromJson({...userData, 'id': userDoc.id});
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Stream<String?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  @override
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Error handling helpers
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again.';
      case 'invalid-verification-id':
        return 'Verification session expired. Please request a new OTP.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  String _handleError(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
