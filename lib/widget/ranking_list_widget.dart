import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/provider/rank/my_latest_rank_provider.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/util/time_utils.dart';

class RankingListWidget extends ConsumerWidget {
  final ScrollController _scrollController = ScrollController();

  RankingListWidget({super.key});

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
            width: MediaQuery.of(context).size.width / 3,
            height: screenHeight,
            color: Colors.black.withOpacity(0.5),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: rankList.length,
              itemBuilder: (context, index) {
                final rank = rankList[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: latestRankIndex == index
                            ? Colors.white
                            : Colors.transparent),
                  ),
                  child: ListTile(
                    title: Text('排名 ${index + 1}',
                        style: TextStyle(color: Colors.white)),
                    subtitle:
                        Text(rank.name, style: TextStyle(color: Colors.white)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "存活時間 ${formatMilliseconds(rank.survivedTimeInMilliseconds)}",
                            style: TextStyle(color: Colors.white)),
                        Text("絕妙度 ${rank.brilliantlyDodgedTheBullets}%",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')));
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}
