import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../auth/presentation/screens/email_login_screen.dart';

/// Profile tab for department head
class DeptHeadProfileTab extends ConsumerWidget {
  const DeptHeadProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('No user data')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  currentUser.name.isNotEmpty
                      ? currentUser.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              currentUser.name,
              style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Department Head',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Info Card
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.badge,
                    'Employee ID',
                    currentUser.employeeId ?? 'N/A',
                    AppColors.info,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    Icons.phone,
                    'Phone',
                    currentUser.phone,
                    AppColors.success,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    Icons.business,
                    'Department',
                    currentUser.departmentName ?? 'N/A',
                    AppColors.primaryBlue,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Joined',
                    currentUser.joiningDate != null
                        ? DateFormat(
                            'dd MMM yyyy',
                          ).format(currentUser.joiningDate!)
                        : 'N/A',
                    AppColors.warning,
                  ),
                  if (currentUser.lastUsed != null) ...[
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                      Icons.access_time,
                      'Last Login',
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(currentUser.lastUsed!),
                      AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await ref.read(authRepositoryProvider).signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const EmailLoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
