import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import 'department_provider.dart';
import 'user_provider.dart';

part 'admin_stats_provider.g.dart';

/// Model for admin dashboard statistics
class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int totalDepartments;
  final int activeDepartments;
  final int superAdmins;
  final int departmentHeads;
  final int employees;

  const AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalDepartments,
    required this.activeDepartments,
    required this.superAdmins,
    required this.departmentHeads,
    required this.employees,
  });

  int get inactiveUsers => totalUsers - activeUsers;
  int get inactiveDepartments => totalDepartments - activeDepartments;
}

/// Provider for admin dashboard statistics
@riverpod
Future<AdminStats> adminStats(AdminStatsRef ref) async {
  // Fetch all stats in parallel
  final results = await Future.wait([
    ref.watch(userCountProvider(activeOnly: false).future),
    ref.watch(userCountProvider(activeOnly: true).future),
    ref.watch(departmentCountProvider(activeOnly: false).future),
    ref.watch(departmentCountProvider(activeOnly: true).future),
    ref.watch(userCountByRoleProvider(activeOnly: true).future),
  ]);

  final totalUsers = results[0] as int;
  final activeUsers = results[1] as int;
  final totalDepartments = results[2] as int;
  final activeDepartments = results[3] as int;
  final roleCount = results[4] as Map<UserRole, int>;

  return AdminStats(
    totalUsers: totalUsers,
    activeUsers: activeUsers,
    totalDepartments: totalDepartments,
    activeDepartments: activeDepartments,
    superAdmins: roleCount[UserRole.superAdmin] ?? 0,
    departmentHeads: roleCount[UserRole.departmentHead] ?? 0,
    employees: roleCount[UserRole.employee] ?? 0,
  );
}
