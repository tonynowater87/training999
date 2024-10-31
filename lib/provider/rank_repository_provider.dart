import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank.dart';

part 'rank_repository_provider.g.dart';

class RankRepository {
  final List<Rank> _rankList = generateRandomRankList();
  Rank? _latestRank;

  List<Rank> get rankList => _rankList;

  Rank? get getLatestRank => _latestRank;

  insertRank(Rank rank) {
    _latestRank = rank;
    _rankList.add(rank);
    _rankList.sort((a, b) =>
        b.survivedTimeInMilliseconds.compareTo(a.survivedTimeInMilliseconds));
  }

  int getIndexById(int id) {
    return _rankList.indexWhere((element) => element.id == id);
  }

  static List<Rank> generateRandomRankList() {
    final List<Rank> rankList = [];
    for (int i = 0; i < 10; i++) {
      rankList.add(Rank(
        id: i,
        name: 'Player $i',
        survivedTimeInMilliseconds: i * 1000 + 5000,
        brilliantlyDodgedTheBullets: i * 10,
        createdAt: DateTime.now(),
        platform: 'Android',
      ));
    }
    rankList.sort((a, b) =>
        b.survivedTimeInMilliseconds.compareTo(a.survivedTimeInMilliseconds));
    return rankList;
  }
}

@Riverpod(keepAlive: true)
RankRepository rankRepository(Ref ref) {
  return RankRepository();
}
