import 'package:cloud_firestore/cloud_firestore.dart';

/// Department entity/model
class DepartmentModel {
  final String id; // Firebase UUID (document ID)
  final String uniqueId; // 8-char shortened ID
  final String name;
  final String description;
  final String? headId;
  final String? headName;
  final int employeeCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DepartmentModel({
    required this.id,
    this.uniqueId = '',
    required this.name,
    this.description = '',
    this.headId,
    this.headName,
    this.employeeCount = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Create DepartmentModel from Firestore document
  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as String,
      uniqueId: json['unique_id'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      headId: json['head_id'] as String?,
      headName: json['head_name'] as String?,
      employeeCount: json['employee_count'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _timestampToDateTime(json['created_at']),
      updatedAt: _timestampToDateTime(json['updated_at']),
    );
  }

  /// Convert DepartmentModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'description': description,
      if (headId != null) 'head_id': headId,
      if (headName != null) 'head_name': headName,
      'employee_count': employeeCount,
      'isActive': isActive,
      if (createdAt != null) 'created_at': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updated_at': Timestamp.fromDate(updatedAt!),
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
  DepartmentModel copyWith({
    String? id,
    String? uniqueId,
    String? name,
    String? description,
    String? headId,
    String? headName,
    int? employeeCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      uniqueId: uniqueId ?? this.uniqueId,
      name: name ?? this.name,
      description: description ?? this.description,
      headId: headId ?? this.headId,
      headName: headName ?? this.headName,
      employeeCount: employeeCount ?? this.employeeCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DepartmentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DepartmentModel(id: $id, name: $name, employeeCount: $employeeCount)';
  }
}

/// Extension for DepartmentModel
extension DepartmentModelX on DepartmentModel {
  /// Check if department has a head assigned
  bool get hasHead => headId != null && headId!.isNotEmpty;

  /// Get uniqueId - returns stored value or auto-generates with dept_ prefix
  String get getUniqueId {
    if (uniqueId.isNotEmpty) return uniqueId;
    // Generate from Firebase ID if uniqueId is empty (for old data)
    final cleanId = id.replaceAll('-', '');
    if (cleanId.length >= 4) {
      return 'dept_${cleanId.substring(0, 4).toLowerCase()}';
    }
    // If ID is too short, pad with zeros
    return 'dept_${cleanId.toLowerCase().padRight(4, '0')}';
  }

  /// Get display name with employee count
  String get displayNameWithCount => '$name ($employeeCount employees)';
}
