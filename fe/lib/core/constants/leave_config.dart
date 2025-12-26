/// Global leave configuration constants
/// This file defines all leave types and their default allocations
class LeaveConfig {
  LeaveConfig._(); // Private constructor to prevent instantiation

  // ============================================
  // LEAVE TYPE ALLOCATIONS (per year)
  // ============================================

  /// Casual Leave - For personal matters, short absences
  static const int casualLeaveAllocation = 12;

  /// Sick Leave - For medical reasons
  static const int sickLeaveAllocation = 6;

  /// Earned Leave / Annual Leave - Accumulated leave
  static const int earnedLeaveAllocation = 15;

  /// Emergency Leave - For urgent situations
  static const int emergencyLeaveAllocation = 7;

  // ============================================
  // TOTAL ALLOCATION
  // ============================================

  static int get totalLeaveAllocation =>
      casualLeaveAllocation +
      sickLeaveAllocation +
      earnedLeaveAllocation +
      emergencyLeaveAllocation;

  // ============================================
  // LEAVE TYPE DISPLAY NAMES
  // ============================================

  static const Map<String, String> leaveTypeNames = {
    'casual': 'Casual Leave',
    'sick': 'Sick Leave',
    'annual': 'Earned Leave',
    'emergency': 'Emergency Leave',
  };

  // ============================================
  // LEAVE TYPE ICONS (for UI)
  // ============================================

  static const Map<String, int> leaveTypeIcons = {
    'casual': 0xe0db, // Icons.beach_access
    'sick': 0xe3f1, // Icons.local_hospital
    'annual': 0xe8f6, // Icons.card_giftcard
    'emergency': 0xe6c1, // Icons.warning
  };

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get allocation for a specific leave type
  static int getAllocation(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'casual':
        return casualLeaveAllocation;
      case 'sick':
        return sickLeaveAllocation;
      case 'annual':
      case 'earned':
        return earnedLeaveAllocation;
      case 'emergency':
        return emergencyLeaveAllocation;
      default:
        return 0;
    }
  }

  /// Get display name for a leave type
  static String getDisplayName(String leaveType) {
    return leaveTypeNames[leaveType.toLowerCase()] ?? leaveType;
  }
}
