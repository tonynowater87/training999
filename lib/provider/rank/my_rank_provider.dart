import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:training999/provider/name/my_name_provider.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/provider/rank/model/rank.dart';

part 'my_rank_provider.g.dart';

@Riverpod(keepAlive: true)
class MyRank extends _$MyRank {
  @override
  Future<List<Rank>> build() async {
    final myName = (await ref.watch(myNameProvider.future)).name;
    final allRanks = await ref.watch(allRankProvider.future);
    final myRanks = allRanks.where((rank) => rank.name == myName).toList();
    return myRanks;
  }
}
