import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/models/leave_config_model.dart';
import '../../../../core/providers/leave_config_provider.dart';
import '../../../admin/data/models/leave_application_model.dart';
import '../../../admin/presentation/providers/leave_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';

part 'employee_leave_provider.g.dart';

/// Model for employee leave balance (shows remaining leaves)
class EmployeeLeaveBalance {
  final int casualLeave; // Remaining casual leaves
  final int sickLeave; // Remaining sick leaves
  final int earnedLeave; // Remaining earned leaves
  final int emergencyLeave; // Remaining emergency leaves
  final int casualUsed; // Used casual leaves
  final int sickUsed; // Used sick leaves
  final int earnedUsed; // Used earned leaves
  final int emergencyUsed; // Used emergency leaves
  final int totalUsed; // Total used across all types

  const EmployeeLeaveBalance({
    required this.casualLeave,
    required this.sickLeave,
    required this.earnedLeave,
    required this.emergencyLeave,
    this.casualUsed = 0,
    this.sickUsed = 0,
    this.earnedUsed = 0,
    this.emergencyUsed = 0,
    required this.totalUsed,
  });
}

/// Provider for employee's leave balance (calculates from applications)
@riverpod
Future<EmployeeLeaveBalance> employeeLeaveBalance(
  EmployeeLeaveBalanceRef ref,
) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    throw Exception('No user logged in');
  }

  // Get leave config from Firestore (with fallback to defaults)
  LeaveConfigModel config;
  try {
    config = await ref.watch(leaveConfigFutureProvider.future);
  } catch (_) {
    config = LeaveConfigModel.defaults();
  }

  // Get employee's leave applications to calculate used leaves
  final leaveRepository = ref.watch(leaveRepositoryProvider);
  List<LeaveApplication> applications;
  try {
    applications = await leaveRepository
        .getUserLeaveApplications(user.id)
        .first;
  } catch (_) {
    applications = [];
  }

  // Calculate used leaves by type (only approved leaves count)
  int casualUsed = 0;
  int sickUsed = 0;
  int earnedUsed = 0;
  int emergencyUsed = 0;

  for (final app in applications) {
    if (app.status == LeaveStatus.approved) {
      final days = app.endDate.difference(app.startDate).inDays + 1;
      switch (app.type) {
        case LeaveType.casual:
          casualUsed += days;
          break;
        case LeaveType.sick:
          sickUsed += days;
          break;
        case LeaveType.annual:
          earnedUsed += days;
          break;
        case LeaveType.emergency:
          emergencyUsed += days;
          break;
      }
    }
  }

  final totalUsed = casualUsed + sickUsed + earnedUsed + emergencyUsed;

  // Calculate remaining leaves (allocation - used)
  return EmployeeLeaveBalance(
    casualLeave: (config.casualLeave - casualUsed).clamp(0, config.casualLeave),
    sickLeave: (config.sickLeave - sickUsed).clamp(0, config.sickLeave),
    earnedLeave: (config.earnedLeave - earnedUsed).clamp(0, config.earnedLeave),
    emergencyLeave: (config.emergencyLeave - emergencyUsed).clamp(
      0,
      config.emergencyLeave,
    ),
    casualUsed: casualUsed,
    sickUsed: sickUsed,
    earnedUsed: earnedUsed,
    emergencyUsed: emergencyUsed,
    totalUsed: totalUsed,
  );
}

/// Provider for employee's leave requests
@riverpod
Future<List<LeaveApplication>> employeeLeaveRequests(
  EmployeeLeaveRequestsRef ref,
) async {
  final user = await ref.watch(currentUserProvider.future);

  if (user == null) {
    throw Exception('No user logged in');
  }

  final leaveRepository = ref.watch(leaveRepositoryProvider);

  // Get employee's leave requests using existing repository method
  final leaves = await leaveRepository.getUserLeaveApplications(user.id).first;

  return leaves;
}
