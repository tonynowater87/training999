import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_name.freezed.dart';

@freezed
class UserName with _$UserName {
  const factory UserName({
    required String uuid,
    required String name,
  }) = _UserName;
}