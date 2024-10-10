import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:training999/components/explosion.dart';
import 'package:training999/training_999.dart';

import 'bullet.dart';

class Airplane extends SpriteAnimationComponent with HasGameRef<Training999>, CollisionCallbacks {
  Airplane() : super(size: Vector2(32, 39), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    position = game.camera.viewport.size / 2;
    animation = await game.loadSpriteAnimation(
      'airplane.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
    add(PolygonHitbox(
      [
        Vector2(15, 0),
        Vector2(12, 7),
        Vector2(12, 12),
        Vector2(10, 13),
        Vector2(10, 17),
        Vector2(2, 24),
        Vector2(2, 27),
        Vector2(4, 27),
        Vector2(9, 25),
        Vector2(13, 25),
        Vector2(13, 29),
        Vector2(19, 29),
        Vector2(19, 25),
        Vector2(23, 25),
        Vector2(28, 27),
        Vector2(30, 27),
        Vector2(30, 24),
        Vector2(23, 17),
        Vector2(23, 13),
        Vector2(21, 12),
        Vector2(21, 7),
      ],
    ));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      game.calcBulletCount();
      explode();
      gameRef.gameover();
      gameRef.router.pushNamed("gameover");
      debugPrint('[TONY] Airplane collided with bullet!');
    }
  }

  @override
  void update(double dt) {
    if (gameRef.isGameOver) {
      return;
    }
    // check if the airplane is out of the screen
    if (position.x - (size.x / 2) <= 0 &&
        position.y + size.y / 2 >= game.canvasSize.y) {
      position = Vector2(size.x / 2, game.canvasSize.y - size.y / 2);
    } else if (position.x + size.x / 2 >= game.canvasSize.x &&
        position.y + size.y / 2 >= game.canvasSize.y) {
      position = Vector2(
          game.canvasSize.x - size.x / 2, game.canvasSize.y - size.y / 2);
    } else if (position.x + size.x / 2 >= game.canvasSize.x &&
        position.y - size.y / 2 <= 0) {
      position = Vector2(game.canvasSize.x - size.x / 2, size.y / 2);
    } else if (position.x - size.x / 2 <= 0 && position.y - size.y / 2 <= 0) {
      position = Vector2(size.x / 2, size.y / 2);
    } else if (position.x - (size.x / 2) <= 0) {
      position.x = size.x / 2;
    } else if (position.y + size.y / 2 >= game.canvasSize.y) {
      position.y = game.canvasSize.y - size.y / 2;
    } else if (position.x + size.x / 2 >= game.canvasSize.x) {
      position.x = game.canvasSize.x - size.x / 2;
    } else if (position.y - size.y / 2 <= 0) {
      position.y = size.y / 2;
    }
    super.update(dt);
  }

  void explode() {
    game.add(ExplosionComponent(position: position));
  }
}
