/// Utility class for generating short IDs from longer UUIDs
class IdGeneratorUtil {
  IdGeneratorUtil._(); // Private constructor

  /// Generate a short 4-character ID from a Firebase UUID with 'dept_' prefix
  ///
  /// Example: 'abc123-def456-ghi789' -> 'dept_abc1'
  static String generateDepartmentId(String firebaseId) {
    // Remove hyphens and take first 4 characters
    final cleanId = firebaseId.replaceAll('-', '');
    final shortId = cleanId.length >= 4
        ? cleanId.substring(0, 4).toLowerCase()
        : cleanId.toLowerCase().padRight(4, '0');

    return 'dept_$shortId';
  }

  /// Generate a short 4-character ID from a Firebase UUID with 'emp_' prefix
  ///
  /// Example: 'abc123-def456-ghi789' -> 'emp_abc1'
  static String generateEmployeeId(String firebaseId) {
    // Remove hyphens and take first 4 characters
    final cleanId = firebaseId.replaceAll('-', '');
    final shortId = cleanId.length >= 4
        ? cleanId.substring(0, 4).toLowerCase()
        : cleanId.toLowerCase().padRight(4, '0');

    return 'emp_$shortId';
  }

  /// Legacy method for backward compatibility - defaults to employee ID
  /// Use generateDepartmentId or generateEmployeeId instead
  @Deprecated('Use generateDepartmentId or generateEmployeeId instead')
  static String generateShortId(String firebaseId) {
    return generateEmployeeId(firebaseId);
  }
}
