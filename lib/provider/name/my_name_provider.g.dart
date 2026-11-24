// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_name_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myNameHash() => r'c3f1f8cc1e3ea7c35844250c386edc86d830b8af';

/// The name registered for this device. An empty name means "not registered".
///
/// Copied from [MyName].
@ProviderFor(MyName)
final myNameProvider = AsyncNotifierProvider<MyName, UserName>.internal(
  MyName.new,
  name: r'myNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyName = AsyncNotifier<UserName>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
