import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training999/provider/rank_provider.dart';

class RankingListWidget extends ConsumerWidget {
  const RankingListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankList = ref.watch(rankListProvider);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 3,
        height: 300,
        color: Colors.black.withOpacity(0.5),
        child: ListView.builder(
          itemCount: rankList.length,
          itemBuilder: (context, index) {
            final rank = rankList[index];
            return Container(
              child: ListTile(
                title: Text('排名 ${index + 1}',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(rank.name),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("存活時間 ${rank.survivedTimeInMilliseconds}",
                        style: TextStyle(color: Colors.white)),
                    Text("絕妙度 ${rank.brilliantlyDodgedTheBullets}",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2);
  }
}
