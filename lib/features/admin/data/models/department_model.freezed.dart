// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'department_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) {
  return _DepartmentModel.fromJson(json);
}

/// @nodoc
mixin _$DepartmentModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code =>
      throw _privateConstructorUsedError; // Made optional with default
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'head_id')
  String? get headId => throw _privateConstructorUsedError;
  @JsonKey(name: 'head_name')
  String? get headName => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_count')
  int get employeeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id_counter')
  int get employeeIdCounter => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DepartmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DepartmentModelCopyWith<DepartmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepartmentModelCopyWith<$Res> {
  factory $DepartmentModelCopyWith(
    DepartmentModel value,
    $Res Function(DepartmentModel) then,
  ) = _$DepartmentModelCopyWithImpl<$Res, DepartmentModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String code,
    String description,
    @JsonKey(name: 'head_id') String? headId,
    @JsonKey(name: 'head_name') String? headName,
    @JsonKey(name: 'employee_count') int employeeCount,
    @JsonKey(name: 'employee_id_counter') int employeeIdCounter,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$DepartmentModelCopyWithImpl<$Res, $Val extends DepartmentModel>
    implements $DepartmentModelCopyWith<$Res> {
  _$DepartmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? headId = freezed,
    Object? headName = freezed,
    Object? employeeCount = null,
    Object? employeeIdCounter = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            headId: freezed == headId
                ? _value.headId
                : headId // ignore: cast_nullable_to_non_nullable
                      as String?,
            headName: freezed == headName
                ? _value.headName
                : headName // ignore: cast_nullable_to_non_nullable
                      as String?,
            employeeCount: null == employeeCount
                ? _value.employeeCount
                : employeeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            employeeIdCounter: null == employeeIdCounter
                ? _value.employeeIdCounter
                : employeeIdCounter // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DepartmentModelImplCopyWith<$Res>
    implements $DepartmentModelCopyWith<$Res> {
  factory _$$DepartmentModelImplCopyWith(
    _$DepartmentModelImpl value,
    $Res Function(_$DepartmentModelImpl) then,
  ) = __$$DepartmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String code,
    String description,
    @JsonKey(name: 'head_id') String? headId,
    @JsonKey(name: 'head_name') String? headName,
    @JsonKey(name: 'employee_count') int employeeCount,
    @JsonKey(name: 'employee_id_counter') int employeeIdCounter,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DepartmentModelImplCopyWithImpl<$Res>
    extends _$DepartmentModelCopyWithImpl<$Res, _$DepartmentModelImpl>
    implements _$$DepartmentModelImplCopyWith<$Res> {
  __$$DepartmentModelImplCopyWithImpl(
    _$DepartmentModelImpl _value,
    $Res Function(_$DepartmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? headId = freezed,
    Object? headName = freezed,
    Object? employeeCount = null,
    Object? employeeIdCounter = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DepartmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        headId: freezed == headId
            ? _value.headId
            : headId // ignore: cast_nullable_to_non_nullable
                  as String?,
        headName: freezed == headName
            ? _value.headName
            : headName // ignore: cast_nullable_to_non_nullable
                  as String?,
        employeeCount: null == employeeCount
            ? _value.employeeCount
            : employeeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        employeeIdCounter: null == employeeIdCounter
            ? _value.employeeIdCounter
            : employeeIdCounter // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DepartmentModelImpl implements _DepartmentModel {
  const _$DepartmentModelImpl({
    required this.id,
    required this.name,
    this.code = '',
    this.description = '',
    @JsonKey(name: 'head_id') this.headId,
    @JsonKey(name: 'head_name') this.headName,
    @JsonKey(name: 'employee_count') this.employeeCount = 0,
    @JsonKey(name: 'employee_id_counter') this.employeeIdCounter = 0,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$DepartmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String code;
  // Made optional with default
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'head_id')
  final String? headId;
  @override
  @JsonKey(name: 'head_name')
  final String? headName;
  @override
  @JsonKey(name: 'employee_count')
  final int employeeCount;
  @override
  @JsonKey(name: 'employee_id_counter')
  final int employeeIdCounter;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DepartmentModel(id: $id, name: $name, code: $code, description: $description, headId: $headId, headName: $headName, employeeCount: $employeeCount, employeeIdCounter: $employeeIdCounter, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepartmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.headId, headId) || other.headId == headId) &&
            (identical(other.headName, headName) ||
                other.headName == headName) &&
            (identical(other.employeeCount, employeeCount) ||
                other.employeeCount == employeeCount) &&
            (identical(other.employeeIdCounter, employeeIdCounter) ||
                other.employeeIdCounter == employeeIdCounter) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    code,
    description,
    headId,
    headName,
    employeeCount,
    employeeIdCounter,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DepartmentModelImplCopyWith<_$DepartmentModelImpl> get copyWith =>
      __$$DepartmentModelImplCopyWithImpl<_$DepartmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DepartmentModelImplToJson(this);
  }
}

abstract class _DepartmentModel implements DepartmentModel {
  const factory _DepartmentModel({
    required final String id,
    required final String name,
    final String code,
    final String description,
    @JsonKey(name: 'head_id') final String? headId,
    @JsonKey(name: 'head_name') final String? headName,
    @JsonKey(name: 'employee_count') final int employeeCount,
    @JsonKey(name: 'employee_id_counter') final int employeeIdCounter,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$DepartmentModelImpl;

  factory _DepartmentModel.fromJson(Map<String, dynamic> json) =
      _$DepartmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code; // Made optional with default
  @override
  String get description;
  @override
  @JsonKey(name: 'head_id')
  String? get headId;
  @override
  @JsonKey(name: 'head_name')
  String? get headName;
  @override
  @JsonKey(name: 'employee_count')
  int get employeeCount;
  @override
  @JsonKey(name: 'employee_id_counter')
  int get employeeIdCounter;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepartmentModelImplCopyWith<_$DepartmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
