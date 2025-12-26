import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/data/models/leave_application_model.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../profile/presentation/providers/user_leave_provider.dart';
import '../providers/employee_leave_provider.dart';
import 'apply_leave_dialog.dart';

/// Employee Leaves Tab - View and apply for leaves
class EmployeeLeavesTab extends ConsumerStatefulWidget {
  const EmployeeLeavesTab({super.key});

  @override
  ConsumerState<EmployeeLeavesTab> createState() => _EmployeeLeavesTabState();
}

class _EmployeeLeavesTabState extends ConsumerState<EmployeeLeavesTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final leavesAsync = ref.watch(employeeLeaveRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Leaves'), elevation: 0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showApplyLeaveDialog(context),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'Apply Leave',
          style: AppTextStyles.button.copyWith(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Pending'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Approved'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Rejected'),
                ],
              ),
            ),
          ),

          // Leave List
          Expanded(
            child: leavesAsync.when(
              data: (leaves) {
                // Apply filter
                final filteredLeaves = leaves.where((leave) {
                  if (_selectedFilter == 'All') return true;
                  return leave.status.toJson() == _selectedFilter.toLowerCase();
                }).toList();

                if (filteredLeaves.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 64.sp,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _selectedFilter == 'All'
                              ? 'No leave requests yet'
                              : 'No $_selectedFilter requests',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tap the button below to apply for leave',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(employeeLeaveRequestsProvider);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = filteredLeaves[index];
                      return _buildLeaveCard(leave);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 48.sp, color: AppColors.error),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load leaves',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(employeeLeaveRequestsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primaryBlue : AppColors.white,
        foregroundColor: isSelected ? AppColors.white : AppColors.textPrimary,
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey300,
          ),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLeaveCard(LeaveApplication leave) {
    Color statusColor;
    IconData statusIcon;

    switch (leave.status) {
      case LeaveStatus.approved:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case LeaveStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending;
    }

    final days = leave.endDate.difference(leave.startDate).inDays + 1;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getLeaveTypeName(leave.type),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14.sp, color: statusColor),
                    SizedBox(width: 4.w),
                    Text(
                      leave.status.toJson().toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                '${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.schedule, size: 14.sp, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                '$days day(s)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (leave.reason.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              leave.reason,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _getLeaveTypeName(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.casual:
        return 'Casual Leave';
      case LeaveType.emergency:
        return 'Emergency Leave';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showApplyLeaveDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ApplyLeaveDialog(),
    );

    if (result == true && mounted) {
      // Get current user ID for profile provider
      final user = await ref.read(currentUserProvider.future);

      // Invalidate all leave-related providers
      ref.invalidate(employeeLeaveRequestsProvider);
      ref.invalidate(employeeLeaveBalanceProvider);
      if (user != null) {
        ref.invalidate(userLeaveBalanceProvider(user.id));
        ref.invalidate(userLeaveApplicationsProvider(user.id));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Leave request submitted successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
