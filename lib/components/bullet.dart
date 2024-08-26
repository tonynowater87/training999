import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:training999/components/airplane.dart';
import 'package:training999/training_999.dart';

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  Vector2 _velocity;
  double _randomRadians;
  String title;
  TextPaint textPaint =
      TextPaint(style: const TextStyle(color: Colors.white, fontSize: 8));

  Bullet(this._velocity, this._randomRadians, this.title)
      : super(radius: 5, paint: Paint()..color = Colors.red);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    anchor = Anchor.center;
    add(RectangleHitbox());
    add(TextBoxComponent(textRenderer: textPaint, text: '$title'));

    var initX = game.gameSizeOfRadius * cos(_randomRadians);
    var initY = game.gameSizeOfRadius * sin(_randomRadians);

    position = Vector2(initX, initY)
        .translated(game.canvasSize.x / 2, game.canvasSize.y / 2);

    var endX = game.gameSizeOfRadius * cos(_randomRadians + pi);
    var endY = game.gameSizeOfRadius * sin(_randomRadians + pi);

    var endPosition = Vector2(endX, endY)
        .translated(game.canvasSize.x / 2, game.canvasSize.y / 2);
    add(MoveToEffect(
        endPosition,
        EffectController(
          duration: 10,
          curve: Curves.linear,
        ), onComplete: () {
      removeFromParent();
    }));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.x < 0 ||
        position.x > game.canvasSize.x ||
        position.y < 0 ||
        position.y > game.canvasSize.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Airplane) {
      // TODO Do something
      debugPrint('[TONY] Bullet collided with airplane!');
      return;
    }
  }
}
