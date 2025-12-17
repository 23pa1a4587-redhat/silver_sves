import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../auth/presentation/screens/phone_login_screen.dart';

/// Profile tab - Super admin profile
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.primaryBlue,
                  child: Icon(
                    Icons.person,
                    size: 50.sp,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 16.h),

                Text(user.name, style: AppTextStyles.h4),

                SizedBox(height: 8.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueExtraLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    user.roleDisplayName,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final authRepository = ref.read(authRepositoryProvider);
                      await authRepository.signOut();

                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const PhoneLoginScreen(),
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
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
