import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User role enum
enum UserRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('department_head')
  departmentHead,
  @JsonValue('employee')
  employee,
}

/// User entity/model
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String phone,
    required UserRole role,
    String? employeeId, // Employee ID (e.g., EMP001)
    String? departmentId,
    String? departmentName,
    DateTime? joiningDate, // Date when employee joined
    DateTime? lastUsed, // Last login/activity timestamp
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Extension for UserModel
extension UserModelX on UserModel {
  /// Check if user is a super admin
  bool get isSuperAdmin => role == UserRole.superAdmin;

  /// Check if user is a department head
  bool get isDepartmentHead => role == UserRole.departmentHead;

  /// Check if user is an employee
  bool get isEmployee => role == UserRole.employee;

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.departmentHead:
        return 'Department Head';
      case UserRole.employee:
        return 'Employee';
    }
  }
}
