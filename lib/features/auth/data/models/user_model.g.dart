// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  r'_$UserModelImpl',
  json,
  ($checkedConvert) {
    final val = _$UserModelImpl(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      phone: $checkedConvert('phone', (v) => v as String),
      role: $checkedConvert('role', (v) => $enumDecode(_$UserRoleEnumMap, v)),
      employeeId: $checkedConvert('employee_id', (v) => v as String?),
      departmentId: $checkedConvert('department_id', (v) => v as String?),
      departmentName: $checkedConvert('department_name', (v) => v as String?),
      joiningDate: $checkedConvert(
        'joining_date',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      lastUsed: $checkedConvert(
        'last_used',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'employeeId': 'employee_id',
    'departmentId': 'department_id',
    'departmentName': 'department_name',
    'joiningDate': 'joining_date',
    'lastUsed': 'last_used',
    'isActive': 'is_active',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'employee_id': instance.employeeId,
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'joining_date': instance.joiningDate?.toIso8601String(),
      'last_used': instance.lastUsed?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'super_admin',
  UserRole.departmentHead: 'department_head',
  UserRole.employee: 'employee',
};
