import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/rank/model/rank.dart';
import 'package:training999/provider/rank/my_rank_provider.dart';

part 'my_latest_rank_provider.g.dart';

@riverpod
Rank? myLatestRank(Ref ref) {
  final myRanks = ref.watch(myRankProvider);
  if (myRanks.isLoading || myRanks.value?.isEmpty == true) {
    return null;
  }
  myRanks.value!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return myRanks.value!.first;
}
