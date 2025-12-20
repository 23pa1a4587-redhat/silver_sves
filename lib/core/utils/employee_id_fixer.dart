// Script to find and fix duplicate employee IDs in Firestore
// Run this in Firebase console or as a one-time migration

/* 
HOW TO USE THIS SCRIPT:
1. Open Firebase Console
2. Go to Firestore Database
3. Click on "Indexes" tab
4. Run this script in your backend/cloud function

OR

You can run this from your app's debug screen
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';
import 'employee_id_generator.dart';

class EmployeeIdFixer {
  final FirebaseFirestore _firestore;

  EmployeeIdFixer({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Find all duplicate employee IDs
  Future<Map<String, List<String>>> findDuplicates() async {
    final Map<String, List<String>> employeeIdToUserIds = {};

    // Check all role collections
    for (final collection in [
      FirebaseConstants.superAdminsCollection,
      FirebaseConstants.departmentHeadsCollection,
      FirebaseConstants.employeesCollection,
    ]) {
      final snapshot = await _firestore.collection(collection).get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final employeeId = data['employeeId'] as String?;

        if (employeeId != null && employeeId.isNotEmpty) {
          employeeIdToUserIds.putIfAbsent(employeeId, () => []);
          employeeIdToUserIds[employeeId]!.add(doc.id);
        }
      }
    }

    // Filter to only duplicates
    final duplicates = <String, List<String>>{};
    employeeIdToUserIds.forEach((employeeId, userIds) {
      if (userIds.length > 1) {
        duplicates[employeeId] = userIds;
      }
    });

    return duplicates;
  }

  /// Fix duplicate employee IDs
  Future<void> fixDuplicates() async {
    print('🔍 Searching for duplicate employee IDs...');
    final duplicates = await findDuplicates();

    if (duplicates.isEmpty) {
      print('✅ No duplicates found!');
      return;
    }

    print('⚠️  Found ${duplicates.length} duplicate employee IDs:');
    duplicates.forEach((employeeId, userIds) {
      print('   $employeeId → ${userIds.length} users: $userIds');
    });

    print('\n🔧 Fixing duplicates...');

    for (final entry in duplicates.entries) {
      final employeeId = entry.key;
      final userIds = entry.value;

      // Keep the first user with this ID, regenerate for others
      for (int i = 1; i < userIds.length; i++) {
        final userId = userIds[i];
        await _regenerateEmployeeIdForUser(userId);
      }
    }

    print('✅ All duplicates fixed!');
  }

  /// Regenerate employee ID for a specific user
  Future<void> _regenerateEmployeeIdForUser(String userId) async {
    try {
      // Find the user in all collections
      UserModel? user;
      String? collectionName;

      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        final doc = await _firestore.collection(collection).doc(userId).get();
        if (doc.exists) {
          user = UserModel.fromJson({...doc.data()!, 'id': doc.id});
          collectionName = collection;
          break;
        }
      }

      if (user == null || collectionName == null) {
        print('⚠️  User $userId not found');
        return;
      }

      if (user.departmentId == null) {
        print('⚠️  User $userId has no department, skipping');
        return;
      }

      // Get department name
      final deptDoc = await _firestore
          .collection(FirebaseConstants.departmentsCollection)
          .doc(user.departmentId!)
          .get();

      if (!deptDoc.exists) {
        print('⚠️  Department not found for user $userId');
        return;
      }

      final deptName = deptDoc.data()!['name'] as String;

      // Generate new employee ID (just a UUID now - no department dependency)
      final generator = EmployeeIdGenerator();
      final newEmployeeId = generator.generateEmployeeId();

      // Update user with new employee ID
      await _firestore.collection(collectionName).doc(userId).update({
        'employeeId': newEmployeeId,
      });

      print(
        '✅ Updated ${user.name} ($userId): ${user.employeeId} → $newEmployeeId',
      );
    } catch (e) {
      print('❌ Error fixing user $userId: $e');
    }
  }
}
