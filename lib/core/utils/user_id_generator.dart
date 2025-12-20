import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';

/// Utility class to generate and parse role-based user IDs
class UserIdGenerator {
  UserIdGenerator._(); // Private constructor

  /// Generate a user ID with role-based prefix
  ///
  /// Examples:
  /// - SuperAdmin: sa_firebase_uid_123
  /// - DeptHead: dh_firebase_uid_456
  /// - Employee: emp_firebase_uid_789
  static String generateUserId(UserRole role, String uid) {
    final prefix = _getPrefixForRole(role);
    return '$prefix$uid';
  }

  /// Extract the Firebase UID from a prefixed user ID
  ///
  /// Example: sa_firebase_uid_123 -> firebase_uid_123
  static String extractUidFromUserId(String userId) {
    if (userId.startsWith(FirebaseConstants.superAdminPrefix)) {
      return userId.substring(FirebaseConstants.superAdminPrefix.length);
    } else if (userId.startsWith(FirebaseConstants.deptHeadPrefix)) {
      return userId.substring(FirebaseConstants.deptHeadPrefix.length);
    } else if (userId.startsWith(FirebaseConstants.employeePrefix)) {
      return userId.substring(FirebaseConstants.employeePrefix.length);
    }
    // If no prefix found, return as-is (for backward compatibility)
    return userId;
  }

  /// Determine user role from prefixed user ID
  ///
  /// Example: sa_firebase_uid_123 -> UserRole.superAdmin
  static UserRole? getRoleFromUserId(String userId) {
    if (userId.startsWith(FirebaseConstants.superAdminPrefix)) {
      return UserRole.superAdmin;
    } else if (userId.startsWith(FirebaseConstants.deptHeadPrefix)) {
      return UserRole.departmentHead;
    } else if (userId.startsWith(FirebaseConstants.employeePrefix)) {
      return UserRole.employee;
    }
    return null;
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

  /// Get the prefix for a specific role (private helper)
  static String _getPrefixForRole(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return FirebaseConstants.superAdminPrefix;
      case UserRole.departmentHead:
        return FirebaseConstants.deptHeadPrefix;
      case UserRole.employee:
        return FirebaseConstants.employeePrefix;
    }
  }

  /// Validate that user ID matches expected role
  static bool isValidUserIdForRole(String userId, UserRole expectedRole) {
    final actualRole = getRoleFromUserId(userId);
    return actualRole == expectedRole;
  }
}
