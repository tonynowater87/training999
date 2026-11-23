import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/bullet_painter.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

/// Homing bullet: turns towards the player with a limited turn rate for
/// [HomingConfig.homingDuration] seconds, then keeps flying straight.
class BulletHard extends PositionComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletHard(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(BulletLevel.hard.getRadius() * 2),
          anchor: Anchor.center,
        );

  static const double _trailLength = 18;
  static const Color _starColor = Color(0xFFFF8A80);

  double _homingTimeLeft = HomingConfig.homingDuration;
  double _time = 0;

  @override
  BulletLevel get level => BulletLevel.hard;

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
    // Pulses faster while it is still homing, as a warning.
    final pulse = 1 + 0.15 * sin(_time * (_homingTimeLeft > 0 ? 14 : 5));
    BulletPainter.paintTrail(canvas, center, atan2(velocity.y, velocity.x),
        _trailLength, radius * 1.4, level.getColor());
    BulletPainter.paintOrb(canvas, center, radius * 0.9, level.getColor(),
        haloScale: 3.0, pulse: pulse);
    BulletPainter.paintStar(
        canvas, center, radius * 1.8, _time * 6, _starColor);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
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
