import '../../../admin/data/models/leave_application_model.dart';

/// Model for tracking leave balance by type
class LeaveBalance {
  final LeaveType type;
  final int total; // Total allocated for the year
  final int used; // Number of days used
  final int remaining; // Remaining days
  final double percentage; // Usage percentage (0-100)

  const LeaveBalance({
    required this.type,
    required this.total,
    required this.used,
    required this.remaining,
    required this.percentage,
  });

  /// Get display name for leave type
  String get typeName {
    switch (type) {
      case LeaveType.annual:
        return 'Earned Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.casual:
        return 'Casual Leave';
      case LeaveType.emergency:
        return 'Emergency Leave';
    }
  }
}

/// Calculate leave balance from applications with configurable allocations
Map<LeaveType, LeaveBalance> calculateLeaveBalance(
  List<LeaveApplication> applications, {
  int casualAllocation = 12,
  int sickAllocation = 6,
  int earnedAllocation = 15,
  int emergencyAllocation = 7,
}) {
  // Use provided allocations
  final allocations = {
    LeaveType.casual: casualAllocation,
    LeaveType.sick: sickAllocation,
    LeaveType.annual: earnedAllocation,
    LeaveType.emergency: emergencyAllocation,
  };

  final used = <LeaveType, int>{};

  // Count only approved leaves
  for (final app in applications) {
    if (app.status == LeaveStatus.approved) {
      final duration = app.endDate.difference(app.startDate).inDays + 1;
      used[app.type] = (used[app.type] ?? 0) + duration;
    }
  }

  // Build balance map
  return allocations.map((type, total) {
    final usedCount = used[type] ?? 0;
    final remaining = total - usedCount;
    final percentage = total > 0 ? (usedCount / total) * 100 : 0.0;

    return MapEntry(
      type,
      LeaveBalance(
        type: type,
        total: total,
        used: usedCount,
        remaining: remaining > 0 ? remaining : 0,
        percentage: percentage.clamp(0.0, 100.0),
      ),
    );
  });
}
