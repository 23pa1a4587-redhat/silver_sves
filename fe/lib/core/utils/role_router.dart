import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silver_sves/features/admin/presentation/screens/admin_dashboard.dart';
import 'package:silver_sves/features/auth/data/models/user_model.dart';
import 'package:silver_sves/features/auth/presentation/providers/user_provider.dart';
import 'package:silver_sves/features/auth/presentation/screens/email_login_screen.dart';
import 'package:silver_sves/features/dept_head/presentation/screens/dept_head_dashboard.dart';
import 'package:silver_sves/features/employee/presentation/screens/employee_dashboard.dart';

/// Role-based router that directs users to appropriate dashboard
class RoleBasedRouter extends ConsumerWidget {
  const RoleBasedRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        // No user logged in
        if (user == null) {
          return const EmailLoginScreen();
        }

        // Route based on user role
        switch (user.role) {
          case UserRole.superAdmin:
            return const AdminDashboard();
          case UserRole.departmentHead:
            return const DeptHeadDashboard();
          case UserRole.employee:
            return const EmployeeDashboard();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const EmailLoginScreen(),
    );
  }
}
