import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

/// Department entity/model
@freezed
class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required String id,
    required String name,
    required String
    code, // 4-letter code for employee ID generation (e.g., ACAD, ENG)
    String? description,
    String? headId, // Department head user ID
    String? headName, // Department head name (denormalized)
    @Default(0) int employeeCount,
    @Default(0)
    int employeeIdCounter, // Auto-increment counter for employee IDs
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}

/// Extension for DepartmentModel
extension DepartmentModelX on DepartmentModel {
  /// Get next employee ID for this department
  String getNextEmployeeId() {
    final nextNumber = employeeIdCounter + 1;
    return '$code${nextNumber.toString().padLeft(3, '0')}';
  }

  /// Check if department has a head assigned
  bool get hasHead => headId != null && headId!.isNotEmpty;

  /// Get display name with employee count
  String get displayNameWithCount => '$name ($employeeCount employees)';
}
