// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_leave_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeLeaveBalanceHash() =>
    r'18f82ad4269390fc6bfb4875074270b0480203ca';

/// Provider for employee's leave balance (calculates from applications)
///
/// Copied from [employeeLeaveBalance].
@ProviderFor(employeeLeaveBalance)
final employeeLeaveBalanceProvider =
    AutoDisposeFutureProvider<EmployeeLeaveBalance>.internal(
      employeeLeaveBalance,
      name: r'employeeLeaveBalanceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$employeeLeaveBalanceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeLeaveBalanceRef =
    AutoDisposeFutureProviderRef<EmployeeLeaveBalance>;
String _$employeeLeaveRequestsHash() =>
    r'bf0da1716966065dd0f5935ecdab34134d70a9b2';

/// Provider for employee's leave requests
///
/// Copied from [employeeLeaveRequests].
@ProviderFor(employeeLeaveRequests)
final employeeLeaveRequestsProvider =
    AutoDisposeFutureProvider<List<LeaveApplication>>.internal(
      employeeLeaveRequests,
      name: r'employeeLeaveRequestsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$employeeLeaveRequestsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeLeaveRequestsRef =
    AutoDisposeFutureProviderRef<List<LeaveApplication>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
