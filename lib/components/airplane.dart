import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'bullet.dart';

class Airplane extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Airplane() : super(size: Vector2(16, 19.5), anchor: Anchor.center);

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
    if (other is Bullet) {
      debugPrint('[TONY] Airplane collided with bullet!');
    }
  }
}
