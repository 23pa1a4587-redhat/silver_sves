/// Leave application model for managing leave requests
class LeaveApplication {
  final String id;
  final String userId;
  final String userName;
  final String? departmentId;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final String? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LeaveApplication({
    required this.id,
    required this.userId,
    required this.userName,
    this.departmentId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON
  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      departmentId: json['departmentId'] as String?,
      type: LeaveType.fromJson(json['type'] as String),
      startDate: (json['startDate'] as dynamic).toDate(),
      endDate: (json['endDate'] as dynamic).toDate(),
      reason: json['reason'] as String,
      status: LeaveStatus.fromJson(json['status'] as String),
      approvedBy: json['approvedBy'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as dynamic).toDate()
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'departmentId': departmentId,
      'type': type.toJson(),
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status.toJson(),
      'approvedBy': approvedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create a copy with updated fields
  LeaveApplication copyWith({
    String? id,
    String? userId,
    String? userName,
    String? departmentId,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    LeaveStatus? status,
    String? approvedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeaveApplication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      departmentId: departmentId ?? this.departmentId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Leave types enum
enum LeaveType {
  annual,
  sick,
  casual,
  emergency;

  String toJson() {
    switch (this) {
      case LeaveType.annual:
        return 'annual';
      case LeaveType.sick:
        return 'sick';
      case LeaveType.casual:
        return 'casual';
      case LeaveType.emergency:
        return 'emergency';
    }
  }

  static LeaveType fromJson(String value) {
    switch (value) {
      case 'annual':
        return LeaveType.annual;
      case 'sick':
        return LeaveType.sick;
      case 'casual':
        return LeaveType.casual;
      case 'emergency':
        return LeaveType.emergency;
      default:
        return LeaveType.annual;
    }
  }
}

/// Leave status enum
enum LeaveStatus {
  pending,
  approved,
  rejected;

  String toJson() {
    switch (this) {
      case LeaveStatus.pending:
        return 'pending';
      case LeaveStatus.approved:
        return 'approved';
      case LeaveStatus.rejected:
        return 'rejected';
    }
  }

  static LeaveStatus fromJson(String value) {
    switch (value) {
      case 'pending':
        return LeaveStatus.pending;
      case 'approved':
        return LeaveStatus.approved;
      case 'rejected':
        return LeaveStatus.rejected;
      default:
        return LeaveStatus.pending;
    }
  }
}
