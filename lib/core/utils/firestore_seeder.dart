import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';
import 'user_id_generator.dart';

/// Utility class to seed test data in Firestore
class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Seed test users in Firestore
  Future<void> seedTestUsers() async {
    try {
      // First, get an existing active department to use for test users
      final deptSnapshot = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .where('is_active', isEqualTo: true)
          .limit(1)
          .get();

      String? departmentId;
      String? departmentName;

      if (deptSnapshot.docs.isNotEmpty) {
        final dept = deptSnapshot.docs.first;
        departmentId = dept.id;
        departmentName = dept.data()['name'] as String?;
        print(
          '📁 Using existing department: $departmentName (ID: $departmentId)',
        );
      } else {
        print(
          '⚠️  No active departments found. Creating users without department.',
        );
      }

      // Test User 1: Super Admin
      await _createUser(
        uidSuffix: 'test_001',
        user: UserModel(
          id: '', // Will be set by _createUser
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

      // Test User 2: Department Head (with department)
      await _createUser(
        uidSuffix: 'test_002',
        user: UserModel(
          id: '', // Will be set by _createUser
          name: 'Department Head',
          phone: '+919999999998',
          role: UserRole.departmentHead,
          employeeId: departmentId != null
              ? '${departmentName?.substring(0, 4).toUpperCase() ?? "DEPT"}001'
              : 'DH001',
          departmentId: departmentId,
          departmentName: departmentName,
          joiningDate: DateTime.now().subtract(const Duration(days: 180)),
          lastUsed: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // Test User 3: Employee (with department)
      await _createUser(
        uidSuffix: 'test_003',
        user: UserModel(
          id: '', // Will be set by _createUser
          name: 'John Employee',
          phone: '+919999999997',
          role: UserRole.employee,
          employeeId: departmentId != null
              ? '${departmentName?.substring(0, 4).toUpperCase() ?? "DEPT"}002'
              : 'EMP001',
          departmentId: departmentId,
          departmentName: departmentName,
          joiningDate: DateTime.now().subtract(const Duration(days: 90)),
          lastUsed: DateTime.now(),
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      print('✅ Successfully seeded 3 test users!');
      if (departmentId != null) {
        print('   - Assigned to department: $departmentName');
      }
    } catch (e) {
      print('❌ Error seeding test users: $e');
      rethrow;
    }
  }

  /// Create a user document in Firestore
  Future<void> _createUser({
    required String uidSuffix,
    required UserModel user,
  }) async {
    // Generate role-based ID
    final userId = UserIdGenerator.generateUserId(user.role, uidSuffix);
    final collectionName = UserIdGenerator.getCollectionForRole(user.role);

    // Create user with prefixed ID
    final userWithId = user.copyWith(id: userId);

    // Store full profile in role-specific collection
    await _firestore
        .collection(collectionName)
        .doc(userId)
        .set(userWithId.toJson());

    // Create auth lookup record in users collection
    await _firestore.collection(FirebaseConstants.usersCollection).add({
      'phone': user.phone,
      'role': _getRoleString(user.role),
      'roleDocId': userId,
      'isActive': user.isActive,
      'lastUsed': FieldValue.serverTimestamp(),
    });

    print('✅ Created user: ${user.name} (${user.phone}) with ID: $userId');
  }

  /// Helper to convert UserRole enum to string
  String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.departmentHead:
        return 'department_head';
      case UserRole.employee:
        return 'employee';
    }
  }

  /// Clear all test users (cleanup)
  Future<void> clearTestUsers() async {
    try {
      // Delete from role-specific collections
      await _firestore
          .collection(FirebaseConstants.superAdminsCollection)
          .doc(UserIdGenerator.generateUserId(UserRole.superAdmin, 'test_001'))
          .delete();

      await _firestore
          .collection(FirebaseConstants.departmentHeadsCollection)
          .doc(
            UserIdGenerator.generateUserId(UserRole.departmentHead, 'test_002'),
          )
          .delete();

      await _firestore
          .collection(FirebaseConstants.employeesCollection)
          .doc(UserIdGenerator.generateUserId(UserRole.employee, 'test_003'))
          .delete();

      // Delete auth lookup records
      final authDocs = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(
            'phone',
            whereIn: ['+919999999999', '+919999999998', '+919999999997'],
          )
          .get();

      for (final doc in authDocs.docs) {
        await doc.reference.delete();
      }

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
    print('🌱 Starting to seed test data...\\n');

    await seedTestDepartment();
    await seedTestUsers();

    print('\\n🎉 All test data seeded successfully!');
    print('📝 Test Users Created:');
    print('   1. Super Admin     - +919999999999 (OTP: 123456)');
    print('   2. Department Head - +919999999998 (OTP: 123456)');
    print('   3. Employee        - +919999999997 (OTP: 123456)');
  }
}
