import 'package:uuid/uuid.dart';

/// Utility to generate department IDs with name-based prefixes
class DepartmentIdGenerator {
  static const _uuid = Uuid();

  /// Generate department ID with prefix
  /// Format: DEPT_uuid (e.g., ENGI_abc123def)
  static String generateDepartmentId(String departmentName) {
    // Get first 4 letters of department name (uppercase)
    final prefix = _getDepartmentPrefix(departmentName);

    // Generate short UUID (first 8 characters)
    final shortId = _uuid.v4().replaceAll('-', '').substring(0, 8);

    return '${prefix}_$shortId';
  }

  /// Get department prefix (first 4 letters, uppercase)
  static String _getDepartmentPrefix(String departmentName) {
    if (departmentName.isEmpty) {
      return 'DEPT'; // Default prefix
    }

    // Remove spaces and special characters
    final cleaned = departmentName.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    // Take first 4 characters (or less if shorter)
    final prefix = cleaned.length >= 4
        ? cleaned.substring(0, 4)
        : cleaned.padRight(4, 'X');

    return prefix.toUpperCase();
  }

  /// Validate department ID format
  static bool isValidDepartmentId(String departmentId) {
    // Format: 4 uppercase letters + underscore + 8 alphanumeric
    final regex = RegExp(r'^[A-Z]{4}_[a-z0-9]{8}$');
    return regex.hasMatch(departmentId);
  }

  /// Extract prefix from department ID
  static String? getPrefixFromDepartmentId(String departmentId) {
    if (!departmentId.contains('_')) return null;
    return departmentId.split('_').first;
  }
}
