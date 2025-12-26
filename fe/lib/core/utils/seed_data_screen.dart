import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/custom_button.dart';
import 'department_sync_util.dart';
import 'firestore_seeder.dart';

/// Debug screen to seed test data
class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  final _seeder = FirestoreSeeder();
  bool _isSeeding = false;
  String? _message;
  bool _isSuccess = false;

  Future<void> _seedData() async {
    setState(() {
      _isSeeding = true;
      _message = null;
    });

    try {
      await _seeder.seedAllTestData();
      setState(() {
        _isSuccess = true;
        _message = 'Successfully seeded all test data!';
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSeeding = false;
      });
    }
  }

  Future<void> _clearData() async {
    setState(() {
      _isSeeding = true;
      _message = null;
    });

    try {
      await _seeder.clearTestUsers();
      setState(() {
        _isSuccess = true;
        _message = 'Successfully cleared test users!';
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSeeding = false;
      });
    }
  }

  Future<void> _activateAllUsers() async {
    setState(() {
      _isSeeding = true;
      _message = null;
    });

    try {
      await _seeder.activateAllUsers();
      setState(() {
        _isSuccess = true;
        _message = 'Successfully activated all users!';
      });
    } catch (e) {
      setState(() {
        _isSuccess = false;
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSeeding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Seed Test Data'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'This is for development only. Do not use in production!',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Title
                Text('Test Data Seeding', style: AppTextStyles.h4),

                SizedBox(height: 8.h),

                Text(
                  'This will create test users and departments in Firestore for development and testing purposes.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 32.h),

                // Test Users Info
                _buildInfoCard(
                  title: 'Test Users to be Created',
                  items: [
                    '1. Super Admin (+919999999999)',
                    '2. Department Head (+919999999998)',
                    '3. Employee (+919999999997)',
                  ],
                ),

                SizedBox(height: 16.h),

                _buildInfoCard(
                  title: 'Test Department',
                  items: ['Engineering Department'],
                ),

                SizedBox(height: 32.h),

                // Seed Button
                CustomButton(
                  text: 'Seed Test Data',
                  onPressed: _isSeeding ? null : _seedData,
                  isLoading: _isSeeding,
                  icon: Icons.cloud_upload,
                ),

                SizedBox(height: 16.h),

                // Clear Button
                CustomButton(
                  text: 'Clear Test Users',
                  onPressed: _isSeeding ? null : _clearData,
                  isLoading: false,
                  isOutlined: true,
                  icon: Icons.delete_outline,
                ),

                SizedBox(height: 16.h),

                // Activate All Users Button
                CustomButton(
                  text: 'Activate All Users',
                  onPressed: _isSeeding ? null : _activateAllUsers,
                  isLoading: false,
                  icon: Icons.check_circle_outline,
                ),

                SizedBox(height: 24.h),

                // Message
                if (_message != null)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: _isSuccess
                          ? AppColors.successLight
                          : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isSuccess ? Icons.check_circle : Icons.error,
                          color: _isSuccess
                              ? AppColors.success
                              : AppColors.error,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            _message!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _isSuccess
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 40.h),

                // Instructions
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'After Seeding',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You can login with any of the test phone numbers using OTP: 123456',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<String> items}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge),
          SizedBox(height: 12.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16.sp,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(item, style: AppTextStyles.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
