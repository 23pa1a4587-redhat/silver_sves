import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../admin/data/repositories/firebase_user_repository.dart';
import '../../../admin/presentation/providers/user_provider.dart';
import '../../../auth/data/models/user_model.dart';

part 'dept_users_provider.g.dart';

/// Provider for department employees
@riverpod
Future<List<UserModel>> deptEmployees(
  DeptEmployeesRef ref,
  String departmentId,
) async {
  final repository = ref.watch(userRepositoryProvider);

  // Get all users in the department
  return repository.getUsersByDepartment(departmentId, activeOnly: false);
}
