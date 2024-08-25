import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Airplane extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Airplane() : super(size: Vector2(32, 39), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    position = game.size / 2;
    animation = await game.loadSpriteAnimation(
      'airplane.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
  }
}
