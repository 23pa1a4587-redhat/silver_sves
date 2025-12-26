import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for leave configuration stored in Firestore
class LeaveConfigModel {
  final int casualLeave;
  final int sickLeave;
  final int earnedLeave;
  final int emergencyLeave;
  final DateTime? updatedAt;
  final String? updatedBy;

  const LeaveConfigModel({
    required this.casualLeave,
    required this.sickLeave,
    required this.earnedLeave,
    required this.emergencyLeave,
    this.updatedAt,
    this.updatedBy,
  });

  /// Default values if no config exists in Firestore
  factory LeaveConfigModel.defaults() {
    return const LeaveConfigModel(
      casualLeave: 12,
      sickLeave: 6,
      earnedLeave: 15,
      emergencyLeave: 7,
    );
  }

  /// Create from Firestore document
  factory LeaveConfigModel.fromJson(Map<String, dynamic> json) {
    return LeaveConfigModel(
      casualLeave: json['casualLeave'] as int? ?? 12,
      sickLeave: json['sickLeave'] as int? ?? 6,
      earnedLeave: json['earnedLeave'] as int? ?? 15,
      emergencyLeave: json['emergencyLeave'] as int? ?? 7,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      updatedBy: json['updatedBy'] as String?,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'casualLeave': casualLeave,
      'sickLeave': sickLeave,
      'earnedLeave': earnedLeave,
      'emergencyLeave': emergencyLeave,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    };
  }

  /// Total leave allocation
  int get totalAllocation =>
      casualLeave + sickLeave + earnedLeave + emergencyLeave;

  /// Create a copy with updated values
  LeaveConfigModel copyWith({
    int? casualLeave,
    int? sickLeave,
    int? earnedLeave,
    int? emergencyLeave,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return LeaveConfigModel(
      casualLeave: casualLeave ?? this.casualLeave,
      sickLeave: sickLeave ?? this.sickLeave,
      earnedLeave: earnedLeave ?? this.earnedLeave,
      emergencyLeave: emergencyLeave ?? this.emergencyLeave,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
