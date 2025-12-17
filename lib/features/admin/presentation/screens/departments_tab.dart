import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/department_model.dart';
import '../providers/department_provider.dart';
import '../widgets/department_card.dart';
import 'add_edit_department_dialog.dart';

/// Departments tab - Manage departments
class DepartmentsTab extends ConsumerStatefulWidget {
  const DepartmentsTab({super.key});

  @override
  ConsumerState<DepartmentsTab> createState() => _DepartmentsTabState();
}

class _DepartmentsTabState extends ConsumerState<DepartmentsTab> {
  bool _showInactive = true;

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(
      departmentsProvider(activeOnly: !_showInactive),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Departments'),
        elevation: 0,
        actions: [
          // Filter Toggle
          IconButton(
            icon: Icon(
              _showInactive ? Icons.visibility : Icons.visibility_off,
              color: _showInactive ? AppColors.primaryBlue : null,
            ),
            onPressed: () {
              setState(() {
                _showInactive = !_showInactive;
              });
            },
            tooltip: _showInactive ? 'Hide Inactive' : 'Show Inactive',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDepartmentDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Department'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: departmentsAsync.when(
        data: (departments) {
          if (departments.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(departmentsProvider);
            },
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Departments', style: AppTextStyles.h5),
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
                        '${departments.length} ${departments.length == 1 ? 'Department' : 'Departments'}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Department List
                ...departments.map((department) {
                  return DepartmentCard(
                    department: department,
                    onEdit: () => _showEditDepartmentDialog(department),
                    onToggleStatus: () => _toggleDepartmentStatus(department),
                  );
                }),

                SizedBox(height: 80.h), // Space for FAB
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
              SizedBox(height: 16.h),
              Text(
                'Error loading departments',
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
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(departmentsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 80.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 24.h),
          Text(
            _showInactive ? 'No Inactive Departments' : 'No Departments Yet',
            style: AppTextStyles.h5.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Text(
              _showInactive
                  ? 'All departments are currently active'
                  : 'Create your first department to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (!_showInactive) ...[
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: _showAddDepartmentDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Department'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showAddDepartmentDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddEditDepartmentDialog(),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Department created successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showEditDepartmentDialog(DepartmentModel department) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddEditDepartmentDialog(department: department),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Department updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleDepartmentStatus(DepartmentModel department) async {
    final isActivating = !department.isActive;
    final action = isActivating ? 'activate' : 'deactivate';

    // Confirm action
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isActivating ? 'Activate' : 'Deactivate'} Department?'),
        content: Text(
          isActivating
              ? 'Are you sure you want to activate "${department.name}"?'
              : 'Are you sure you want to deactivate "${department.name}"? New users cannot be added to inactive departments.',
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
      final repository = ref.read(departmentRepositoryProvider);

      if (isActivating) {
        await repository.activateDepartment(department.id);
      } else {
        await repository.deactivateDepartment(department.id);
      }

      // Invalidate providers to refresh UI
      ref.invalidate(departmentsProvider);
      ref.invalidate(departmentCountProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Department ${isActivating ? 'activated' : 'deactivated'} successfully!',
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
            content: Text('Failed to $action department: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
