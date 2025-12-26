import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/admin_stats_provider.dart';
import '../widgets/stat_card.dart';
import 'leave_settings_screen.dart';

/// Home tab - Dashboard overview with statistics
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Dashboard'), elevation: 0),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text('Welcome, Super Admin', style: AppTextStyles.h4),

              SizedBox(height: 8.h),

              Text(
                'Here\'s an overview of your system',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Users',
                      value: stats.totalUsers.toString(),
                      icon: Icons.people,
                      color: AppColors.primaryBlue,
                      subtitle: '${stats.activeUsers} active',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: StatCard(
                      title: 'Departments',
                      value: stats.totalDepartments.toString(),
                      icon: Icons.business,
                      color: AppColors.success,
                      subtitle: '${stats.activeDepartments} active',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Pending Requests',
                      value: '0', // TODO: Implement leave requests count
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                      subtitle: 'Leave requests',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: StatCard(
                      title: 'On Leave Today',
                      value: '0', // TODO: Implement today's leave count
                      icon: Icons.event_busy,
                      color: AppColors.info,
                      subtitle: 'Employees absent',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Quick Actions
              Text('Quick Actions', style: AppTextStyles.h5),

              SizedBox(height: 16.h),

              _buildQuickAction(
                icon: Icons.person_add,
                title: 'Add User',
                subtitle: 'Create a new employee or department head',
                onTap: () {
                  // Navigate to add user screen
                },
              ),

              SizedBox(height: 12.h),

              _buildQuickAction(
                icon: Icons.add_business,
                title: 'Add Department',
                subtitle: 'Create a new department',
                onTap: () {
                  // Navigate to add department screen
                },
              ),

              SizedBox(height: 12.h),

              _buildQuickAction(
                icon: Icons.settings,
                title: 'Leave Settings',
                subtitle: 'Configure leave allocations',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaveSettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading stats: $error')),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlueExtraLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
