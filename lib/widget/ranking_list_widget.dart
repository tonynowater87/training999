import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/art/ui_theme.dart';
import 'package:training999/provider/rank/all_rank_provider.dart';
import 'package:training999/provider/rank/model/rank.dart';
import 'package:training999/provider/rank/my_latest_rank_provider.dart';
import 'package:training999/util/player_title.dart';
import 'package:training999/util/time_utils.dart';

/// Neon panel decoration shared by the overlays.
BoxDecoration neonPanelDecoration(Color accent, {double radius = 14}) =>
    BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          UiColors.panelTop.withValues(alpha: 0.92),
          UiColors.panelBottom.withValues(alpha: 0.92),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: accent.withValues(alpha: 0.6), width: 1.5),
      boxShadow: [
        BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 18),
      ],
    );

class RankingListWidget extends ConsumerStatefulWidget {
  const RankingListWidget({super.key, required this.voidCallback});

  final VoidCallback voidCallback;

  @override
  ConsumerState<RankingListWidget> createState() => _RankingListWidgetState();
}

class _RankingListWidgetState extends ConsumerState<RankingListWidget> {
  static const double _itemExtent = 52;

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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.voidCallback,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: allRanks.when(
              data: (rankList) => _buildContent(rankList, myLatestRank),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: UiColors.cyan)),
              error: (error, stackTrace) => Center(
                child: Text('排行榜載入失敗\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: UiColors.pink)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Rank> rankList, Rank? myLatestRank) {
    final latestRankIndex =
        rankList.indexWhere((element) => element.id == myLatestRank?.id);
    _scrollToCenter(latestRankIndex);

    final rankingPanel = Container(
      decoration: neonPanelDecoration(UiColors.cyan),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              _NeonText('RANKING', fontSize: 18, letterSpacing: 4),
              SizedBox(width: 10),
              Text('排行榜',
                  style: TextStyle(color: UiColors.textDim, fontSize: 14)),
              Spacer(),
              Text('TOP ${AllRank.rankLimit}',
                  style: TextStyle(
                      color: UiColors.textFaint,
                      fontSize: 11,
                      letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: rankList.isEmpty
                ? const Center(
                    child: Text('還沒有紀錄，成為第一位飛行員吧！',
                        style: TextStyle(color: UiColors.textDim)))
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverFixedExtentList.builder(
                        itemExtent: _itemExtent,
                        itemCount: rankList.length,
                        itemBuilder: (context, index) => _RankTile(
                          position: index + 1,
                          rank: rankList[index],
                          isHighlighted: latestRankIndex == index,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (myLatestRank != null) ...[
                SizedBox(
                  width: 250,
                  child: _ResultCard(
                    rank: myLatestRank,
                    position:
                        latestRankIndex == -1 ? null : latestRankIndex + 1,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(child: rankingPanel),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text('點擊任意處返回選單',
            style: TextStyle(
                color: UiColors.textFaint, fontSize: 11, letterSpacing: 2)),
      ],
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

/// Result of the latest run: time, title and position on the board.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.rank, required this.position});

  final Rank rank;

  /// 1-based position in the ranking, or null when outside the top list.
  final int? position;

  @override
  Widget build(BuildContext context) {
    final title = _titleOf(rank);
    return Container(
      decoration: neonPanelDecoration(UiColors.gold),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _NeonText('RESULT', fontSize: 14, letterSpacing: 4),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _NeonText(formatMilliseconds(rank.survivedTimeInMilliseconds),
                  fontSize: 36, tabular: true),
              const SizedBox(width: 4),
              const Text('秒',
                  style: TextStyle(color: UiColors.textDim, fontSize: 14)),
            ],
          ),
          Text('絕妙度 ${rank.brilliantlyDodgedTheBullets}',
              style: const TextStyle(color: UiColors.textDim, fontSize: 13)),
          const Spacer(),
          const Text('獲得稱號',
              style: TextStyle(
                  color: UiColors.textFaint, fontSize: 11, letterSpacing: 2)),
          const SizedBox(height: 4),
          _NeonText('「$title」',
              fontSize: 19, color: UiColors.gold, glow: UiColors.gold),
          const Spacer(),
          Text(
            position == null ? '未進入前 ${AllRank.rankLimit} 名' : '第 $position 名',
            style: TextStyle(
              color: position == null ? UiColors.textDim : UiColors.cyan,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.position,
    required this.rank,
    required this.isHighlighted,
  });

  final int position;
  final Rank rank;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isHighlighted
            ? UiColors.cyan.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: position.isEven ? 0.03 : 0.0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? UiColors.cyan : Colors.transparent,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                    color: UiColors.cyan.withValues(alpha: 0.3), blurRadius: 10)
              ]
            : null,
      ),
      child: Row(
        children: [
          _PositionBadge(position),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rank.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: UiColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.15)),
                Text(_titleOf(rank),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: UiColors.gold, fontSize: 11, height: 1.15)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${formatMilliseconds(rank.survivedTimeInMilliseconds)} 秒',
                  style: const TextStyle(
                      color: UiColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFeatures: tabularFigures,
                      height: 1.15)),
              Text('絕妙度 ${rank.brilliantlyDodgedTheBullets}',
                  style: const TextStyle(
                      color: UiColors.textDim,
                      fontSize: 11,
                      fontFeatures: tabularFigures,
                      height: 1.15)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Round badge with gold / silver / bronze for the top three.
class _PositionBadge extends StatelessWidget {
  const _PositionBadge(this.position);

  final int position;

  @override
  Widget build(BuildContext context) {
    final medal = switch (position) {
      1 => UiColors.gold,
      2 => UiColors.silver,
      3 => UiColors.bronze,
      _ => null,
    };
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: medal?.withValues(alpha: 0.9),
        border: Border.all(color: medal ?? UiColors.textFaint),
        boxShadow: medal == null
            ? null
            : [BoxShadow(color: medal.withValues(alpha: 0.5), blurRadius: 8)],
      ),
      child: Text(
        '$position',
        style: TextStyle(
          color: medal == null ? UiColors.textDim : Colors.black,
          fontSize: position >= 100 ? 10 : 13,
          fontWeight: FontWeight.w800,
          fontFeatures: tabularFigures,
        ),
      ),
    );
  }
}

class _NeonText extends StatelessWidget {
  const _NeonText(
    this.text, {
    required this.fontSize,
    this.color = UiColors.text,
    this.glow = UiColors.cyan,
    this.letterSpacing = 0,
    this.tabular = false,
  });

  final String text;
  final double fontSize;
  final Color color;
  final Color glow;
  final double letterSpacing;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: letterSpacing,
        shadows: neonGlow(glow),
        fontFeatures: tabular ? tabularFigures : null,
      ),
    );
  }
}

String _titleOf(Rank rank) => fullTitleFor(
    rank.survivedTimeInMilliseconds, rank.brilliantlyDodgedTheBullets);
