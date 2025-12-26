import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/data/models/leave_application_model.dart';
import '../../data/models/leave_balance_model.dart';

/// Card displaying leave balances with progress bars
class LeaveBalanceCard extends StatelessWidget {
  final Map<LeaveType, LeaveBalance> balances;

  const LeaveBalanceCard({super.key, required this.balances});

  Color _getLeaveTypeColor(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return AppColors.primaryBlue;
      case LeaveType.sick:
        return AppColors.error;
      case LeaveType.casual:
        return AppColors.success;
      case LeaveType.emergency:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.event_available,
                size: 20.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                'Leave Balance',
                style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Leave items
          ...balances.entries.map((entry) {
            final balance = entry.value;
            final color = _getLeaveTypeColor(balance.type);
            final isLast = entry == balances.entries.last;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type name and count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        balance.typeName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${balance.remaining} / ${balance.total} remaining',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Progress bar
                  Stack(
                    children: [
                      // Background
                      Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      // Progress
                      FractionallySizedBox(
                        widthFactor: balance.percentage / 100,
                        child: Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Percentage text
                  Text(
                    '${balance.percentage.toStringAsFixed(0)}% used',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
