import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/data/models/leave_application_model.dart';
import 'status_badge.dart';

/// Individual leave application card for history
class LeaveHistoryItem extends StatelessWidget {
  final LeaveApplication application;

  const LeaveHistoryItem({super.key, required this.application});

  Color _getLeaveTypeColor() {
    switch (application.type) {
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

  String _getLeaveTypeName() {
    switch (application.type) {
      case LeaveType.annual:
        return 'ANNUAL LEAVE';
      case LeaveType.sick:
        return 'SICK LEAVE';
      case LeaveType.casual:
        return 'CASUAL LEAVE';
      case LeaveType.emergency:
        return 'EMERGENCY LEAVE';
    }
  }

  StatusBadge _getStatusBadge() {
    switch (application.status) {
      case LeaveStatus.approved:
        return StatusBadge.approved();
      case LeaveStatus.pending:
        return StatusBadge.pending();
      case LeaveStatus.rejected:
        return StatusBadge.rejected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLeaveTypeColor();
    final duration =
        application.endDate.difference(application.startDate).inDays + 1;
    final dateFormat = DateFormat('d MMM yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getLeaveTypeName(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              _getStatusBadge(),
            ],
          ),

          SizedBox(height: 12.h),

          // Dates and Duration
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Text(
                '${dateFormat.format(application.startDate)} - ${dateFormat.format(application.endDate)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '$duration ${duration == 1 ? 'day' : 'days'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Reason
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notes, size: 14.sp, color: AppColors.textSecondary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  application.reason,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (application.createdAt != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Applied: ${dateFormat.format(application.createdAt!)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
