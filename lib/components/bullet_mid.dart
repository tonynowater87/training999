import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

/// Fast bullet aimed at the player's position at spawn time.
class BulletMid extends SpriteComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletMid(Vector2 position)
      : super(position: position, anchor: Anchor.center);

  @override
  BulletLevel get level => BulletLevel.middle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('bullet_mid.png', srcSize: Vector2(5, 5));
    add(RectangleHitbox());
    aimAt(game.player.position);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      return;
    }
    moveBullet(dt);
  }
}
