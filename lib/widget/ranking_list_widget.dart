import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/provider/rank/model/rank.dart';
import 'package:training999/provider/rank/my_latest_rank_provider.dart';
import 'package:training999/util/time_utils.dart';

class RankingListWidget extends ConsumerStatefulWidget {
  const RankingListWidget({super.key, required this.voidCallback});

  final VoidCallback voidCallback;

  @override
  ConsumerState<RankingListWidget> createState() => _RankingListWidgetState();
}

class _RankingListWidgetState extends ConsumerState<RankingListWidget> {
  static const double _itemExtent = 56;
  static const TextStyle _textStyle =
      TextStyle(fontSize: 24, color: Colors.white);

  final ScrollController _scrollController = ScrollController();
  int? _scrolledToIndex;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allRanks = ref.watch(allRankProvider);
    final myLatestRank = ref.watch(myLatestRankProvider);

    return allRanks.when(
      data: (rankList) {
        final latestRankIndex =
            rankList.indexWhere((element) => element.id == myLatestRank?.id);
        _scrollToCenter(latestRankIndex);
        final showLatestOutsideList =
            myLatestRank != null && latestRankIndex == -1;

        return Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withValues(alpha: 0.5),
          child: GestureDetector(
            onTap: widget.voidCallback,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('排行榜', style: _textStyle),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverFixedExtentList.builder(
                        itemExtent: _itemExtent,
                        itemCount: rankList.length,
                        itemBuilder: (context, index) => _RankTile(
                          title: '排名 ${index + 1}',
                          rank: rankList[index],
                          isHighlighted: latestRankIndex == index,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showLatestOutsideList)
                  SizedBox(
                    height: _itemExtent,
                    child: _RankTile(
                      title: '本次',
                      rank: myLatestRank,
                      isHighlighted: true,
                    ),
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

  /// Scrolls the item at [index] to the vertical center, once per index.
  void _scrollToCenter(int index) {
    if (index == -1 || index == _scrolledToIndex) {
      return;
    }
    _scrolledToIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final position = _scrollController.position;
      final offset =
          index * _itemExtent - (position.viewportDimension - _itemExtent) / 2;
      _scrollController.animateTo(
        offset.clamp(0.0, position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.title,
    required this.rank,
    required this.isHighlighted,
  });

  final String title;
  final Rank rank;
  final bool isHighlighted;

  static const TextStyle _textStyle =
      TextStyle(fontSize: 24, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isHighlighted ? Colors.white : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(title, style: _textStyle),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              rank.name,
              style: _textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '存活時間 ${formatMilliseconds(rank.survivedTimeInMilliseconds)} 秒',
            style: _textStyle,
          ),
          const SizedBox(width: 16),
          Text('絕妙度 ${rank.brilliantlyDodgedTheBullets}', style: _textStyle),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
