import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/bullet_painter.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

/// Fast bullet aimed at the player's position at spawn time.
class BulletMid extends PositionComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletMid(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(BulletLevel.middle.getRadius() * 2),
          anchor: Anchor.center,
        );

  static const double _trailLength = 14;

  @override
  BulletLevel get level => BulletLevel.middle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    aimAt(game.player.position);
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;
    BulletPainter.paintTrail(canvas, center, atan2(velocity.y, velocity.x),
        _trailLength, radius * 1.4, level.getColor());
    BulletPainter.paintOrb(canvas, center, radius, level.getColor(),
        haloScale: 2.6);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      return;
    }
    moveBullet(dt * game.bulletTimeScale);
  }
}
