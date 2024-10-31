import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank.dart';

part 'rank_repository.g.dart';

class RankRepository {
  final List<Rank> _rankList = [];

  List<Rank> get rankList => _rankList;

  insertRank(Rank rank) {
    _rankList.add(rank);
    _rankList.sort((a, b) =>
        b.survivedTimeInMilliseconds.compareTo(a.survivedTimeInMilliseconds));
  }
}

@Riverpod(keepAlive: true)
RankRepository rankRepository(Ref ref) {
  return RankRepository();
}
