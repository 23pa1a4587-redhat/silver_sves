import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../admin/presentation/providers/user_provider.dart';
import '../../../admin/presentation/widgets/user_tile.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../providers/dept_users_provider.dart';
import '../providers/dept_stats_provider.dart';
import 'add_employee_dialog.dart';

/// Department Employees Tab - Exact copy of Users Tab style
class DeptEmployeesTab extends ConsumerStatefulWidget {
  const DeptEmployeesTab({super.key});

  @override
  ConsumerState<DeptEmployeesTab> createState() => _DeptEmployeesTabState();
}

class _DeptEmployeesTabState extends ConsumerState<DeptEmployeesTab> {
  final _searchController = TextEditingController();
  String? _selectedStatus; // null = all, 'active', 'inactive'
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Team'),
        elevation: 0,
        actions: [
          // Filter Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterBottomSheet,
              ),
              // Active filter indicator
              if (_selectedStatus != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: currentUserAsync.maybeWhen(
        data: (user) {
          if (user == null || user.departmentId == null) return null;
          return FloatingActionButton.extended(
            onPressed: () => _showAddEmployeeDialog(user),
            icon: const Icon(Icons.person_add),
            label: const Text('Add Employee'),
            backgroundColor: AppColors.primaryBlue,
          );
        },
        orElse: () => null,
      ),
      body: currentUserAsync.when(
        data: (currentUser) {
          if (currentUser == null || currentUser.departmentId == null) {
            return _buildNoDepartmentState();
          }

          final employeesAsync = ref.watch(
            deptEmployeesProvider(currentUser.departmentId!),
          );

          return Column(
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.all(16.w),
                color: AppColors.white,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, employee ID, or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.grey50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),

              // Employee List
              Expanded(
                child: employeesAsync.when(
                  data: (employees) {
                    // Apply search filter
                    var filteredEmployees = _searchQuery.isEmpty
                        ? employees
                        : employees.where((user) {
                            final query = _searchQuery.toLowerCase();
                            return user.name.toLowerCase().contains(query) ||
                                (user.employeeId?.toLowerCase().contains(
                                      query,
                                    ) ??
                                    false) ||
                                user.phone.toLowerCase().contains(query);
                          }).toList();

                    // Apply status filter
                    if (_selectedStatus == 'active') {
                      filteredEmployees = filteredEmployees
                          .where((u) => u.isActive)
                          .toList();
                    } else if (_selectedStatus == 'inactive') {
                      filteredEmployees = filteredEmployees
                          .where((u) => !u.isActive)
                          .toList();
                    }

                    // Sort: Active users first, then inactive
                    filteredEmployees.sort((a, b) {
                      if (a.isActive == b.isActive) return 0;
                      return a.isActive ? -1 : 1;
                    });

                    if (filteredEmployees.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(
                          deptEmployeesProvider(currentUser.departmentId!),
                        );
                      },
                      child: ListView(
                        padding: EdgeInsets.all(20.w),
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Team Members', style: AppTextStyles.h5),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlueExtraLight,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  '${filteredEmployees.length} ${filteredEmployees.length == 1 ? 'Member' : 'Members'}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Employee List
                          ...filteredEmployees.map((employee) {
                            return UserTile(
                              user: employee,
                              onEdit: () => _showEditEmployeeDialog(
                                employee,
                                currentUser,
                              ),
                              onToggleStatus: () =>
                                  _toggleEmployeeStatus(employee, currentUser),
                            );
                          }),

                          SizedBox(height: 80.h), // Space for FAB
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => _buildErrorState(error),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter Team', style: AppTextStyles.h5),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatus = null;
                          });
                          setModalState(() {});
                        },
                        child: Text('Clear All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Status Filter
                  Text('Status', style: AppTextStyles.labelLarge),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: [
                      _buildFilterChip('All', _selectedStatus == null, () {
                        setState(() => _selectedStatus = null);
                        setModalState(() {});
                      }),
                      _buildFilterChip(
                        'Active',
                        _selectedStatus == 'active',
                        () {
                          setState(() => _selectedStatus = 'active');
                          setModalState(() {});
                        },
                        color: AppColors.success,
                      ),
                      _buildFilterChip(
                        'Inactive',
                        _selectedStatus == 'inactive',
                        () {
                          setState(() => _selectedStatus = 'inactive');
                          setModalState(() {});
                        },
                        color: AppColors.error,
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Apply Filters'),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primaryBlue;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : AppColors.grey100,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNoDepartmentState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.warning),
            SizedBox(height: 16.h),
            Text(
              'No Department Assigned',
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please contact your administrator to assign you to a department.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64.sp, color: AppColors.grey300),
          SizedBox(height: 16.h),
          Text(
            _searchQuery.isNotEmpty ? 'No Results Found' : 'No Team Members',
            style: AppTextStyles.h5,
          ),
          SizedBox(height: 8.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Add team members using the + button',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            'Error loading team',
            style: AppTextStyles.h5.copyWith(color: AppColors.error),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              error.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog(UserModel currentUser) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddEmployeeDialog(
        departmentId: currentUser.departmentId!,
        departmentName: currentUser.departmentName ?? 'Department',
      ),
    );
    if (result == true) {
      ref.invalidate(deptEmployeesProvider(currentUser.departmentId!));
    }
  }

  Future<void> _showEditEmployeeDialog(
    UserModel employee,
    UserModel currentUser,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddEmployeeDialog(
        departmentId: currentUser.departmentId!,
        departmentName: currentUser.departmentName ?? 'Department',
        userToEdit: employee,
      ),
    );

    if (result == true && mounted) {
      ref.invalidate(deptEmployeesProvider(currentUser.departmentId!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Employee updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleEmployeeStatus(
    UserModel employee,
    UserModel currentUser,
  ) async {
    final isActivating = !employee.isActive;
    final action = isActivating ? 'activate' : 'deactivate';

    // Confirm action
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isActivating ? 'Activate' : 'Deactivate'} Employee?'),
        content: Text(
          isActivating
              ? 'Are you sure you want to activate "${employee.name}"?'
              : 'Are you sure you want to deactivate "${employee.name}"? They will not be able to log in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isActivating
                  ? AppColors.success
                  : AppColors.error,
            ),
            child: Text(isActivating ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(userRepositoryProvider);

      if (isActivating) {
        await repository.activateUser(employee.id);
      } else {
        await repository.deactivateUser(employee.id);
      }

      // Invalidate providers to refresh UI
      ref.invalidate(deptEmployeesProvider(currentUser.departmentId!));
      ref.invalidate(deptHeadStatsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Employee ${isActivating ? 'activated' : 'deactivated'} successfully!',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to $action employee: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
