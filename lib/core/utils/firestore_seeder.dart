import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';

/// Utility class to seed test data in Firestore
class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Seed test users in Firestore
  Future<void> seedTestUsers() async {
    try {
      // Test User 1: Super Admin
      await _createUser(
        id: 'super_admin_test_001',
        user: UserModel(
          id: 'super_admin_test_001',
          name: 'Super Admin',
          phone: '+919999999999',
          role: UserRole.superAdmin,
          employeeId: 'SA001',
          joiningDate: DateTime.now().subtract(const Duration(days: 365)),
          lastUsed: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Test User 2: Department Head
      await _createUser(
        id: 'dept_head_test_001',
        user: UserModel(
          id: 'dept_head_test_001',
          name: 'Department Head',
          phone: '+919999999998',
          role: UserRole.departmentHead,
          employeeId: 'DH001',
          departmentId: 'dept_1',
          departmentName: 'Engineering',
          joiningDate: DateTime.now().subtract(const Duration(days: 180)),
          lastUsed: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Test User 3: Employee
      await _createUser(
        id: 'employee_test_001',
        user: UserModel(
          id: 'employee_test_001',
          name: 'John Employee',
          phone: '+919999999997',
          role: UserRole.employee,
          employeeId: 'EMP001',
          departmentId: 'dept_1',
          departmentName: 'Engineering',
          joiningDate: DateTime.now().subtract(const Duration(days: 90)),
          lastUsed: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      print('✅ Successfully seeded 3 test users!');
    } catch (e) {
      print('❌ Error seeding test users: $e');
      rethrow;
    }
  }

  /// Create a user document in Firestore
  Future<void> _createUser({
    required String id,
    required UserModel user,
  }) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(id)
        .set(user.toJson());

    print('✅ Created user: ${user.name} (${user.phone})');
  }

  /// Clear all test users (cleanup)
  Future<void> clearTestUsers() async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc('super_admin_test_001')
          .delete();

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc('dept_head_test_001')
          .delete();

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc('employee_test_001')
          .delete();

      print('✅ Cleared all test users!');
    } catch (e) {
      print('❌ Error clearing test users: $e');
      rethrow;
    }
  }

  /// Create a test department
  Future<void> seedTestDepartment() async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc('dept_1')
          .set({
            'id': 'dept_1',
            'name': 'Engineering',
            'headId': 'dept_head_test_001',
            'employeeCount': 1,
            'createdAt': Timestamp.fromDate(DateTime.now()),
          });

      print('✅ Created test department: Engineering');
    } catch (e) {
      print('❌ Error creating department: $e');
      rethrow;
    }
  }

  /// Seed all test data (users + department)
  Future<void> seedAllTestData() async {
    print('🌱 Starting to seed test data...\n');

    await seedTestDepartment();
    await seedTestUsers();

    print('\n🎉 All test data seeded successfully!');
    print('📝 Test Users Created:');
    print('   1. Super Admin     - +919999999999 (OTP: 123456)');
    print('   2. Department Head - +919999999998 (OTP: 123456)');
    print('   3. Employee        - +919999999997 (OTP: 123456)');
  }
}
