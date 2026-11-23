import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';

class DetectCloseToBullet extends PositionComponent
    with HasGameReference<Training999>, CollisionCallbacks {
  DetectCloseToBullet() : super(size: Vector2(48, 58.5));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    var polygonHitbox = PolygonHitbox([
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
    ]);
    add(polygonHitbox..scale = Vector2(1.5, 1.5));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      // Wait a moment: if the same bullet also hits the airplane, the game
      // is over and it must not count as a brilliant dodge.
      Future.delayed(const Duration(milliseconds: 50), () {
        if (game.isGameOver) {
          return;
        }
        game.addBrilliantlyDodgedTheBulletText();
      });
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      return;
    }
    position = game.player.position;
  }
}
