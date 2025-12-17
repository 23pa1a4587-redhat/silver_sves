import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../providers/user_provider.dart';
import '../../../admin/presentation/screens/admin_dashboard.dart';
import 'home_screen.dart';

/// Route handler that navigates to correct dashboard based on user role
class RoleBasedRouter extends ConsumerWidget {
  const RoleBasedRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          // No user found, show error or redirect to login
          return const Scaffold(
            body: Center(child: Text('No user data found')),
          );
        }

        // Navigate based on role
        if (user.isSuperAdmin) {
          return const AdminDashboard();
        } else if (user.isDepartmentHead) {
          // TODO: Create Department Head Dashboard
          return const HomeScreen(); // Temporary - use old home screen
        } else {
          // Employee
          // TODO: Create Employee Dashboard
          return const HomeScreen(); // Temporary - use old home screen
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
