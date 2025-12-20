import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/employee_id_generator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/data/models/user_model.dart';
import '../providers/department_provider.dart';
import '../providers/user_provider.dart';

/// Dialog for adding or editing a user
class AddEditUserDialog extends ConsumerStatefulWidget {
  final UserModel? user; // null for add, non-null for edit

  const AddEditUserDialog({super.key, this.user});

  @override
  ConsumerState<AddEditUserDialog> createState() => _AddEditUserDialogState();
}

class _AddEditUserDialogState extends ConsumerState<AddEditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedDepartmentId;
  UserRole _selectedRole = UserRole.employee;
  DateTime? _joiningDate;

  bool get _isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.user!.name;
      // Strip +91 prefix from phone since the field already has +91 prefix
      final phone = widget.user!.phone;
      _phoneController.text = phone.startsWith('+91')
          ? phone.substring(3)
          : phone;
      _employeeIdController.text = widget.user!.employeeId ?? '';
      _selectedDepartmentId = widget.user!.departmentId;
      _selectedRole = widget.user!.role;
      _joiningDate = widget.user!.joiningDate;
    } else {
      _joiningDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  Future<void> _generateEmployeeId() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Generate permanent employee ID (just a UUID)
      final generator = EmployeeIdGenerator();
      final employeeId = generator.generateEmployeeId();

      _employeeIdController.text = employeeId;
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate employee ID: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartmentId == null && _selectedRole == UserRole.employee) {
      setState(() {
        _errorMessage = 'Please select a department for employees';
      });
      return;
    }

    if (_joiningDate == null) {
      setState(() {
        _errorMessage = 'Please select a joining date';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(userRepositoryProvider);

      // Format phone to E164 (+91xxxxxxxxxx)
      final formattedPhone = '+91${_phoneController.text.trim()}';

      // Check if phone is unique
      final isUnique = await repository.isPhoneUnique(
        formattedPhone,
        excludeId: widget.user?.id,
      );

      if (!isUnique) {
        setState(() {
          _errorMessage =
              'Phone number "${_phoneController.text}" is already in use';
          _isLoading = false;
        });
        return;
      }

      // Get department name if department is selected
      String? departmentName;
      if (_selectedDepartmentId != null) {
        final deptRepository = ref.read(departmentRepositoryProvider);
        final department = await deptRepository.getDepartmentById(
          _selectedDepartmentId!,
        );
        departmentName = department?.name;
      }

      if (_isEditMode) {
        // Update existing user
        final updated = widget.user!.copyWith(
          name: _nameController.text.trim(),
          phone: formattedPhone,
          role: _selectedRole,
          departmentId: _selectedDepartmentId,
          departmentName: departmentName,
          employeeId: _employeeIdController.text.trim().isEmpty
              ? null
              : _employeeIdController.text.trim(),
          joiningDate: _joiningDate,
        );
        await repository.updateUser(updated);
      } else {
        // Create new user
        final newUser = UserModel(
          id: '', // Will be set by Firebase
          name: _nameController.text.trim(),
          phone: formattedPhone,
          role: _selectedRole,
          departmentId: _selectedDepartmentId,
          departmentName: departmentName,
          employeeId: _employeeIdController.text.trim().isEmpty
              ? null
              : _employeeIdController.text.trim(),
          joiningDate: _joiningDate!,
        );
        await repository.createUser(newUser);
      }

      // Invalidate providers to refresh UI
      ref.invalidate(usersProvider);
      ref.invalidate(userCountProvider);
      ref.invalidate(userCountByRoleProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeDepartmentsAsync = ref.watch(activeDepartmentsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueExtraLight,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.person_add,
                        color: AppColors.primaryBlue,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _isEditMode ? 'Edit User' : 'Add User',
                        style: AppTextStyles.h5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Name
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                  prefixIcon: const Icon(Icons.person),
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return TextEditingValue(
                        text: newValue.text.toUpperCase(),
                        selection: newValue.selection,
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Phone
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: '9876543210',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      '+91',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.trim().length != 10) {
                      return 'Phone number must be exactly 10 digits';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Role Selection
                Text(
                  'Role',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleChip(
                        'Employee',
                        UserRole.employee,
                        Icons.person,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildRoleChip(
                        'Dept Head',
                        UserRole.departmentHead,
                        Icons.supervisor_account,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Department Selection
                activeDepartmentsAsync.when(
                  data: (departments) {
                    if (departments.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          'No active departments found. Please create departments first.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Department',
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          // Only set value if it exists in the departments list
                          value:
                              departments.any(
                                (d) => d.id == _selectedDepartmentId,
                              )
                              ? _selectedDepartmentId
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Select department',
                            prefixIcon: const Icon(Icons.business),
                            filled: true,
                            fillColor: AppColors.grey50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.grey200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.grey200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.primaryBlue,
                                width: 2,
                              ),
                            ),
                          ),
                          items: departments.map((dept) {
                            return DropdownMenuItem(
                              value: dept.id,
                              child: Text(dept.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartmentId = value;
                              // Auto-generate employee ID when department is selected
                              if (value != null && !_isEditMode) {
                                _generateEmployeeId();
                              }
                            });
                          },
                          validator: _selectedRole == UserRole.employee
                              ? (value) {
                                  if (value == null) {
                                    return 'Department is required for employees';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ],
                    );
                  },
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Failed to load departments',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          error.toString(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Employee ID (Auto-generated, read-only for new users, non-editable when editing)
                CustomTextField(
                  controller: _employeeIdController,
                  labelText: _isEditMode
                      ? 'Employee ID'
                      : 'Employee ID (Auto-generated)',
                  hintText: 'Select department to generate',
                  prefixIcon: const Icon(Icons.badge),
                  readOnly: true, // Always read-only
                  enabled: false, // Always disabled to show it's non-editable
                ),

                SizedBox(height: 16.h),

                // Joining Date Selection
                Text(
                  'Joining Date',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _joiningDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _joiningDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          _joiningDate != null
                              ? '${_joiningDate!.day.toString().padLeft(2, '0')}-${_joiningDate!.month.toString().padLeft(2, '0')}-${_joiningDate!.year}'
                              : 'Select joining date',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _joiningDate != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        text: _isEditMode ? 'Update' : 'Create',
                        onPressed: _saveUser,
                        isLoading: _isLoading,
                        icon: _isEditMode ? Icons.check : Icons.add,
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

  Widget _buildRoleChip(String label, UserRole role, IconData icon) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.grey50,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
