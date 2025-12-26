import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';

/// Utility class to generate and parse user IDs
/// All users get 'emp_' prefix regardless of role
class UserIdGenerator {
  UserIdGenerator._(); // Private constructor

  /// Generate a user ID with 'emp_' prefix for all roles
  ///
  /// Example: emp_firebase_uid_123xyz
  static String generateUserId(UserRole role, String uid) {
    return '${FirebaseConstants.employeePrefix}$uid';
  }

  /// Extract the Firebase UID from a prefixed user ID
  ///
  /// Example: emp_firebase_uid_123 -> firebase_uid_123
  static String extractUidFromUserId(String userId) {
    if (userId.startsWith(FirebaseConstants.employeePrefix)) {
      return userId.substring(FirebaseConstants.employeePrefix.length);
    }
    // If no prefix found, return as-is
    return userId;
  }

  /// Get the collection name for a specific role
  static String getCollectionForRole(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return FirebaseConstants.superAdminsCollection;
      case UserRole.departmentHead:
        return FirebaseConstants.departmentHeadsCollection;
      case UserRole.employee:
        return FirebaseConstants.employeesCollection;
    }
  }

  /// Validate that user ID has correct 'emp_' prefix format
  static bool isValidUserId(String userId) {
    return userId.startsWith(FirebaseConstants.employeePrefix);
  }
}
