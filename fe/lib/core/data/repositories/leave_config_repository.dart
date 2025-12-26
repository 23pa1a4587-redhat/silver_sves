import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leave_config_model.dart';

/// Repository for managing leave configuration in Firestore
class LeaveConfigRepository {
  final FirebaseFirestore _firestore;

  /// Firestore path for leave settings
  static const String _configCollection = 'config';
  static const String _leaveSettingsDoc = 'leave_settings';

  LeaveConfigRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get leave configuration document reference
  DocumentReference<Map<String, dynamic>> get _docRef =>
      _firestore.collection(_configCollection).doc(_leaveSettingsDoc);

  /// Stream leave configuration (real-time updates)
  Stream<LeaveConfigModel> streamLeaveConfig() {
    return _docRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return LeaveConfigModel.fromJson(snapshot.data()!);
      }
      return LeaveConfigModel.defaults();
    });
  }

  /// Get leave configuration (one-time fetch)
  Future<LeaveConfigModel> getLeaveConfig() async {
    try {
      final snapshot = await _docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        return LeaveConfigModel.fromJson(snapshot.data()!);
      }
      return LeaveConfigModel.defaults();
    } catch (e) {
      // Return defaults if Firestore fails
      return LeaveConfigModel.defaults();
    }
  }

  /// Update leave configuration (Super Admin only)
  Future<void> updateLeaveConfig({
    required int casualLeave,
    required int sickLeave,
    required int earnedLeave,
    required int emergencyLeave,
    required String updatedBy,
  }) async {
    final config = LeaveConfigModel(
      casualLeave: casualLeave,
      sickLeave: sickLeave,
      earnedLeave: earnedLeave,
      emergencyLeave: emergencyLeave,
      updatedBy: updatedBy,
    );

    await _docRef.set(config.toJson(), SetOptions(merge: true));
  }

  /// Initialize default config if not exists
  Future<void> initializeIfNotExists() async {
    final snapshot = await _docRef.get();
    if (!snapshot.exists) {
      await _docRef.set(LeaveConfigModel.defaults().toJson());
    }
  }
}
