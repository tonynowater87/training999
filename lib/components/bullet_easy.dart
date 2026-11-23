import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

class BulletEasy extends CircleComponent
    with HasGameReference<Training999>, CollisionCallbacks, Bullet {
  BulletEasy(Vector2 position, {required this.angleOffset})
      : super(
          position: position,
          radius: BulletLevel.easy.getRadius(),
          anchor: Anchor.center,
        );

  /// Random spread around the direction to the screen center.
  final double angleOffset;

  @override
  BulletLevel get level => BulletLevel.easy;

  static double randomSpread(Random rng) =>
      (rng.nextDouble() * 2 - 1) * easyBulletSpread;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    paint = Paint()..color = level.getColor();
    aimAt(game.size / 2, angleOffset: angleOffset);
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
