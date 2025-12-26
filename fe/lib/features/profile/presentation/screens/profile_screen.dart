import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../auth/presentation/screens/email_login_screen.dart';
import '../providers/user_leave_provider.dart';
import '../widgets/info_card.dart';
import '../widgets/leave_balance_card.dart';
import '../widgets/leave_history_item.dart';
import '../widgets/profile_header.dart';

/// User profile screen showing personal info, work details, and leave history
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  String _formatLastUsed(DateTime? lastUsed) {
    if (lastUsed == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  int _calculateDaysEmployed(DateTime joiningDate) {
    return DateTime.now().difference(joiningDate).inDays;
  }

  void _showAllLeaveHistory(BuildContext context, List<dynamic> applications) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('All Leave History', style: AppTextStyles.h5),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      return LeaveHistoryItem(application: applications[index]);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text('No user logged in', style: AppTextStyles.bodyMedium),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(user: user),

                SizedBox(height: 20.h),

                // Personal Information
                InfoCard(
                  title: 'Personal Information',
                  icon: Icons.person,
                  items: {
                    'Full Name': user.name,
                    'Employee ID': user.employeeId ?? 'N/A',
                    'Phone': user.phone,
                    'Status': user.isActive ? 'Active' : 'Inactive',
                  },
                ),

                SizedBox(height: 16.h),

                // Work Information
                InfoCard(
                  title: 'Work Information',
                  icon: Icons.work,
                  items: {
                    'Role': user.roleDisplayName,
                    'Department': user.departmentName ?? 'Not Assigned',
                    'Joining Date': user.joiningDate != null
                        ? _formatDate(user.joiningDate!)
                        : 'N/A',
                    'Last Active': _formatLastUsed(user.lastUsed),
                    'Days Employed': user.joiningDate != null
                        ? '${_calculateDaysEmployed(user.joiningDate!)} days'
                        : 'N/A',
                  },
                ),

                SizedBox(height: 16.h),

                // Leave Balance Card with real data
                Consumer(
                  builder: (context, ref, child) {
                    final leaveBalanceAsync = ref.watch(
                      userLeaveBalanceProvider(user.id),
                    );

                    return leaveBalanceAsync.when(
                      data: (balances) => LeaveBalanceCard(balances: balances),
                      loading: () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(40.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Text(
                          'Error loading leave balance',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // Leave History with real data
                Consumer(
                  builder: (context, ref, child) {
                    final leaveAppsAsync = ref.watch(
                      userLeaveApplicationsProvider(user.id),
                    );

                    return leaveAppsAsync.when(
                      data: (applications) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 20.sp,
                                    color: AppColors.primaryBlue,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Leave History',
                                    style: AppTextStyles.h6.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (applications.isNotEmpty)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlueExtraLight,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${applications.length} ${applications.length == 1 ? 'application' : 'applications'}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              SizedBox(height: 16.h),

                              if (applications.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(40.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.grey200,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_busy,
                                          size: 48.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'No leave applications yet',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else ...[
                                // Show only latest 2 applications
                                ...applications
                                    .take(2)
                                    .map(
                                      (app) =>
                                          LeaveHistoryItem(application: app),
                                    ),
                                // View More button if more than 2
                                if (applications.length > 2)
                                  Padding(
                                    padding: EdgeInsets.only(top: 12.h),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          _showAllLeaveHistory(
                                            context,
                                            applications,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.expand_more,
                                          size: 18.sp,
                                        ),
                                        label: Text(
                                          'View All (${applications.length})',
                                          style: AppTextStyles.button.copyWith(
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryBlue,
                                          side: BorderSide(
                                            color: AppColors.primaryBlue,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        );
                      },
                      loading: () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(40.w),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, stack) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        padding: EdgeInsets.all(20.w),
                        child: Text(
                          'Error loading leave history',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 32.h),

                // Logout Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final authRepository = ref.read(authRepositoryProvider);
                        await authRepository.signOut();

                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const EmailLoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading profile: $error',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}
