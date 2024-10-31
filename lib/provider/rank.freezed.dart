// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Rank {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get survivedTimeInMilliseconds => throw _privateConstructorUsedError;
  int get brilliantlyDodgedTheBullets => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RankCopyWith<Rank> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankCopyWith<$Res> {
  factory $RankCopyWith(Rank value, $Res Function(Rank) then) =
      _$RankCopyWithImpl<$Res, Rank>;
  @useResult
  $Res call(
      {int id,
      String name,
      int survivedTimeInMilliseconds,
      int brilliantlyDodgedTheBullets,
      String platform});
}

/// @nodoc
class _$RankCopyWithImpl<$Res, $Val extends Rank>
    implements $RankCopyWith<$Res> {
  _$RankCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? survivedTimeInMilliseconds = null,
    Object? brilliantlyDodgedTheBullets = null,
    Object? platform = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      survivedTimeInMilliseconds: null == survivedTimeInMilliseconds
          ? _value.survivedTimeInMilliseconds
          : survivedTimeInMilliseconds // ignore: cast_nullable_to_non_nullable
              as int,
      brilliantlyDodgedTheBullets: null == brilliantlyDodgedTheBullets
          ? _value.brilliantlyDodgedTheBullets
          : brilliantlyDodgedTheBullets // ignore: cast_nullable_to_non_nullable
              as int,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RankImplCopyWith<$Res> implements $RankCopyWith<$Res> {
  factory _$$RankImplCopyWith(
          _$RankImpl value, $Res Function(_$RankImpl) then) =
      __$$RankImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int survivedTimeInMilliseconds,
      int brilliantlyDodgedTheBullets,
      String platform});
}

/// @nodoc
class __$$RankImplCopyWithImpl<$Res>
    extends _$RankCopyWithImpl<$Res, _$RankImpl>
    implements _$$RankImplCopyWith<$Res> {
  __$$RankImplCopyWithImpl(_$RankImpl _value, $Res Function(_$RankImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? survivedTimeInMilliseconds = null,
    Object? brilliantlyDodgedTheBullets = null,
    Object? platform = null,
  }) {
    return _then(_$RankImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      survivedTimeInMilliseconds: null == survivedTimeInMilliseconds
          ? _value.survivedTimeInMilliseconds
          : survivedTimeInMilliseconds // ignore: cast_nullable_to_non_nullable
              as int,
      brilliantlyDodgedTheBullets: null == brilliantlyDodgedTheBullets
          ? _value.brilliantlyDodgedTheBullets
          : brilliantlyDodgedTheBullets // ignore: cast_nullable_to_non_nullable
              as int,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RankImpl implements _Rank {
  const _$RankImpl(
      {required this.id,
      required this.name,
      required this.survivedTimeInMilliseconds,
      required this.brilliantlyDodgedTheBullets,
      required this.platform});

  @override
  final int id;
  @override
  final String name;
  @override
  final int survivedTimeInMilliseconds;
  @override
  final int brilliantlyDodgedTheBullets;
  @override
  final String platform;

  @override
  String toString() {
    return 'Rank(id: $id, name: $name, survivedTimeInMilliseconds: $survivedTimeInMilliseconds, brilliantlyDodgedTheBullets: $brilliantlyDodgedTheBullets, platform: $platform)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.survivedTimeInMilliseconds,
                    survivedTimeInMilliseconds) ||
                other.survivedTimeInMilliseconds ==
                    survivedTimeInMilliseconds) &&
            (identical(other.brilliantlyDodgedTheBullets,
                    brilliantlyDodgedTheBullets) ||
                other.brilliantlyDodgedTheBullets ==
                    brilliantlyDodgedTheBullets) &&
            (identical(other.platform, platform) ||
                other.platform == platform));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name,
      survivedTimeInMilliseconds, brilliantlyDodgedTheBullets, platform);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RankImplCopyWith<_$RankImpl> get copyWith =>
      __$$RankImplCopyWithImpl<_$RankImpl>(this, _$identity);
}

abstract class _Rank implements Rank {
  const factory _Rank(
      {required final int id,
      required final String name,
      required final int survivedTimeInMilliseconds,
      required final int brilliantlyDodgedTheBullets,
      required final String platform}) = _$RankImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  int get survivedTimeInMilliseconds;
  @override
  int get brilliantlyDodgedTheBullets;
  @override
  String get platform;
  @override
  @JsonKey(ignore: true)
  _$$RankImplCopyWith<_$RankImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
