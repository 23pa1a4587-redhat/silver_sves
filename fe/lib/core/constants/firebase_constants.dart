/// Firebase collection and field name constants
class FirebaseConstants {
  FirebaseConstants._(); // Private constructor

  // Collection Names
  // Auth lookup collection (lightweight: phone -> role -> roleDocId)
  static const String usersCollection = 'users';

  // Role-specific collections (full user profiles)
  static const String superAdminsCollection = 'super_admins';
  static const String departmentHeadsCollection = 'department_heads';
  static const String employeesCollection = 'employees';

  static const String departmentsCollection = 'departments';
  static const String leavesCollection = 'leaves';
  static const String leaveReplacementsCollection = 'leave_replacements';

  // User ID prefix (all users use 'emp_' regardless of role)
  static const String employeePrefix = 'emp_';

  // User Fields
  static const String userIdField = 'id';
  static const String userNameField = 'name';
  static const String phoneField = 'phone'; // Shorter alias for queries
  static const String userPhoneField = 'phone';
  static const String userRoleField = 'role';
  static const String userDepartmentIdField = 'departmentId';
  static const String lastUsedField = 'lastUsed'; // Last activity timestamp
  static const String userCreatedAtField = 'createdAt';
  static const String userUpdatedAtField = 'updatedAt';
  static const String userIsActiveField = 'isActive';

  // Department Fields
  static const String deptIdField = 'id';
  static const String deptNameField = 'name';
  static const String deptHeadIdField = 'headId';
  static const String deptEmployeeCountField = 'employeeCount';
  static const String deptCreatedAtField = 'createdAt';

  // Leave Fields
  static const String leaveIdField = 'id';
  static const String leaveUserIdField = 'userId';
  static const String leaveTypeField = 'type';
  static const String leaveReasonField = 'reason';
  static const String leaveStartDateField = 'startDate';
  static const String leaveEndDateField = 'endDate';
  static const String leaveStatusField = 'status';
  static const String leaveApprovedByField = 'approvedBy';
  static const String leaveReplacementIdField = 'replacementId';
  static const String leaveCreatedAtField = 'createdAt';
  static const String leaveUpdatedAtField = 'updatedAt';

  // User Roles
  static const String roleSuperAdmin = 'super_admin';
  static const String roleDepartmentHead = 'department_head';
  static const String roleEmployee = 'employee';

  // Leave Status
  static const String leaveStatusPending = 'pending';
  static const String leaveStatusApproved = 'approved';
  static const String leaveStatusRejected = 'rejected';

  // Leave Types
  static const String leaveTypeSick = 'sick';
  static const String leaveTypeCasual = 'casual';
  static const String leaveTypeEarned = 'earned';
  static const String leaveTypeEmergency = 'emergency';
}
