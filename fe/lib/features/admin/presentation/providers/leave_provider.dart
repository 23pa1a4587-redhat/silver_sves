import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/leave_application_model.dart';
import '../../data/repositories/leave_repository.dart';

part 'leave_provider.g.dart';

/// Provider for LeaveRepository instance
@riverpod
LeaveRepository leaveRepository(LeaveRepositoryRef ref) {
  return LeaveRepository();
}

/// Provider for department leave requests (for dept head)
final departmentLeaveRequestsProvider =
    StreamProvider.family<List<LeaveApplication>, String>((ref, departmentId) {
      final repository = ref.watch(leaveRepositoryProvider);
      return repository.getDepartmentLeaveRequests(departmentId);
    });
