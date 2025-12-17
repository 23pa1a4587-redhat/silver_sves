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
      throw _privateConstructorUsedError; // 4-letter code for employee ID generation (e.g., ACAD, ENG)
  String? get description => throw _privateConstructorUsedError;
  String? get headId =>
      throw _privateConstructorUsedError; // Department head user ID
  String? get headName =>
      throw _privateConstructorUsedError; // Department head name (denormalized)
  int get employeeCount => throw _privateConstructorUsedError;
  int get employeeIdCounter =>
      throw _privateConstructorUsedError; // Auto-increment counter for employee IDs
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
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
    String? description,
    String? headId,
    String? headName,
    int employeeCount,
    int employeeIdCounter,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? description = freezed,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String? description,
    String? headId,
    String? headName,
    int employeeCount,
    int employeeIdCounter,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? description = freezed,
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
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    required this.code,
    this.description,
    this.headId,
    this.headName,
    this.employeeCount = 0,
    this.employeeIdCounter = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$DepartmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepartmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  // 4-letter code for employee ID generation (e.g., ACAD, ENG)
  @override
  final String? description;
  @override
  final String? headId;
  // Department head user ID
  @override
  final String? headName;
  // Department head name (denormalized)
  @override
  @JsonKey()
  final int employeeCount;
  @override
  @JsonKey()
  final int employeeIdCounter;
  // Auto-increment counter for employee IDs
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
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
    required final String code,
    final String? description,
    final String? headId,
    final String? headName,
    final int employeeCount,
    final int employeeIdCounter,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$DepartmentModelImpl;

  factory _DepartmentModel.fromJson(Map<String, dynamic> json) =
      _$DepartmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code; // 4-letter code for employee ID generation (e.g., ACAD, ENG)
  @override
  String? get description;
  @override
  String? get headId; // Department head user ID
  @override
  String? get headName; // Department head name (denormalized)
  @override
  int get employeeCount;
  @override
  int get employeeIdCounter; // Auto-increment counter for employee IDs
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of DepartmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DepartmentModelImplCopyWith<_$DepartmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
