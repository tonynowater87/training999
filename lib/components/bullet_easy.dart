import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

class BulletEasy extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  late Vector2 direction;

  BulletEasy(position)
      : super(position: position, radius: 2, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(CircleHitbox());

    paint = Paint()..color = Colors.orange;

    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;

    direction =
        Vector2(centerX > position.x ? 1 : -1, centerY > position.y ? 1 : -1);
    _velocity = Vector2(direction.x * 100, direction.y * 100);
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
