import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/models/leave_config_model.dart';
import '../../../../core/providers/leave_config_provider.dart';
import '../../../admin/data/models/leave_application_model.dart';
import '../../../admin/presentation/providers/leave_provider.dart';
import '../../data/models/leave_balance_model.dart';

part 'user_leave_provider.g.dart';

/// Provider for a specific user's leave applications
@riverpod
Stream<List<LeaveApplication>> userLeaveApplications(
  UserLeaveApplicationsRef ref,
  String userId,
) {
  final repository = ref.watch(leaveRepositoryProvider);
  return repository.getUserLeaveApplications(userId);
}

/// Provider for calculating user's leave balance (uses Firestore config)
@riverpod
Future<Map<LeaveType, LeaveBalance>> userLeaveBalance(
  UserLeaveBalanceRef ref,
  String userId,
) async {
  // Watch the leave applications stream
  final applicationsAsync = await ref.watch(
    userLeaveApplicationsProvider(userId).future,
  );

  // Get leave config from Firestore (with fallback to defaults)
  LeaveConfigModel config;
  try {
    config = await ref.watch(leaveConfigFutureProvider.future);
  } catch (_) {
    config = LeaveConfigModel.defaults();
  }

  // Calculate balance from applications with Firestore config
  return calculateLeaveBalance(
    applicationsAsync,
    casualAllocation: config.casualLeave,
    sickAllocation: config.sickLeave,
    earnedAllocation: config.earnedLeave,
    emergencyAllocation: config.emergencyLeave,
  );
}
