import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/presentation/widgets/stat_card.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../providers/dept_stats_provider.dart';

/// Department Head Home Tab - Shows department statistics
class DeptHomeTab extends ConsumerWidget {
  const DeptHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(deptHeadStatsProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Dashboard'), elevation: 0),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text('No user data', style: AppTextStyles.bodyMedium),
            );
          }

          return statsAsync.when(
            data: (stats) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(deptHeadStatsProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Text('Welcome, ${user.name}', style: AppTextStyles.h4),

                    SizedBox(height: 8.h),

                    Text(
                      user.departmentName ?? 'Department Head',
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
                            title: 'Total Employees',
                            value: stats.totalEmployees.toString(),
                            icon: Icons.people,
                            color: AppColors.primaryBlue,
                            subtitle: '${stats.activeEmployees} active',
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: StatCard(
                            title: 'Pending Leaves',
                            value: stats.pendingLeaves.toString(),
                            icon: Icons.pending_actions,
                            color: AppColors.warning,
                            subtitle: 'Awaiting approval',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'On Leave Today',
                            value: stats.onLeaveToday.toString(),
                            icon: Icons.event_busy,
                            color: AppColors.info,
                            subtitle: 'Employees absent',
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: StatCard(
                            title: 'Active Staff',
                            value: stats.activeEmployees.toString(),
                            icon: Icons.check_circle,
                            color: AppColors.success,
                            subtitle: 'Currently working',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Department Info
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
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
                                color: AppColors.primaryBlue,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Your Department',
                                style: AppTextStyles.h6.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          _buildInfoRow(
                            'Department',
                            user.departmentName ?? 'N/A',
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow('Your Role', 'Department Head'),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Quick Actions
                    Text('Quick Actions', style: AppTextStyles.h5),

                    SizedBox(height: 16.h),

                    _buildQuickAction(
                      icon: Icons.person_add,
                      title: 'Add Employee',
                      subtitle: 'Add a new team member',
                      onTap: () {
                        // Navigate to My Team tab (index 1)
                        // This could be improved with navigation callback
                      },
                    ),

                    SizedBox(height: 12.h),

                    _buildQuickAction(
                      icon: Icons.pending_actions,
                      title: 'View Leave Requests',
                      subtitle: '${stats.pendingLeaves} pending approvals',
                      onTap: () {
                        // Navigate to Leaves tab (index 2)
                      },
                    ),

                    SizedBox(height: 12.h),

                    _buildQuickAction(
                      icon: Icons.people,
                      title: 'Manage Team',
                      subtitle: 'View and manage your team',
                      onTap: () {
                        // Navigate to My Team tab (index 1)
                      },
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Unable to Load Statistics',
                      style: AppTextStyles.h6.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      error.toString().replaceAll('Exception: ', ''),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Please contact your administrator for assistance.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
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
