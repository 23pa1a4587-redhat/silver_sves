import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import 'phone_login_screen.dart';

/// Welcome screen with navigation to login or seed data
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppColors.elevatedShadow,
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.white,
                  size: 60.sp,
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Leave Management',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              Text(
                'Professional leave tracking and management system',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 60.h),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PhoneLoginScreen(),
                    ),
                  );
                },
                icon: Icons.login,
              ),

              SizedBox(height: 40.h),

              // Info Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'First Time Setup',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'If this is your first time, you need to seed test data before logging in. Use the button on this screen.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
