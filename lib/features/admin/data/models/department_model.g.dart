// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DepartmentModelImpl _$$DepartmentModelImplFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  r'_$DepartmentModelImpl',
  json,
  ($checkedConvert) {
    final val = _$DepartmentModelImpl(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      code: $checkedConvert('code', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String?),
      headId: $checkedConvert('head_id', (v) => v as String?),
      headName: $checkedConvert('head_name', (v) => v as String?),
      employeeCount: $checkedConvert(
        'employee_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      employeeIdCounter: $checkedConvert(
        'employee_id_counter',
        (v) => (v as num?)?.toInt() ?? 0,
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
    'headId': 'head_id',
    'headName': 'head_name',
    'employeeCount': 'employee_count',
    'employeeIdCounter': 'employee_id_counter',
    'isActive': 'is_active',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$$DepartmentModelImplToJson(
  _$DepartmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'description': instance.description,
  'head_id': instance.headId,
  'head_name': instance.headName,
  'employee_count': instance.employeeCount,
  'employee_id_counter': instance.employeeIdCounter,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
