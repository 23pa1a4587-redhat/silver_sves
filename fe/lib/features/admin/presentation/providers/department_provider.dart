import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/department_model.dart';
import '../../data/repositories/firebase_department_repository.dart';
import '../../domain/repositories/department_repository.dart';

part 'department_provider.g.dart';

/// Provider for DepartmentRepository
@riverpod
DepartmentRepository departmentRepository(DepartmentRepositoryRef ref) {
  return FirebaseDepartmentRepository(firestore: FirebaseFirestore.instance);
}

/// Provider for all departments stream
@riverpod
Stream<List<DepartmentModel>> departments(
  DepartmentsRef ref, {
  bool activeOnly = true,
}) {
  final repository = ref.watch(departmentRepositoryProvider);
  return repository.getDepartments(activeOnly: activeOnly);
}

/// Provider for active departments only
@riverpod
Stream<List<DepartmentModel>> activeDepartments(ActiveDepartmentsRef ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  // TEMP: Fetch ALL departments for debugging
  return repository.getDepartments(activeOnly: false);
}

/// Provider for a single department
@riverpod
Future<DepartmentModel?> department(DepartmentRef ref, String id) async {
  final repository = ref.watch(departmentRepositoryProvider);
  return repository.getDepartmentById(id);
}

/// Provider for department count
@riverpod
Future<int> departmentCount(
  DepartmentCountRef ref, {
  bool activeOnly = true,
}) async {
  final repository = ref.watch(departmentRepositoryProvider);
  return repository.getDepartmentCount(activeOnly: activeOnly);
}
