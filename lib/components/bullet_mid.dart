import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/training_999.dart';

class BulletMid extends SpriteComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  late Vector2 direction;
  Vector2 previousDirection = Vector2.zero(); // 儲存上一幀的方向向量

  BulletMid(position) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox());

    sprite = await gameRef.loadSprite('bullet_mid.png', srcSize: Vector2(5, 5));

    direction = (game.player.position - position).normalized();
    _velocity = Vector2(direction.x * 250, direction.y * 200);
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
