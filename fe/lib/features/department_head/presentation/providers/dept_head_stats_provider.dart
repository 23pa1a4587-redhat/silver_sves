import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../admin/presentation/providers/user_provider.dart' as admin;
import '../../../admin/presentation/providers/department_provider.dart';

/// Statistics for department head dashboard
class DeptHeadStats {
  final String departmentId;
  final String departmentName;
  final int totalEmployees;
  final int activeEmployees;
  final int inactiveEmployees;

  DeptHeadStats({
    required this.departmentId,
    required this.departmentName,
    required this.totalEmployees,
    required this.activeEmployees,
    required this.inactiveEmployees,
  });
}

/// Provider for department head statistics
final deptHeadStatsProvider = FutureProvider.autoDispose<DeptHeadStats>((
  ref,
) async {
  // Get current user (dept head)
  final currentUser = await ref.watch(currentUserProvider.future);

  if (currentUser == null || currentUser.departmentId == null) {
    throw Exception('Department head must have a department assigned');
  }

  final deptId = currentUser.departmentId!;

  // Get department info
  final department = await ref.watch(departmentProvider(deptId).future);

  if (department == null) {
    throw Exception('Department not found: $deptId');
  }

  // Get employees in this department
  final employees = await ref.watch(
    admin.usersProvider(departmentId: deptId).future,
  );

  final activeCount = employees.where((e) => e.isActive).length;
  final inactiveCount = employees.where((e) => !e.isActive).length;

  return DeptHeadStats(
    departmentId: department.id,
    departmentName: department.name,
    totalEmployees: employees.length,
    activeEmployees: activeCount,
    inactiveEmployees: inactiveCount,
  );
});
