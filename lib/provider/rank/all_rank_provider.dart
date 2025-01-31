import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank/model/rank.dart';

part 'all_rank_provider.g.dart';

@Riverpod(keepAlive: true)
class AllRank extends _$AllRank {
  @override
  Future<List<Rank>> build() async {
    return getRankList();
  }

  Future<void> insertRecord(Rank rank) async {
    final docRef = FirebaseFirestore.instance.collection("ranks");
    await docRef.add(rank.toFirestore());
    state = AsyncData(await getRankList());
  }

  static Future<List<Rank>> getRankList() async {
    final docRef = FirebaseFirestore.instance
        .collection("ranks")
        .withConverter(
            fromFirestore: Rank.fromFirestore,
            toFirestore: (Rank rank, options) => rank.toFirestore())
        .orderBy("survivedTimeInMilliseconds", descending: true);
    final data = await docRef.get();
    final List<Rank> rankList = [];
    for (var element in data.docs) {
      rankList.add(element.data());
    }
    return rankList;
  }
}
