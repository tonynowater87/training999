import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank/model/rank.dart';

part 'all_rank_provider.g.dart';

@Riverpod(keepAlive: true)
class AllRank extends _$AllRank {
  @override
  Future<List<Rank>> build() async {
    // TODO listen from firestore
    return await generateRandomRankList();
  }

  void insertRecord(Rank rank) {
    // TODO insert record to firestore
    List<Rank> allRanks = [...state.value!, rank].toList();
    allRanks.sort((a, b) =>
        b.survivedTimeInMilliseconds.compareTo(a.survivedTimeInMilliseconds));
    state = AsyncData(allRanks);
  }

  static Future<List<Rank>> generateRandomRankList() async {
    return Future.delayed(const Duration(seconds: 1), () {
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
    });
  }
}
