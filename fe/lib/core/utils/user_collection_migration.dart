import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';
import '../constants/firebase_constants.dart';
import 'user_id_generator.dart';

/// Utility to migrate existing users from single 'users' collection
/// to role-based collections (super_admins, department_heads, employees)
class UserCollectionMigration {
  final FirebaseFirestore _firestore;

  UserCollectionMigration({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Migrate all users from 'users' collection to role-based collections
  Future<MigrationResult> migrateAllUsers() async {
    print('🔄 Starting user collection migration...\\n');

    final result = MigrationResult();

    try {
      // Get all users from the old users collection
      final usersSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .get();

      print('📊 Found ${usersSnapshot.docs.length} users to migrate');

      for (final userDoc in usersSnapshot.docs) {
        try {
          final userData = userDoc.data();
          final user = UserModel.fromJson({...userData, 'id': userDoc.id});

          // Generate new role-based ID
          final newUserId = UserIdGenerator.generateUserId(
            user.role,
            userDoc.id, // Use existing Firestore doc ID as UID
          );
          final roleCollection = UserIdGenerator.getCollectionForRole(
            user.role,
          );

          // Create user in role-specific collection
          final newUser = user.copyWith(
            id: newUserId,
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection(roleCollection)
              .doc(newUserId)
              .set(newUser.toJson());

          // Create auth lookup record
          await _firestore
              .collection(FirebaseConstants.usersCollection)
              .doc(userDoc.id)
              .set({
                'phone': user.phone,
                'role': _getRoleString(user.role),
                'roleDocId': newUserId,
                'isActive': user.isActive,
                'lastUsed': user.lastUsed != null
                    ? Timestamp.fromDate(user.lastUsed!)
                    : FieldValue.serverTimestamp(),
              });

          result.migratedCount++;
          print('  ✅ Migrated: ${user.name} → $roleCollection/$newUserId');
        } catch (e) {
          result.failedCount++;
          result.errors.add('Failed to migrate user ${userDoc.id}: $e');
          print('  ❌ Failed: ${userDoc.id} - $e');
        }
      }

      print('\\n🎉 Migration completed!');
      print('   ✅ Successfully migrated: ${result.migratedCount}');
      if (result.failedCount > 0) {
        print('   ❌ Failed: ${result.failedCount}');
      }

      return result;
    } catch (e) {
      print('❌ Migration failed: $e');
      result.errors.add('Migration failed: $e');
      return result;
    }
  }

  /// Preview migration without making changes
  Future<void> previewMigration() async {
    print('👀 Previewing migration...\\n');

    try {
      final usersSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .get();

      print('📊 Found ${usersSnapshot.docs.length} users\\n');

      final roleCounts = <String, int>{};

      for (final userDoc in usersSnapshot.docs) {
        try {
          final userData = userDoc.data();
          final user = UserModel.fromJson({...userData, 'id': userDoc.id});

          final newUserId = UserIdGenerator.generateUserId(
            user.role,
            userDoc.id,
          );
          final roleCollection = UserIdGenerator.getCollectionForRole(
            user.role,
          );

          roleCounts[roleCollection] = (roleCounts[roleCollection] ?? 0) + 1;

          print('  ${user.name}:');
          print('    Old: users/${userDoc.id}');
          print('    New: $roleCollection/$newUserId');
          print('');
        } catch (e) {
          print('  ⚠️ Could not parse user ${userDoc.id}: $e\\n');
        }
      }

      print('📈 Summary:');
      roleCounts.forEach((collection, count) {
        print('  - $collection: $count users');
      });
    } catch (e) {
      print('❌ Preview failed: $e');
    }
  }

  /// Rollback migration (restore from role collections to users collection)
  /// WARNING: This will overwrite existing users collection
  Future<void> rollbackMigration() async {
    print('⚠️ Starting migration rollback...\\n');

    try {
      int rolledBack = 0;

      for (final collection in [
        FirebaseConstants.superAdminsCollection,
        FirebaseConstants.departmentHeadsCollection,
        FirebaseConstants.employeesCollection,
      ]) {
        final snapshot = await _firestore.collection(collection).get();

        for (final doc in snapshot.docs) {
          try {
            final userData = doc.data();
            final user = UserModel.fromJson({...userData, 'id': doc.id});

            // Extract original ID
            final originalId = UserIdGenerator.extractUidFromUserId(doc.id);

            // Restore to users collection
            await _firestore
                .collection(FirebaseConstants.usersCollection)
                .doc(originalId)
                .set(user.copyWith(id: originalId).toJson());

            // Delete from role collection
            await doc.reference.delete();

            rolledBack++;
            print('  ✅ Rolled back: ${user.name}');
          } catch (e) {
            print('  ❌ Failed to rollback ${doc.id}: $e');
          }
        }
      }

      print('\\n🎉 Rollback completed! Rolled back $rolledBack users');
    } catch (e) {
      print('❌ Rollback failed: $e');
    }
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
}

/// Result of migration operation
class MigrationResult {
  int migratedCount = 0;
  int failedCount = 0;
  List<String> errors = [];

  bool get isSuccess => failedCount == 0;
  int get totalProcessed => migratedCount + failedCount;
}
