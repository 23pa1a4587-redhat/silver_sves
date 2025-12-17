import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/department_model.dart';

/// Department card widget for displaying department information
class DepartmentCard extends StatelessWidget {
  final DepartmentModel department;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const DepartmentCard({
    super.key,
    required this.department,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppColors.cardShadow,
        border: department.isActive
            ? null
            : Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 1.5,
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Department Icon
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: department.isActive
                            ? AppColors.primaryBlueExtraLight
                            : AppColors.grey100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.business,
                        color: department.isActive
                            ? AppColors.primaryBlue
                            : AppColors.textSecondary,
                        size: 24.sp,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Department Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  department.name,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              if (!department.isActive)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
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
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Code: ${department.code}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Button
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.textSecondary,
                      ),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'toggle' &&
                            onToggleStatus != null) {
                          onToggleStatus!();
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
                                department.isActive
                                    ? Icons.block
                                    : Icons.check_circle,
                                size: 20.sp,
                                color: department.isActive
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                department.isActive ? 'Deactivate' : 'Activate',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Department Details
                if (department.description != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    department.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: 12.h),

                // Stats Row
                Row(
                  children: [
                    _buildStat(
                      icon: Icons.people,
                      label: '${department.employeeCount} Employees',
                      color: AppColors.info,
                    ),
                    SizedBox(width: 16.w),
                    if (department.headName != null)
                      Expanded(
                        child: _buildStat(
                          icon: Icons.person,
                          label: 'Head: ${department.headName}',
                          color: AppColors.success,
                        ),
                      )
                    else
                      Expanded(
                        child: _buildStat(
                          icon: Icons.person_off,
                          label: 'No head assigned',
                          color: AppColors.warning,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontSize: 11.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
