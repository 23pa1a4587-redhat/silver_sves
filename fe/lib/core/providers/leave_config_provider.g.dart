// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaveConfigHash() => r'05676bcecffa7230c05260ca933c3678ecc1dd5d';

/// Provider for streaming leave configuration (real-time updates)
///
/// Copied from [leaveConfig].
@ProviderFor(leaveConfig)
final leaveConfigProvider =
    AutoDisposeStreamProvider<LeaveConfigModel>.internal(
      leaveConfig,
      name: r'leaveConfigProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$leaveConfigHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaveConfigRef = AutoDisposeStreamProviderRef<LeaveConfigModel>;
String _$leaveConfigFutureHash() => r'496a6438175e3c5b2bc5f9e713cab86197091334';

/// Provider for one-time fetch of leave configuration
///
/// Copied from [leaveConfigFuture].
@ProviderFor(leaveConfigFuture)
final leaveConfigFutureProvider =
    AutoDisposeFutureProvider<LeaveConfigModel>.internal(
      leaveConfigFuture,
      name: r'leaveConfigFutureProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$leaveConfigFutureHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaveConfigFutureRef = AutoDisposeFutureProviderRef<LeaveConfigModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
