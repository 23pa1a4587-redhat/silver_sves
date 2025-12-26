import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/leave_config_model.dart';
import '../data/repositories/leave_config_repository.dart';

part 'leave_config_provider.g.dart';

/// Provider for LeaveConfigRepository
final leaveConfigRepositoryProvider = Provider<LeaveConfigRepository>((ref) {
  return LeaveConfigRepository();
});

/// Provider for streaming leave configuration (real-time updates)
@riverpod
Stream<LeaveConfigModel> leaveConfig(LeaveConfigRef ref) {
  final repository = ref.watch(leaveConfigRepositoryProvider);
  return repository.streamLeaveConfig();
}

/// Provider for one-time fetch of leave configuration
@riverpod
Future<LeaveConfigModel> leaveConfigFuture(LeaveConfigFutureRef ref) async {
  final repository = ref.watch(leaveConfigRepositoryProvider);
  return repository.getLeaveConfig();
}
