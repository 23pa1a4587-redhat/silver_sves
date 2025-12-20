import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

/// Department entity/model
@freezed
class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required String id,
    required String name,
    @Default('') String code, // Made optional with default
    @Default('') String description,
    @JsonKey(name: 'head_id') String? headId,
    @JsonKey(name: 'head_name') String? headName,
    @JsonKey(name: 'employee_count') @Default(0) int employeeCount,
    @JsonKey(name: 'employee_id_counter') @Default(0) int employeeIdCounter,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
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
