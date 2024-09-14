import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'bullet.dart';

class Airplane extends SpriteAnimationComponent
    with HasGameRef, HasCollisionDetection, CollisionCallbacks {
  Airplane() : super(size: Vector2(32, 39), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    position = game.canvasSize / 2;
    animation = await game.loadSpriteAnimation(
      'airplane.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    debugPrint('[TONY] Airplane collided with something!');
    if (other is Bullet) {
      debugPrint('[TONY] Airplane collided with bullet!');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
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
}
