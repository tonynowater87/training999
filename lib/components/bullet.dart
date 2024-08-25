import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:training999/components/airplane.dart';
import 'package:training999/training_999.dart';

class Bullet extends RectangleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  Vector2 _velocity;
  double _randomAngle;

  Bullet(this._velocity, this._randomAngle) : super() {
    size = Vector2.all(10);
    paint = Paint()..color = Colors.red;
  }

  @override
  Future<void> onLoad() async {
    //position = Vector2(game.camera.viewport.position.x, game.camera.viewport.position.y);
    //debugPrint('[TONY] Bullet position: $position');

    add(RectangleHitbox());
    add(TextBoxComponent(
        text: '$_randomAngle',
        boxConfig: TextBoxConfig(),
        size: Vector2(50, 50)));

    position = Vector2(game.gameSizeOfRadius * cos(_randomAngle),
            game.gameSizeOfRadius * sin(_randomAngle))
        .translated(game.canvasSize.x / 2, game.canvasSize.y / 2);
    debugPrint(
        '[TONY] game size of radius: ${game.gameSizeOfRadius}, size: ${game.canvasSize}');
    debugPrint('[TONY] Bullet position: $position');
    var endPosition = Vector2(-position.x, -position.y);
    add(MoveToEffect(
      endPosition,
      EffectController(
        duration: 10,
        curve: Curves.linear,
      ),
    ));
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
