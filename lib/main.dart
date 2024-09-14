import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  var game = Training999();
  runApp(GameWidget.controlled(
    gameFactory: () {
      return kDebugMode ? Training999() : game;
    },
  ));
}
