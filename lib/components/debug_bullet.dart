import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class DebugBullet extends CircleComponent with HasGameRef {
  DebugBullet(Vector2 position)
      : super(
          position: position,
          radius: 2,
          paint: Paint()..color = const Color(0xFFFF0000),
          anchor: Anchor.center,
        );

  final delayTimeInSecond = 2;
  var velocity = 0;
  var direction = Vector2(0, 0);

  @override
  void onMount() {
    final hash = hashCode;
    debugPrint('[TONY] $hash DebugBullet onMount: $position');
    Future.delayed(Duration(seconds: delayTimeInSecond), () {
      if (position.x > game.canvasSize.x / 2 && position.y < game.canvasSize.y / 2) {
        debugPrint('[TONY] 第一象限 $hash (${position.x}, ${position.y})');
        direction = Vector2(-1, 1) * 50;
      } else if (position.x < game.canvasSize.x / 2 && position.y < game.canvasSize.y / 2) {
        debugPrint('[TONY] 第二象限 $hash (${position.x}, ${position.y})');
        direction = Vector2(1, 1) * 50;
      } else if (position.x < game.canvasSize.x / 2 && position.y > game.canvasSize.y / 2) {
        debugPrint('[TONY] 第三象限 $hash (${position.x}, ${position.y})');
        direction = Vector2(1, -1) * 50;
      } else {
        debugPrint('[TONY] 第四象限 $hash (${position.x}, ${position.y})');
        direction = Vector2(-1, -1) * 50;
      }
    });
    super.onMount();
  }

  @override
  void update(double dt) {
    position += direction * dt;
    super.update(dt);
  }
}
