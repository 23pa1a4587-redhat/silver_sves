import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/department_model.dart';
import '../providers/department_provider.dart';

/// Dialog for adding or editing a department
class AddEditDepartmentDialog extends ConsumerStatefulWidget {
  final DepartmentModel? department; // null for add, non-null for edit

  const AddEditDepartmentDialog({super.key, this.department});

  @override
  ConsumerState<AddEditDepartmentDialog> createState() =>
      _AddEditDepartmentDialogState();
}

class _AddEditDepartmentDialogState
    extends ConsumerState<AddEditDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get _isEditMode => widget.department != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.department!.name;
      _codeController.text = widget.department!.code;
      _descriptionController.text = widget.department!.description ?? '';
    } else {
      // Auto-generate code from name for new departments
      _nameController.addListener(_autoGenerateCode);
    }
  }

  void _autoGenerateCode() {
    if (!_isEditMode) {
      final name = _nameController.text.trim().replaceAll(' ', '');
      if (name.isNotEmpty) {
        // Take first 4 characters and convert to uppercase
        String code;
        if (name.length >= 4) {
          code = name.substring(0, 4).toUpperCase();
        } else {
          // If less than 4 chars, pad with the first character
          code = (name + name[0] * 3).substring(0, 4).toUpperCase();
        }
        _codeController.text = code;
      } else {
        _codeController.text = '';
      }
    }
  }

  @override
  void dispose() {
    if (!_isEditMode) {
      _nameController.removeListener(_autoGenerateCode);
    }
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveDepartment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(departmentRepositoryProvider);
      final code = _codeController.text.trim().toUpperCase();

      // Check if code is unique
      final isUnique = await repository.isDepartmentCodeUnique(
        code,
        excludeId: widget.department?.id,
      );

      if (!isUnique) {
        setState(() {
          _errorMessage = 'Department code "$code" is already in use';
          _isLoading = false;
        });
        return;
      }

      if (_isEditMode) {
        // Update existing department
        final updated = widget.department!.copyWith(
          name: _nameController.text.trim(),
          code: code,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await repository.updateDepartment(updated);
      } else {
        // Create new department
        final newDepartment = DepartmentModel(
          id: '', // Will be set by Firebase
          name: _nameController.text.trim(),
          code: code,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await repository.createDepartment(newDepartment);
      }

      // Invalidate providers to refresh UI
      ref.invalidate(departmentsProvider);
      ref.invalidate(departmentCountProvider);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
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
                        Icons.business,
                        color: AppColors.primaryBlue,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _isEditMode ? 'Edit Department' : 'Add Department',
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

                // Department Name
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Department Name',
                  hintText: 'e.g., Engineering, HR, Finance',
                  prefixIcon: const Icon(Icons.business),
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
                      return 'Department name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Department Code
                CustomTextField(
                  controller: _codeController,
                  labelText: _isEditMode
                      ? 'Department Code'
                      : 'Department Code (Auto-generated)',
                  hintText: 'Auto-filled from department name',
                  prefixIcon: const Icon(Icons.tag),
                  readOnly: !_isEditMode, // Read-only for new departments
                  enabled: _isEditMode, // Disabled styling for new departments
                  maxLength: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Department code is required';
                    }
                    final code = value.trim().toUpperCase();
                    if (code.length != 4) {
                      return 'Code must be exactly 4 letters';
                    }
                    if (!RegExp(r'^[A-Z]{4}$').hasMatch(code)) {
                      return 'Code must contain only letters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // Description (Optional)
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description (Optional)',
                  hintText: 'Brief description of the department',
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 3,
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
                        onPressed: _saveDepartment,
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
}
