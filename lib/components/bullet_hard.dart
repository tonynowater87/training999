import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

/// Homing bullet: turns towards the player with a limited turn rate for
/// [HomingConfig.homingDuration] seconds, then keeps flying straight.
class BulletHard extends SpriteComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletHard(Vector2 position)
      : super(position: position, anchor: Anchor.center);

  double _homingTimeLeft = HomingConfig.homingDuration;

  @override
  BulletLevel get level => BulletLevel.hard;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('bullet_hard.png', srcSize: Vector2(7, 7));
    add(RectangleHitbox());
    aimAt(game.player.position);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      return;
    }
    final scaledDt = dt * game.bulletTimeScale;
    if (_homingTimeLeft > 0) {
      _homingTimeLeft -= scaledDt;
      _steerTowards(game.player.position, scaledDt);
    }
    moveBullet(scaledDt);
  }

  void _steerTowards(Vector2 target, double dt) {
    final desired = target - position;
    if (desired.isZero()) {
      return;
    }
    final currentAngle = atan2(velocity.y, velocity.x);
    final desiredAngle = atan2(desired.y, desired.x);

    // Wrap the difference into [-pi, pi] so the bullet turns the short way.
    var angleDifference = desiredAngle - currentAngle;
    if (angleDifference > pi) {
      angleDifference -= 2 * pi;
    } else if (angleDifference < -pi) {
      angleDifference += 2 * pi;
    }

    final maxStep = HomingConfig.maxTurnRate * dt;
    final newAngle =
        currentAngle + angleDifference.clamp(-maxStep, maxStep).toDouble();
    velocity = Vector2(cos(newAngle), sin(newAngle)) * level.getSpeed();
  }
}
