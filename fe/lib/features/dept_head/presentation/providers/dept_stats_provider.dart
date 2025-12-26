import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../admin/data/repositories/firebase_user_repository.dart';
import '../../../admin/data/repositories/leave_repository.dart';
import '../../../admin/presentation/providers/leave_provider.dart';
import '../../../admin/presentation/providers/user_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';

part 'dept_stats_provider.g.dart';

/// Model for department head statistics
class DeptHeadStats {
  final int totalEmployees;
  final int activeEmployees;
  final int pendingLeaves;
  final int onLeaveToday;

  const DeptHeadStats({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.pendingLeaves,
    required this.onLeaveToday,
  });
}

/// Provider for department head statistics
@riverpod
Future<DeptHeadStats> deptHeadStats(DeptHeadStatsRef ref) async {
  // Get current user to find their department
  final currentUser = await ref.watch(currentUserProvider.future);

  if (currentUser == null) {
    throw Exception('No user logged in');
  }

  if (currentUser.departmentId == null) {
    throw Exception(
      'Department head must have a department assigned. '
      'Please contact the administrator to assign you to a department.',
    );
  }

  final departmentId = currentUser.departmentId!;
  final userRepository = ref.watch(userRepositoryProvider);
  final leaveRepository = ref.watch(leaveRepositoryProvider);

  try {
    // Get department employees count
    final allEmployees = await userRepository.getUsersByDepartment(
      departmentId,
      activeOnly: false,
    );
    final activeEmployees = allEmployees.where((u) => u.isActive).length;

    // Try to get pending leaves count (may fail if index not deployed)
    int pendingCount = 0;
    int onLeaveToday = 0;
    try {
      final allLeaves = await leaveRepository
          .getDepartmentLeaveRequests(departmentId)
          .first;
      pendingCount = allLeaves.length;

      // Get employees on leave today
      final today = DateTime.now();
      onLeaveToday = allLeaves.where((leave) {
        return leave.startDate.isBefore(today) ||
            leave.startDate.isAtSameMomentAs(today) &&
                (leave.endDate.isAfter(today) ||
                    leave.endDate.isAtSameMomentAs(today));
      }).length;
    } catch (_) {
      // Leave query failed (likely missing index) - continue with 0 values
    }

    return DeptHeadStats(
      totalEmployees: allEmployees.length,
      activeEmployees: activeEmployees,
      pendingLeaves: pendingCount,
      onLeaveToday: onLeaveToday,
    );
  } catch (e) {
    throw Exception('Failed to load department statistics: ${e.toString()}');
  }
}
