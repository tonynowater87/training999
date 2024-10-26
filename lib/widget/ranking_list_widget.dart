import 'dart:math';

import 'package:flutter/material.dart';

class RankingListWidget extends StatelessWidget {

  const RankingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            color: randomColor(),
            child: ListTile(
              title: Text('Rank ${index + 1}'),
              subtitle: Text('Tony'),
            ),
          );
        },
      ),
    );
  }

  Color randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.2);
  }
}