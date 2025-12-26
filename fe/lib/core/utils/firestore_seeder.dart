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
          .where('isActive', isEqualTo: true)
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

    // Generate 8-character employee ID from user ID
    final employeeId = userId.replaceAll('-', '').substring(0, 8).toLowerCase();

    // Create user with prefixed ID and employee ID
    final userWithId = user.copyWith(id: userId, employeeId: employeeId);

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

    print('✅ Created user: ${user.name} (${user.phone}) with ID: $employeeId');
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

  /// Activate all users - sets isActive to true for all users
  Future<void> activateAllUsers() async {
    try {
      print('🔓 Activating all users...');

      // Activate in users collection (auth lookup)
      final usersSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .get();

      for (final doc in usersSnapshot.docs) {
        await doc.reference.update({'isActive': true});
      }

      // Activate in super_admins collection
      final superAdminsSnapshot = await _firestore
          .collection(FirebaseConstants.superAdminsCollection)
          .get();

      for (final doc in superAdminsSnapshot.docs) {
        await doc.reference.update({'isActive': true});
      }

      // Activate in department_heads collection
      final deptHeadsSnapshot = await _firestore
          .collection(FirebaseConstants.departmentHeadsCollection)
          .get();

      for (final doc in deptHeadsSnapshot.docs) {
        await doc.reference.update({'isActive': true});
      }

      // Activate in employees collection
      final employeesSnapshot = await _firestore
          .collection(FirebaseConstants.employeesCollection)
          .get();

      for (final doc in employeesSnapshot.docs) {
        await doc.reference.update({'isActive': true});
      }

      print('✅ Successfully activated all users!');
      print('   - Users: ${usersSnapshot.docs.length}');
      print('   - Super Admins: ${superAdminsSnapshot.docs.length}');
      print('   - Department Heads: ${deptHeadsSnapshot.docs.length}');
      print('   - Employees: ${employeesSnapshot.docs.length}');
    } catch (e) {
      print('❌ Error activating users: $e');
      rethrow;
    }
  }

  /// Create a test department
  Future<void> seedTestDepartment() async {
    try {
      // Use Firebase auto-generated ID
      final docRef = _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc();

      final departmentId = docRef.id;
      final uniqueId = departmentId
          .replaceAll('-', '')
          .substring(0, 8)
          .toLowerCase();

      await docRef.set({
        'id': departmentId,
        'unique_id': uniqueId,
        'name': 'Engineering',
        'description': 'Engineering Department',
        'head_id': null,
        'head_name': null,
        'employee_count': 0,
        'isActive': true,
        'created_at': Timestamp.fromDate(DateTime.now()),
        'updated_at': Timestamp.fromDate(DateTime.now()),
      });

      print(
        '✅ Created test department: Engineering (ID: $uniqueId, Firebase ID: $departmentId)',
      );
    } catch (e) {
      print('❌ Error creating department: $e');
      rethrow;
    }
  }

  /// Seed department history test data
  Future<void> seedDepartmentHistory(String departmentId) async {
    try {
      print('📚 Seeding department history...');

      final historyCollection = _firestore
          .collection('departments')
          .doc(departmentId)
          .collection('history');

      // Event 1: Department created
      await historyCollection.add({
        'event_type': 'department_created',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 365)),
        ),
        'performed_by_id': 'SA_test_001',
        'performed_by_name': 'Super Admin',
        'performed_by_role': 'super_admin',
        'metadata': {'initial_head_id': null, 'initial_head_name': null},
      });

      // Event 2: First employee hired
      await historyCollection.add({
        'event_type': 'employee_hired',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 180)),
        ),
        'performed_by_id': 'SA_test_001',
        'performed_by_name': 'Super Admin',
        'performed_by_role': 'super_admin',
        'metadata': {
          'employee_id': 'DH_test_002',
          'employee_name': 'Department Head',
          'employee_role': 'department_head',
        },
      });

      // Event 3: Head assigned
      await historyCollection.add({
        'event_type': 'head_assigned',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 175)),
        ),
        'performed_by_id': 'SA_test_001',
        'performed_by_name': 'Super Admin',
        'performed_by_role': 'super_admin',
        'metadata': {
          'new_head_id': 'DH_test_002',
          'new_head_name': 'Department Head',
          'previous_head_id': null,
          'previous_head_name': null,
        },
      });

      // Event 4: Second employee hired
      await historyCollection.add({
        'event_type': 'employee_hired',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 90)),
        ),
        'performed_by_id': 'DH_test_002',
        'performed_by_name': 'Department Head',
        'performed_by_role': 'department_head',
        'metadata': {
          'employee_id': 'EMP_test_003',
          'employee_name': 'John Employee',
          'employee_role': 'employee',
        },
      });

      // Event 5: Department updated
      await historyCollection.add({
        'event_type': 'department_updated',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 60)),
        ),
        'performed_by_id': 'SA_test_001',
        'performed_by_name': 'Super Admin',
        'performed_by_role': 'super_admin',
        'metadata': {
          'changes': {
            'description': {
              'old_value': 'Engineering Department',
              'new_value': 'Software Engineering Department',
            },
          },
        },
      });

      print('   ✅ Added 5 department history events');
    } catch (e) {
      print('   ❌ Error seeding department history: $e');
    }
  }

  /// Seed employee history test data
  Future<void> seedEmployeeHistory(
    String employeeId,
    String departmentId,
    String departmentName,
  ) async {
    try {
      print('📚 Seeding employee history for $employeeId...');

      final historyCollection = _firestore
          .collection('users')
          .doc(employeeId)
          .collection('history');

      // Event 1: Hired
      await historyCollection.add({
        'event_type': 'hired',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 90)),
        ),
        'performed_by_id': 'DH_test_002',
        'performed_by_name': 'Department Head',
        'performed_by_role': 'department_head',
        'metadata': {
          'department_id': departmentId,
          'department_name': departmentName,
          'initial_role': 'employee',
          'joining_date': DateTime.now()
              .subtract(const Duration(days: 90))
              .toIso8601String(),
        },
      });

      // Event 2: Leave applied
      await historyCollection.add({
        'event_type': 'leave_applied',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 30)),
        ),
        'performed_by_id': employeeId,
        'performed_by_name': 'John Employee',
        'performed_by_role': 'employee',
        'metadata': {
          'leave_application_id': 'leave_001',
          'leave_type': 'sick',
          'start_date': DateTime.now()
              .subtract(const Duration(days: 28))
              .toIso8601String(),
          'end_date': DateTime.now()
              .subtract(const Duration(days: 26))
              .toIso8601String(),
          'days_count': 3,
          'status': 'pending',
        },
      });

      // Event 3: Leave approved
      await historyCollection.add({
        'event_type': 'leave_approved',
        'timestamp': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 29)),
        ),
        'performed_by_id': 'DH_test_002',
        'performed_by_name': 'Department Head',
        'performed_by_role': 'department_head',
        'metadata': {
          'leave_application_id': 'leave_001',
          'leave_type': 'sick',
          'start_date': DateTime.now()
              .subtract(const Duration(days: 28))
              .toIso8601String(),
          'end_date': DateTime.now()
              .subtract(const Duration(days: 26))
              .toIso8601String(),
          'days_count': 3,
          'status': 'approved',
          'reviewed_by_id': 'DH_test_002',
          'reviewed_by_name': 'Department Head',
          'review_comments': 'Approved - Get well soon',
        },
      });

      print('   ✅ Added 3 employee history events');
    } catch (e) {
      print('   ❌ Error seeding employee history: $e');
    }
  }

  /// Seed leave applications test data
  Future<void> seedLeaveApplications(
    String employeeId,
    String departmentId,
  ) async {
    try {
      print('📝 Seeding leave applications...');

      final leavesCollection = _firestore.collection('leave_applications');

      // Leave 1: Approved sick leave
      await leavesCollection.add({
        'employee_id': employeeId,
        'employee_name': 'John Employee',
        'employee_unique_id': employeeId
            .replaceAll('_', '')
            .substring(0, 8)
            .toLowerCase(),
        'department_id': departmentId,
        'department_name': 'Engineering',
        'leave_type': 'sick',
        'start_date': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 28)),
        ),
        'end_date': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 26)),
        ),
        'days_count': 3,
        'half_day': false,
        'reason': 'Medical appointment and recovery',
        'status': 'approved',
        'applied_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 30)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 29)),
        ),
        'reviewed_by_id': 'DH_test_002',
        'reviewed_by_name': 'Department Head',
        'reviewed_by_role': 'department_head',
        'reviewed_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 29)),
        ),
        'review_comments': 'Approved - Get well soon',
        'attachments': [],
      });

      // Leave 2: Pending casual leave
      await leavesCollection.add({
        'employee_id': employeeId,
        'employee_name': 'John Employee',
        'employee_unique_id': employeeId
            .replaceAll('_', '')
            .substring(0, 8)
            .toLowerCase(),
        'department_id': departmentId,
        'department_name': 'Engineering',
        'leave_type': 'casual',
        'start_date': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7)),
        ),
        'end_date': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 8)),
        ),
        'days_count': 2,
        'half_day': false,
        'reason': 'Family function',
        'status': 'pending',
        'applied_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        'updated_at': null,
        'reviewed_by_id': null,
        'reviewed_by_name': null,
        'reviewed_by_role': null,
        'reviewed_at': null,
        'review_comments': null,
        'attachments': [],
      });

      // Leave 3: Rejected earned leave
      await leavesCollection.add({
        'employee_id': employeeId,
        'employee_name': 'John Employee',
        'employee_unique_id': employeeId
            .replaceAll('_', '')
            .substring(0, 8)
            .toLowerCase(),
        'department_id': departmentId,
        'department_name': 'Engineering',
        'leave_type': 'earned',
        'start_date': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 15)),
        ),
        'end_date': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 10)),
        ),
        'days_count': 6,
        'half_day': false,
        'reason': 'Personal travel',
        'status': 'rejected',
        'applied_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 20)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 19)),
        ),
        'reviewed_by_id': 'DH_test_002',
        'reviewed_by_name': 'Department Head',
        'reviewed_by_role': 'department_head',
        'reviewed_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 19)),
        ),
        'review_comments': 'Cannot approve - critical project deadline',
        'attachments': [],
      });

      print(
        '   ✅ Added 3 leave applications (1 approved, 1 pending, 1 rejected)',
      );
    } catch (e) {
      print('   ❌ Error seeding leave applications: $e');
    }
  }

  /// Update department with analytics fields
  Future<void> updateDepartmentAnalytics(String departmentId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(departmentId)
          .update({
            'past_members_count': 2,
            'total_transfers_in': 0,
            'total_transfers_out': 0,
            'head_change_count': 1,
          });
      print('   ✅ Updated department analytics');
    } catch (e) {
      print('   ❌ Error updating department analytics: $e');
    }
  }

  /// Update user with analytics fields
  Future<void> updateUserAnalytics(String userId, String collectionName) async {
    try {
      await _firestore.collection(collectionName).doc(userId).update({
        'total_departments_worked': 1,
        'current_department_since': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 90)),
        ),
        'total_leaves_applied': 3,
        'total_leaves_approved': 1,
        'total_leaves_rejected': 1,
        'total_role_changes': 0,
      });
      print('   ✅ Updated user analytics for $userId');
    } catch (e) {
      print('   ❌ Error updating user analytics: $e');
    }
  }

  /// Seed all test data (users + department + history + leaves)
  Future<void> seedAllTestData() async {
    print('🌱 Starting to seed test data...\n');

    // Create department first
    await seedTestDepartment();

    // Get the department ID
    final deptSnapshot = await _firestore
        .collection(FirebaseConstants.departmentsCollection)
        .where('name', isEqualTo: 'Engineering')
        .limit(1)
        .get();

    if (deptSnapshot.docs.isEmpty) {
      print('❌ Department not found, cannot continue seeding');
      return;
    }

    final departmentId = deptSnapshot.docs.first.id;
    final departmentName = deptSnapshot.docs.first.data()['name'] as String;

    // Create users
    await seedTestUsers();

    // Seed history data
    await seedDepartmentHistory(departmentId);

    final employeeId = UserIdGenerator.generateUserId(
      UserRole.employee,
      'test_003',
    );
    await seedEmployeeHistory(employeeId, departmentId, departmentName);

    // Seed leave applications
    await seedLeaveApplications(employeeId, departmentId);

    // Update analytics
    await updateDepartmentAnalytics(departmentId);
    await updateUserAnalytics(
      employeeId,
      FirebaseConstants.employeesCollection,
    );

    print('\n🎉 All test data seeded successfully!');
    print('📝 Test Users Created:');
    print('   1. Super Admin     - +919999999999 (OTP: 123456)');
    print('   2. Department Head - +919999999998 (OTP: 123456)');
    print('   3. Employee        - +919999999997 (OTP: 123456)');
    print('\n📊 Test Data Summary:');
    print('   - 1 Department (Engineering)');
    print('   - 5 Department history events');
    print('   - 3 Employee history events');
    print('   - 3 Leave applications');
  }
}
