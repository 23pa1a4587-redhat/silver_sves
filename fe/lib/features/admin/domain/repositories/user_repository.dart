import '../../../auth/data/models/user_model.dart';

/// User management repository interface (Domain layer)
abstract class UserRepository {
  /// Create a new user
  Future<UserModel> createUser(UserModel user);

  /// Get all users (stream for real-time updates)
  Stream<List<UserModel>> getUsers({
    bool activeOnly = false,
    UserRole? role,
    String? departmentId,
  });

  /// Get a single user by ID
  Future<UserModel?> getUserById(String id);

  /// Search users by name, employee ID, or phone
  Future<List<UserModel>> searchUsers(String query);

  /// Update user details
  Future<void> updateUser(UserModel user);

  /// Deactivate user (soft delete)
  Future<void> deactivateUser(String userId);

  /// Activate user
  Future<void> activateUser(String userId);

  /// Check if phone number is unique
  Future<bool> isPhoneUnique(String phone, {String? excludeId});

  /// Get user count
  Future<int> getUserCount({bool activeOnly = true});

  /// Get user count by role
  Future<Map<UserRole, int>> getUserCountByRole({bool activeOnly = true});

  /// Get users by department
  Future<List<UserModel>> getUsersByDepartment(
    String departmentId, {
    bool activeOnly = true,
  });

  /// Get user by employee ID (for querying)
  Future<UserModel?> getUserByEmployeeId(String employeeId);
}
