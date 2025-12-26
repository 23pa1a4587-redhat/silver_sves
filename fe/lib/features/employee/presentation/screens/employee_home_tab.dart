import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/presentation/widgets/stat_card.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../profile/presentation/providers/user_leave_provider.dart';
import '../providers/employee_leave_provider.dart';
import 'apply_leave_dialog.dart';

/// Employee Home Tab - Shows welcome message and leave balance
class EmployeeHomeTab extends ConsumerWidget {
  final VoidCallback? onNavigateToLeaves;

  const EmployeeHomeTab({super.key, this.onNavigateToLeaves});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final leaveBalanceAsync = ref.watch(employeeLeaveBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, size: 24.sp),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('No new notifications'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text('No user data', style: AppTextStyles.bodyMedium),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final currentUser = await ref.read(currentUserProvider.future);
              ref.invalidate(employeeLeaveBalanceProvider);
              ref.invalidate(employeeLeaveRequestsProvider);
              if (currentUser != null) {
                ref.invalidate(userLeaveBalanceProvider(currentUser.id));
                ref.invalidate(userLeaveApplicationsProvider(currentUser.id));
              }
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
                    user.departmentName ?? 'Employee',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Leave Balance Section
                  Text('Leave Balance', style: AppTextStyles.h5),
                  SizedBox(height: 16.h),

                  leaveBalanceAsync.when(
                    data: (balance) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Casual Leave',
                                value: balance.casualLeave.toString(),
                                icon: Icons.beach_access,
                                color: AppColors.primaryBlue,
                                subtitle: 'Available',
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: StatCard(
                                title: 'Sick Leave',
                                value: balance.sickLeave.toString(),
                                icon: Icons.local_hospital,
                                color: AppColors.error,
                                subtitle: 'Available',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Earned Leave',
                                value: balance.earnedLeave.toString(),
                                icon: Icons.card_giftcard,
                                color: AppColors.success,
                                subtitle: 'Available',
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: StatCard(
                                title: 'Emergency Leave',
                                value: balance.emergencyLeave.toString(),
                                icon: Icons.warning_amber,
                                color: AppColors.warning,
                                subtitle: 'Available',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.h),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Failed to load leave balance',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Quick Actions
                  Text('Quick Actions', style: AppTextStyles.h5),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          ref,
                          icon: Icons.add_circle,
                          label: 'Apply Leave',
                          color: AppColors.primaryBlue,
                          onTap: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ApplyLeaveDialog(),
                            );
                            if (result == true) {
                              // Get current user for profile provider invalidation
                              final currentUser = await ref.read(
                                currentUserProvider.future,
                              );

                              // Invalidate all leave-related providers
                              ref.invalidate(employeeLeaveRequestsProvider);
                              ref.invalidate(employeeLeaveBalanceProvider);
                              if (currentUser != null) {
                                ref.invalidate(
                                  userLeaveBalanceProvider(currentUser.id),
                                );
                                ref.invalidate(
                                  userLeaveApplicationsProvider(currentUser.id),
                                );
                              }

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Leave request submitted!',
                                    ),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          ref,
                          icon: Icons.history,
                          label: 'Leave History',
                          color: AppColors.success,
                          onTap: () {
                            if (onNavigateToLeaves != null) {
                              onNavigateToLeaves!();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error: ${e.toString()}',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
