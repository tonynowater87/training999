import 'package:freezed_annotation/freezed_annotation.dart';

part 'rank.freezed.dart';

@freezed
class Rank with _$Rank {
  const factory Rank({
    required int id,
    required String name,
    required int survivedTimeInMilliseconds,
    required int brilliantlyDodgedTheBullets,
    required DateTime createdAt,
    required String platform,
  }) = _Rank;
}
