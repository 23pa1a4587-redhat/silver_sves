import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../providers/user_provider.dart';
import '../../../admin/presentation/screens/admin_dashboard.dart';
import '../../../dept_head/presentation/screens/dept_head_dashboard.dart';
import '../../../employee/presentation/screens/employee_dashboard.dart';
import 'email_login_screen.dart';

/// Route handler that navigates to correct dashboard based on user role
class RoleBasedRouter extends ConsumerWidget {
  const RoleBasedRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          // No user found, redirect to login
          return const EmailLoginScreen();
        }

        // Navigate based on role
        if (user.isSuperAdmin) {
          return const AdminDashboard();
        } else if (user.isDepartmentHead) {
          return const DeptHeadDashboard();
        } else {
          // Employee
          return const EmployeeDashboard();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
