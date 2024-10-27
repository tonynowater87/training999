import 'dart:math';

import 'package:flutter/material.dart';

class RankingListWidget extends StatelessWidget {
  const RankingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 200,
        height: 300,
        color: Colors.black.withOpacity(0.5),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                title: Text('Rank ${index + 1}',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text('Tony', style: TextStyle(color: Colors.white)),
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
