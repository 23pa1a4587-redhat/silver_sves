import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../models/leave_application_model.dart';

/// Repository for managing leave applications
class LeaveRepository {
  final FirebaseFirestore _firestore;

  LeaveRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all leave applications for a specific user
  Stream<List<LeaveApplication>> getUserLeaveApplications(String userId) {
    try {
      return _firestore
          .collection(FirebaseConstants.leavesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return LeaveApplication.fromJson({...data, 'id': doc.id});
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to get user leave applications: ${e.toString()}');
    }
  }

  /// Get all leave applications (for admin)
  Stream<List<LeaveApplication>> getAllLeaveApplications() {
    try {
      return _firestore
          .collection(FirebaseConstants.leavesCollection)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return LeaveApplication.fromJson({...data, 'id': doc.id});
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to get leave applications: ${e.toString()}');
    }
  }

  /// Create a new leave application
  Future<void> createLeaveApplication(LeaveApplication application) async {
    try {
      final docRef = _firestore
          .collection(FirebaseConstants.leavesCollection)
          .doc();

      final data = application
          .copyWith(
            id: docRef.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
          .toJson();

      await docRef.set(data);
    } catch (e) {
      throw Exception('Failed to create leave application: ${e.toString()}');
    }
  }

  /// Update leave status (approve/reject)
  Future<void> updateLeaveStatus(
    String leaveId,
    LeaveStatus status,
    String? approvedBy,
  ) async {
    try {
      await _firestore
          .collection(FirebaseConstants.leavesCollection)
          .doc(leaveId)
          .update({
            'status': status.toJson(),
            'approvedBy': approvedBy,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to update leave status: ${e.toString()}');
    }
  }

  /// Get all leave requests for a specific department
  Stream<List<LeaveApplication>> getDepartmentLeaveRequests(
    String departmentId,
  ) {
    try {
      return _firestore
          .collection(FirebaseConstants.leavesCollection)
          .where('departmentId', isEqualTo: departmentId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return LeaveApplication.fromJson({...data, 'id': doc.id});
            }).toList();
          });
    } catch (e) {
      throw Exception(
        'Failed to get department leave requests: ${e.toString()}',
      );
    }
  }
}
