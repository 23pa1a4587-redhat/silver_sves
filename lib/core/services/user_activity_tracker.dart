import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/firebase_constants.dart';

/// Service to track user activity and update lastUsed timestamp
class UserActivityTracker {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserActivityTracker({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Update lastUsed timestamp for current user
  Future<void> updateLastUsed() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final phoneNumber = currentUser.phoneNumber;
      if (phoneNumber == null) return;

      // Update in auth lookup collection
      final authSnapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (authSnapshot.docs.isEmpty) return;

      final authDoc = authSnapshot.docs.first;
      final roleDocId = authDoc.data()['roleDocId'] as String?;
      final roleString = authDoc.data()['role'] as String?;

      if (roleDocId == null || roleString == null) return;

      final timestamp = FieldValue.serverTimestamp();

      // Update auth lookup
      await authDoc.reference.update({
        FirebaseConstants.lastUsedField: timestamp,
      });

      // Update role-specific collection
      final String roleCollection;
      switch (roleString) {
        case 'super_admin':
          roleCollection = FirebaseConstants.superAdminsCollection;
          break;
        case 'department_head':
          roleCollection = FirebaseConstants.departmentHeadsCollection;
          break;
        case 'employee':
          roleCollection = FirebaseConstants.employeesCollection;
          break;
        default:
          return;
      }

      await _firestore.collection(roleCollection).doc(roleDocId).update({
        FirebaseConstants.lastUsedField: timestamp,
      });

      print('✅ Updated lastUsed for user: $phoneNumber');
    } catch (e) {
      print('⚠️ Failed to update lastUsed: $e');
      // Don't throw - this is non-critical background operation
    }
  }
}
