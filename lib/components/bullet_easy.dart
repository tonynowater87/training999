import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/art/bullet_painter.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

class BulletEasy extends CircleComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletEasy(
    Vector2 position, {
    this.angleOffset = 0,
    this.target,
    this.color,
  }) : super(
          position: position,
          radius: BulletLevel.easy.getRadius(),
          anchor: Anchor.center,
        );

  /// Random spread around the direction to [target].
  final double angleOffset;

  /// Point to fly towards; defaults to the screen center.
  final Vector2? target;

  /// Overrides the level color, e.g. for ring bullets.
  final Color? color;

  @override
  BulletLevel get level => BulletLevel.easy;

  static double randomSpread(Random rng) =>
      (rng.nextDouble() * 2 - 1) * easyBulletSpread;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    aimAt(target ?? game.size / 2, angleOffset: angleOffset);
  }

  @override
  void render(Canvas canvas) {
    BulletPainter.paintOrb(
        canvas, Offset(radius, radius), radius, color ?? level.getColor());
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
