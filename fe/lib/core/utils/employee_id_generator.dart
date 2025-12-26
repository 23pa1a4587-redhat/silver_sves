import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/// Utility to auto-generate employee IDs based on department
class EmployeeIdGenerator {
  /// Generate employee ID for a user
  /// Format: uuid only (e.g., abc123de)
  /// This ID is PERMANENT and never changes, even when user transfers departments or roles
  String generateEmployeeId() {
    return _generateShortUuid();
  }

  /// Generate a short UUID (8 characters)
  String _generateShortUuid() {
    final uuid = Uuid();
    return uuid.v4().replaceAll('-', '').substring(0, 8).toLowerCase();
  }

  /// Validate employee ID format (8-character UUID)
  bool isValidEmployeeId(String employeeId) {
    // Format: 8 lowercase hex characters
    final regex = RegExp(r'^[a-z0-9]{8}$');
    return regex.hasMatch(employeeId);
  }
}
