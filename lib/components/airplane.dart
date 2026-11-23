import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/components/explosion.dart';
import 'package:training999/training_999.dart';

class Airplane extends SpriteAnimationComponent
    with HasGameReference<Training999>, CollisionCallbacks {
  Airplane()
      : super(size: Vector2(32, 39), anchor: Anchor.center, priority: 100);

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

  /// Uses [onCollision] (every frame while overlapping) instead of
  /// onCollisionStart, so a bullet still overlapping when invincibility ends
  /// is not ignored.
  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    if (other is! Bullet || game.isGameOver || game.isInvincible) {
      return;
    }
    if (game.consumeShield()) {
      other.removeFromParent();
      return;
    }
    explode();
    game.gameover();
  }

  @override
  void update(double dt) {
    if (game.isGameOver) {
      return;
    }
    // Keep the airplane inside the screen (size is affected by shrink).
    final halfWidth = scaledSize.x / 2;
    final halfHeight = scaledSize.y / 2;
    position.setValues(
      position.x.clamp(halfWidth, game.size.x - halfWidth).toDouble(),
      position.y.clamp(halfHeight, game.size.y - halfHeight).toDouble(),
    );
    // Blink while invincible.
    opacity = game.isInvincible && (game.invincibleTimeLeft * 10).floor().isEven
        ? 0.3
        : 1.0;
    super.update(dt);
  }

  void explode() {
    game.add(ExplosionComponent(position: position));
  }
}
