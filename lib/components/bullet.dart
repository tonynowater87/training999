import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

enum BulletLevel { easy, middle, hard }

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  late Vector2 direction;
  BulletLevel bulletLevel;

  Bullet(position, this.bulletLevel)
      : super(
            position: position,
            radius: 2,
            paint: Paint()..color = Colors.yellow,
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var random = Vector2.random(Random(DateTime.now().millisecond));

    add(CircleHitbox());

    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;

    direction =
        Vector2(centerX > position.x ? 1 : -1, centerY > position.y ? 1 : -1);

    switch (bulletLevel) {
      case BulletLevel.easy:
        _velocity = random * 50 + Vector2(direction.x, direction.y);
        break;
      case BulletLevel.middle:
        _velocity = random * 75 + Vector2(direction.x, direction.y);
        break;
      case BulletLevel.hard:
        _velocity = random * 100 + Vector2(direction.x, direction.y);
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isGameOver) {
      return;
    }
    position += direction + _velocity * dt;
    if (position.y < -game.gameSizeOfRadius / 2 ||
        position.y > game.size.y + game.gameSizeOfRadius / 4 ||
        position.x > game.size.x + game.gameSizeOfRadius / 2 ||
        position.x + size.x < -game.gameSizeOfRadius / 4) {
      removeFromParent();
    }
  }
}
