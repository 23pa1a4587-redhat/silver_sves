import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../admin/presentation/providers/user_provider.dart' as admin;

/// My Team tab - view department employees
class DeptHeadTeamTab extends ConsumerStatefulWidget {
  const DeptHeadTeamTab({super.key});

  @override
  ConsumerState<DeptHeadTeamTab> createState() => _DeptHeadTeamTabState();
}

class _DeptHeadTeamTabState extends ConsumerState<DeptHeadTeamTab> {
  String _searchQuery = '';
  bool _showInactive = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;

    if (currentUser?.departmentId == null) {
      return const Scaffold(
        body: Center(child: Text('No department assigned')),
      );
    }

    final employeesAsync = ref.watch(
      admin.usersProvider(
        departmentId: currentUser!.departmentId,
        activeOnly: !_showInactive,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Team'),
        elevation: 0,
        actions: [
          // Toggle inactive filter
          Row(
            children: [
              Text('Show Inactive', style: AppTextStyles.bodySmall),
              Switch(
                value: _showInactive,
                onChanged: (value) => setState(() => _showInactive = value),
                activeColor: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: AppColors.white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name or employee ID...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Employee List
          Expanded(
            child: employeesAsync.when(
              data: (employees) {
                // Filter out the current user (dept head) from the list
                var teamMembers = employees
                    .where((e) => e.id != currentUser.id)
                    .toList();

                // Apply local search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  teamMembers = teamMembers.where((e) {
                    return e.name.toLowerCase().contains(query) ||
                        (e.employeeId?.toLowerCase().contains(query) ?? false);
                  }).toList();
                }

                if (teamMembers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80.sp,
                          color: AppColors.grey300,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No employees found',
                          style: AppTextStyles.h6.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    final employee = teamMembers[index];
                    return _buildEmployeeCard(employee);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Error loading team: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(user) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppColors.cardShadow,
        border: user.isActive
            ? null
            : Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 1.5,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (!user.isActive)
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
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 14.sp, color: AppColors.info),
                        SizedBox(width: 4.w),
                        Text(
                          user.employeeId ?? 'No ID',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Additional info
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.phone, size: 14.sp, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                user.phone,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
