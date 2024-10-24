import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';
import 'package:training999/widget/ranking_list_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  var game = Training999();
  runApp(GameWidget.controlled(
    gameFactory: () {
      return kDebugMode ? Training999() : game;
    },
    overlayBuilderMap: {
      'rank': (BuildContext context, Game game) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: RankingListWidget(),
        );
      },
    },
  ));
}
