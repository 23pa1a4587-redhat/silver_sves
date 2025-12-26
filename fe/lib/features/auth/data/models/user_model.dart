import 'package:cloud_firestore/cloud_firestore.dart';

/// User role enum
enum UserRole {
  superAdmin,
  departmentHead,
  employee;

  /// Convert UserRole to JSON string
  String toJson() {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.departmentHead:
        return 'department_head';
      case UserRole.employee:
        return 'employee';
    }
  }

  /// Create UserRole from JSON string
  static UserRole fromJson(String value) {
    switch (value) {
      case 'super_admin':
        return UserRole.superAdmin;
      case 'department_head':
        return UserRole.departmentHead;
      case 'employee':
        return UserRole.employee;
      default:
        throw ArgumentError('Invalid UserRole value: $value');
    }
  }
}

/// User entity/model
class UserModel {
  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final String? employeeId; // 8-char shortened ID (PERMANENT, never changes)
  final String? departmentId;
  final String? departmentName;
  final DateTime? joiningDate; // Date when employee joined
  final DateTime? lastUsed; // Last login/activity timestamp
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.employeeId,
    this.departmentId,
    this.departmentName,
    this.joiningDate,
    this.lastUsed,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: UserRole.fromJson(json['role'] as String),
      // Support both old (camelCase) and new (snake_case) field names
      employeeId: json['employeeId'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['departmentName'] as String?,
      joiningDate: _timestampToDateTime(json['joiningDate']),
      lastUsed: _timestampToDateTime(json['lastUsed']),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _timestampToDateTime(json['createdAt']),
      updatedAt: _timestampToDateTime(json['updatedAt']),
    );
  }

  /// Convert UserModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role.toJson(),
      if (employeeId != null) 'employeeId': employeeId,
      if (departmentId != null) 'departmentId': departmentId,
      if (departmentName != null) 'departmentName': departmentName,
      if (joiningDate != null) 'joiningDate': Timestamp.fromDate(joiningDate!),
      if (lastUsed != null) 'lastUsed': Timestamp.fromDate(lastUsed!),
      'isActive': isActive,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Helper method to convert Firestore Timestamp to DateTime
  static DateTime? _timestampToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  /// Create a copy of this model with modified fields
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    UserRole? role,
    String? employeeId,
    String? departmentId,
    String? departmentName,
    DateTime? joiningDate,
    DateTime? lastUsed,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      joiningDate: joiningDate ?? this.joiningDate,
      lastUsed: lastUsed ?? this.lastUsed,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, role: ${role.toJson()})';
  }
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

  /// Get the collection name for this user's role
  String getCollectionName() {
    switch (role) {
      case UserRole.superAdmin:
        return 'super_admins';
      case UserRole.departmentHead:
        return 'department_heads';
      case UserRole.employee:
        return 'employees';
    }
  }
}
