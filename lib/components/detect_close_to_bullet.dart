import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/art/ship_painter.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';

class DetectCloseToBullet extends PositionComponent
    with HasGameReference<Training999>, CollisionCallbacks {
  DetectCloseToBullet()
      : super(size: Vector2(shipWidth * 1.5, shipHeight * 1.5));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    // Same hull as the airplane, 1.5x larger: a bullet passing through this
    // zone without hitting the airplane counts as a brilliant dodge.
    final polygonHitbox =
        PolygonHitbox([for (final (x, y) in shipHullPoints) Vector2(x, y)]);
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
