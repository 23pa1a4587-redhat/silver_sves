import '../../data/models/department_model.dart';

/// Department repository interface (Domain layer)
abstract class DepartmentRepository {
  /// Create a new department
  Future<DepartmentModel> createDepartment(DepartmentModel department);

  /// Get all departments (stream for real-time updates)
  Stream<List<DepartmentModel>> getDepartments({bool activeOnly = false});

  /// Get a single department by ID
  Future<DepartmentModel?> getDepartmentById(String id);

  /// Update department details
  Future<void> updateDepartment(DepartmentModel department);

  /// Assign a department head
  Future<void> assignDepartmentHead(
    String deptId,
    String userId,
    String userName,
  );

  /// Remove department head
  Future<void> removeDepartmentHead(String deptId);

  /// Generate next employee ID for this department
  Future<String> generateEmployeeId(String deptId);

  /// Update employee count
  Future<void> updateEmployeeCount(String deptId, int delta);

  /// Deactivate department (soft delete)
  Future<void> deactivateDepartment(String id);

  /// Activate department
  Future<void> activateDepartment(String id);

  /// Check if department code is unique
  Future<bool> isDepartmentCodeUnique(String code, {String? excludeId});

  /// Get department count
  Future<int> getDepartmentCount({bool activeOnly = true});
}
