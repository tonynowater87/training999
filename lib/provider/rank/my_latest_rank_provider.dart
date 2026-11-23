import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank/model/rank.dart';

part 'my_latest_rank_provider.g.dart';

/// The record of the last finished run on this device, or null.
@Riverpod(keepAlive: true)
class MyLatestRank extends _$MyLatestRank {
  @override
  Rank? build() => null;

  void set(Rank rank) {
    state = rank;
  }
}
