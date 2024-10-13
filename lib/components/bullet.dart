import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  late Vector2 direction;
  BulletLevel bulletLevel;

  Bullet(position, this.bulletLevel)
      : super(position: position, radius: 2, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(CircleHitbox());

    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;

    direction =
        Vector2(centerX > position.x ? 1 : -1, centerY > position.y ? 1 : -1);
    paint = Paint()..color = bulletLevel.getColor();
    _velocity = bulletLevel.getVelocity(direction);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isGameOver) {
      return;
    }
    position.add(direction + _velocity * dt);
    if (position.y < -game.gameSizeOfRadius / 2 ||
        position.y > game.size.y + game.gameSizeOfRadius / 4 ||
        position.x > game.size.x + game.gameSizeOfRadius / 2 ||
        position.x + size.x < -game.gameSizeOfRadius / 4) {
      removeFromParent();
    }
  }
}
