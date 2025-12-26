import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/data/models/leave_application_model.dart';
import '../../../admin/presentation/providers/leave_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';

/// Department Leaves Tab - Shows leave requests from team for approval
class DeptLeavesTab extends ConsumerStatefulWidget {
  const DeptLeavesTab({super.key});

  @override
  ConsumerState<DeptLeavesTab> createState() => _DeptLeavesTabState();
}

class _DeptLeavesTabState extends ConsumerState<DeptLeavesTab> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Team Leave Requests'), elevation: 0),
      body: userAsync.when(
        data: (user) {
          if (user == null || user.departmentId == null) {
            return _buildEmptyState('No department assigned');
          }

          final leavesAsync = ref.watch(
            departmentLeaveRequestsProvider(user.departmentId!),
          );

          return Column(
            children: [
              // Filter Buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: AppColors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      SizedBox(width: 8.w),
                      _buildFilterChip('Pending', 'pending'),
                      SizedBox(width: 8.w),
                      _buildFilterChip('Approved', 'approved'),
                      SizedBox(width: 8.w),
                      _buildFilterChip('Rejected', 'rejected'),
                    ],
                  ),
                ),
              ),

              // Leave Requests List
              Expanded(
                child: leavesAsync.when(
                  data: (leaves) {
                    // Filter out current user's own leaves
                    final teamLeaves = leaves
                        .where((leave) => leave.userId != user.id)
                        .toList();

                    // Apply status filter
                    final filteredLeaves = teamLeaves.where((leave) {
                      if (_selectedFilter == 'all') return true;
                      return leave.status.toJson() == _selectedFilter;
                    }).toList();

                    if (filteredLeaves.isEmpty) {
                      return _buildEmptyState(
                        _selectedFilter == 'all'
                            ? 'No team leave requests'
                            : 'No $_selectedFilter requests',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(
                          departmentLeaveRequestsProvider(user.departmentId!),
                        );
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: filteredLeaves.length,
                        itemBuilder: (context, index) {
                          final leave = filteredLeaves[index];
                          return _buildLeaveCard(leave, user.id);
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _buildEmptyState('Error loading requests'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildEmptyState('Error loading user'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = value;
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

  Widget _buildLeaveCard(LeaveApplication leave, String currentUserId) {
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
          // Employee name and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  leave.userName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
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

          // Leave type
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueExtraLight,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              _getLeaveTypeName(leave.type),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Dates and duration
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

          // Reason
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

          // Action buttons for pending leaves
          if (leave.status == LeaveStatus.pending) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleReject(leave, currentUserId),
                    icon: Icon(Icons.close, size: 16.sp),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApprove(leave, currentUserId),
                    icon: Icon(Icons.check, size: 16.sp),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64.sp, color: AppColors.grey300),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Leave requests from your team will appear here',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLeaveTypeName(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Earned Leave';
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

  Future<void> _handleApprove(
    LeaveApplication leave,
    String currentUserId,
  ) async {
    try {
      final leaveRepository = ref.read(leaveRepositoryProvider);
      await leaveRepository.updateLeaveStatus(
        leave.id,
        LeaveStatus.approved,
        currentUserId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave approved for ${leave.userName}'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(
    LeaveApplication leave,
    String currentUserId,
  ) async {
    try {
      final leaveRepository = ref.read(leaveRepositoryProvider);
      await leaveRepository.updateLeaveStatus(
        leave.id,
        LeaveStatus.rejected,
        currentUserId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave rejected for ${leave.userName}'),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
