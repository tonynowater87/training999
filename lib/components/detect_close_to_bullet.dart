import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:training999/components/info_text.dart';
import 'package:training999/training_999.dart';

import 'bullet.dart';

class DetectCloseToBullet extends PositionComponent
    with HasGameRef<Training999>, CollisionCallbacks {
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
      debugPrint('[TONY] 絕妙度過子彈!!!！');
      game.add(InfoTextComponent("絕妙度過子彈！", game.size / 2));
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   if (gameRef.isGameOver) {
      //     return;
      //   }
      //   game.add(InfoTextComponent("絕妙度過子彈！", game.size / 2));
      // });
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isGameOver) {
      return;
    }
    position = gameRef.player.position;
  }
}
