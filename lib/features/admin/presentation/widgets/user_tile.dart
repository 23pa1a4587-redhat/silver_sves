import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/data/models/user_model.dart';

/// Expandable user tile widget for displaying user information
class UserTile extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const UserTile({
    super.key,
    required this.user,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppColors.cardShadow,
        border: widget.user.isActive
            ? (_isExpanded
                  ? Border.all(color: AppColors.primaryBlue, width: 2)
                  : null)
            : Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 1.5,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Row (always visible)
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.user.name.isNotEmpty
                              ? widget.user.name[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + Inactive Badge
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.user.name,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              if (!widget.user.isActive)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    'Inactive',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.error,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Employee ID (Full Width)
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.badge,
                                size: 14.sp,
                                color: AppColors.info,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                widget.user.employeeId ?? 'No ID',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          // Role Badge + Department
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(
                                    widget.user.role,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  widget.user.roleDisplayName,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _getRoleColor(widget.user.role),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (widget.user.departmentName != null) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.business,
                                  size: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    widget.user.departmentName!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action Menu (prevent expansion when tapped)
                    GestureDetector(
                      onTap: () {}, // Prevent expansion
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                        ),
                        onSelected: (value) {
                          if (value == 'edit' && widget.onEdit != null) {
                            widget.onEdit!();
                          } else if (value == 'toggle' &&
                              widget.onToggleStatus != null) {
                            widget.onToggleStatus!();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20.sp),
                                SizedBox(width: 8.w),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  widget.user.isActive
                                      ? Icons.block
                                      : Icons.check_circle,
                                  size: 20.sp,
                                  color: widget.user.isActive
                                      ? AppColors.error
                                      : AppColors.success,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  widget.user.isActive
                                      ? 'Deactivate'
                                      : 'Activate',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Expanded Details
                if (_isExpanded) ...[
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.grey200),
                  SizedBox(height: 12.h),

                  // Detailed Information
                  _buildDetailRow(
                    Icons.phone,
                    'Phone',
                    widget.user.phone,
                    AppColors.success,
                  ),
                  SizedBox(height: 8.h),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Joined',
                    widget.user.joiningDate != null
                        ? _formatDate(widget.user.joiningDate!)
                        : 'N/A',
                    AppColors.info,
                  ),
                  if (widget.user.lastUsed != null) ...[
                    SizedBox(height: 8.h),
                    _buildDetailRow(
                      Icons.access_time,
                      'Last Active',
                      _formatDate(widget.user.lastUsed!),
                      AppColors.warning,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  _buildDetailRow(
                    Icons.info_outline,
                    'Status',
                    widget.user.isActive ? 'Active' : 'Inactive',
                    widget.user.isActive ? AppColors.success : AppColors.error,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppColors.error;
      case UserRole.departmentHead:
        return AppColors.warning;
      case UserRole.employee:
        return AppColors.success;
    }
  }
}
