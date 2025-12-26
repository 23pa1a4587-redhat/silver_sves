import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/leave_config_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';

/// Admin screen for managing leave allocations
class LeaveSettingsScreen extends ConsumerStatefulWidget {
  const LeaveSettingsScreen({super.key});

  @override
  ConsumerState<LeaveSettingsScreen> createState() =>
      _LeaveSettingsScreenState();
}

class _LeaveSettingsScreenState extends ConsumerState<LeaveSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _casualController = TextEditingController();
  final _sickController = TextEditingController();
  final _earnedController = TextEditingController();
  final _emergencyController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void dispose() {
    _casualController.dispose();
    _sickController.dispose();
    _earnedController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(leaveConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leave Settings'),
        elevation: 0,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveSettings,
              child: Text(
                'Save',
                style: AppTextStyles.button.copyWith(color: AppColors.white),
              ),
            ),
        ],
      ),
      body: configAsync.when(
        data: (config) {
          // Initialize controllers with current values (only once)
          if (_casualController.text.isEmpty) {
            _casualController.text = config.casualLeave.toString();
            _sickController.text = config.sickLeave.toString();
            _earnedController.text = config.earnedLeave.toString();
            _emergencyController.text = config.emergencyLeave.toString();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'These settings apply to all employees. Changes take effect immediately.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text('Annual Leave Allocations', style: AppTextStyles.h5),
                  SizedBox(height: 16.h),

                  // Leave Type Cards
                  _buildLeaveCard(
                    icon: Icons.beach_access,
                    title: 'Casual Leave',
                    subtitle: 'For personal matters',
                    controller: _casualController,
                    color: AppColors.primaryBlue,
                  ),

                  SizedBox(height: 16.h),

                  _buildLeaveCard(
                    icon: Icons.local_hospital,
                    title: 'Sick Leave',
                    subtitle: 'For medical reasons',
                    controller: _sickController,
                    color: AppColors.error,
                  ),

                  SizedBox(height: 16.h),

                  _buildLeaveCard(
                    icon: Icons.card_giftcard,
                    title: 'Earned Leave',
                    subtitle: 'Accumulated annual leave',
                    controller: _earnedController,
                    color: AppColors.success,
                  ),

                  SizedBox(height: 16.h),

                  _buildLeaveCard(
                    icon: Icons.warning_amber,
                    title: 'Emergency Leave',
                    subtitle: 'For urgent situations',
                    controller: _emergencyController,
                    color: AppColors.warning,
                  ),

                  SizedBox(height: 32.h),

                  // Total Summary
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Annual Allocation',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_calculateTotal()} days',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Failed to load settings',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70.w,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixText: 'days',
                suffixStyle: AppTextStyles.caption,
              ),
              onChanged: (value) {
                setState(() {
                  _hasChanges = true;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotal() {
    int casual = int.tryParse(_casualController.text) ?? 0;
    int sick = int.tryParse(_sickController.text) ?? 0;
    int earned = int.tryParse(_earnedController.text) ?? 0;
    int emergency = int.tryParse(_emergencyController.text) ?? 0;
    return casual + sick + earned + emergency;
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ref.read(currentUserProvider.future);
      final repository = ref.read(leaveConfigRepositoryProvider);

      await repository.updateLeaveConfig(
        casualLeave: int.parse(_casualController.text),
        sickLeave: int.parse(_sickController.text),
        earnedLeave: int.parse(_earnedController.text),
        emergencyLeave: int.parse(_emergencyController.text),
        updatedBy: user?.id ?? 'system',
      );

      setState(() {
        _hasChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Leave settings saved successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
