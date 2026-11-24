import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank/model/rank.dart';

part 'all_rank_provider.g.dart';

/// The top [rankLimit] records, best first.
@Riverpod(keepAlive: true)
class AllRank extends _$AllRank {
  static const int rankLimit = 100;

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
    final query = FirebaseFirestore.instance
        .collection("ranks")
        .withConverter(
            fromFirestore: Rank.fromFirestore,
            toFirestore: (Rank rank, options) => rank.toFirestore())
        .orderBy("survivedTimeInMilliseconds", descending: true)
        .limit(rankLimit);
    final data = await query.get();
    return data.docs.map((doc) => doc.data()).toList();
  }
}
