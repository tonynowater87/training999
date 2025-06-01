import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/provider/rank/my_latest_rank_provider.dart';
import 'package:training999/util/time_utils.dart';

class RankingListWidget extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();
  VoidCallback voidCallback;

  RankingListWidget({super.key, required this.voidCallback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenHeight = MediaQuery.of(context).size.height;
    final allRanks = ref.watch(allRankProvider);
    final myLatestRank = ref.watch(myLatestRankProvider);

    return allRanks.when(
      data: (rankList) {
        int latestRankIndex =
        rankList.indexWhere((element) => element.id == myLatestRank?.id);

        scrollTo(latestRankIndex, screenHeight);
        return Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: screenHeight,
          color: Colors.black.withOpacity(0.5),
          child: GestureDetector(
            onTap: () {
              voidCallback.call();
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: Text('排行榜')),
                SliverList.builder(
                  itemCount: rankList.length,
                  itemBuilder: (context, index) {
                    final rank = rankList[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: latestRankIndex == index
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                      child: ListTile(titleAlignment: ListTileTitleAlignment.threeLine,
                        title: Row(
                          children: [
                            Text(
                              '排名 ${index + 1}',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            SizedBox(width: 16,),
                            Text(
                              rank.name,
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "存活時間 ${formatMilliseconds(rank.survivedTimeInMilliseconds)}",
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                        SizedBox(width: 16,),
                            Text(
                              "絕妙度 ${rank.brilliantlyDodgedTheBullets}%",
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  void scrollTo(int rank, double screenHeight) {
    var itemHeight = 72.0 + 2.0 /* border */;

    if (rank == -1) {
      return;
    }

    var center = screenHeight / 2.0;
    var halfHeightOfItem = itemHeight / 2.0;
    var scrollOffset = rank * itemHeight -
        (center - halfHeightOfItem); // move the item to the center of screen

    if (scrollOffset < 0) {
      return;
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     scrollOffset,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }
}