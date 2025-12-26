import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../admin/presentation/widgets/stat_card.dart';
import '../providers/dept_head_stats_provider.dart';

/// Home tab for department head dashboard
class DeptHeadHomeTab extends ConsumerWidget {
  const DeptHeadHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final statsAsync = ref.watch(deptHeadStatsProvider);

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
              Text(
                'Welcome, ${currentUser?.name ?? "Department Head"}',
                style: AppTextStyles.h4,
              ),
              SizedBox(height: 8.h),
              Text(
                'Manage your team and department',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              // Department Info Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: AppColors.white,
                          size: 32.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            stats.departmentName,
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Stats Section
              Text('Team Statistics', style: AppTextStyles.h5),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Team',
                      value: stats.totalEmployees.toString(),
                      icon: Icons.people,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: StatCard(
                      title: 'Active',
                      value: stats.activeEmployees.toString(),
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Inactive',
                      value: stats.inactiveEmployees.toString(),
                      icon: Icons.block,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  const Expanded(child: SizedBox()), // Empty space
                ],
              ),

              SizedBox(height: 32.h),

              // Quick Actions
              Text('Quick Actions', style: AppTextStyles.h5),
              SizedBox(height: 16.h),

              _buildQuickAction(
                context,
                icon: Icons.people,
                title: 'View My Team',
                subtitle: 'See all department employees',
                onTap: () {
                  // Navigate to team tab
                  DefaultTabController.of(context).animateTo(1);
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

  Widget _buildQuickAction(
    BuildContext context, {
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
