import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/data/models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';
import 'add_edit_user_dialog.dart';

/// Users tab - Manage users
class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  final _searchController = TextEditingController();
  UserRole? _selectedRole;
  String? _selectedDepartmentId;
  bool _showInactive = true;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(
      usersProvider(
        activeOnly: !_showInactive,
        role: _selectedRole,
        departmentId: _selectedDepartmentId,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Users'),
        elevation: 0,
        actions: [
          // Show/Hide Inactive Toggle
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
        onPressed: () => _showAddUserDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: EdgeInsets.all(16.w),
            color: AppColors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
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

                SizedBox(height: 12.h),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'All Roles',
                        _selectedRole == null,
                        () => setState(() => _selectedRole = null),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        'Employees',
                        _selectedRole == UserRole.employee,
                        () => setState(() => _selectedRole = UserRole.employee),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        'Dept Heads',
                        _selectedRole == UserRole.departmentHead,
                        () => setState(
                          () => _selectedRole = UserRole.departmentHead,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: usersAsync.when(
              data: (users) {
                // Apply search filter
                final filteredUsers = _searchQuery.isEmpty
                    ? users
                    : users.where((user) {
                        final query = _searchQuery.toLowerCase();
                        return user.name.toLowerCase().contains(query) ||
                            (user.employeeId?.toLowerCase().contains(query) ??
                                false) ||
                            user.phone.toLowerCase().contains(query);
                      }).toList();

                if (filteredUsers.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(usersProvider);
                  },
                  child: ListView(
                    padding: EdgeInsets.all(20.w),
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('All Users', style: AppTextStyles.h5),
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
                              '${filteredUsers.length} ${filteredUsers.length == 1 ? 'User' : 'Users'}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // User List
                      ...filteredUsers.map((user) {
                        return UserTile(
                          user: user,
                          onEdit: () => _showEditUserDialog(user),
                          onToggleStatus: () => _toggleUserStatus(user),
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
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading users',
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
                        ref.invalidate(usersProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
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

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.grey100,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outlined,
            size: 80.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 24.h),
          Text(
            _searchQuery.isNotEmpty ? 'No users found' : 'No Users Yet',
            style: AppTextStyles.h5.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Add your first user to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: _showAddUserDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Add User'),
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

  Future<void> _showAddUserDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddEditUserDialog(),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User created successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showEditUserDialog(UserModel user) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddEditUserDialog(user: user),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User updated successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleUserStatus(UserModel user) async {
    final isActivating = !user.isActive;
    final action = isActivating ? 'activate' : 'deactivate';

    // Confirm action
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isActivating ? 'Activate' : 'Deactivate'} User?'),
        content: Text(
          isActivating
              ? 'Are you sure you want to activate "${user.name}"?'
              : 'Are you sure you want to deactivate "${user.name}"? They will not be able to log in.',
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
        await repository.activateUser(user.id);
      } else {
        await repository.deactivateUser(user.id);
      }

      // Invalidate providers to refresh UI
      ref.invalidate(usersProvider);
      ref.invalidate(userCountProvider);
      ref.invalidate(userCountByRoleProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User ${isActivating ? 'activated' : 'deactivated'} successfully!',
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
            content: Text('Failed to $action user: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
