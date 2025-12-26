import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Status badge widget for Active/Inactive, Approved/Pending/Rejected
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  /// Active status badge
  factory StatusBadge.active() {
    return StatusBadge(
      label: 'Active',
      color: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  /// Inactive status badge
  factory StatusBadge.inactive() {
    return StatusBadge(
      label: 'Inactive',
      color: AppColors.textSecondary,
      icon: Icons.cancel,
    );
  }

  /// Approved status badge
  factory StatusBadge.approved() {
    return StatusBadge(
      label: 'Approved',
      color: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  /// Pending status badge
  factory StatusBadge.pending() {
    return StatusBadge(
      label: 'Pending',
      color: AppColors.warning,
      icon: Icons.schedule,
    );
  }

  /// Rejected status badge
  factory StatusBadge.rejected() {
    return StatusBadge(
      label: 'Rejected',
      color: AppColors.error,
      icon: Icons.cancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
