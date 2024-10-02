import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  late Vector2 direction;

  Bullet(position)
      : super(
            position: position,
            radius: 2,
            paint: Paint()..color = Colors.yellow,
            anchor: Anchor.center);

  @override
  void onRemove() {
    gameRef.bulletCount++;
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var random = Vector2.random();

    add(CircleHitbox());

    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;

    direction =
        Vector2(centerX > position.x ? 1 : -1, centerY > position.y ? 1 : -1);

    _velocity = random * 100 + Vector2(direction.x, direction.y);
  }

  double bufferSize = 35;

  @override
  void update(double dt) {
    super.update(dt);
    position += direction + _velocity * dt;

    if (position.y < -game.gameSizeOfRadius / 2 ||
        position.y > game.size.y + game.gameSizeOfRadius / 4 ||
        position.x > game.size.x + game.gameSizeOfRadius / 2 ||
        position.x + size.x < -game.gameSizeOfRadius / 4) {
      removeFromParent();
    }
  }
}
