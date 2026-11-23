import 'dart:math';

import 'package:flutter/material.dart';

enum BulletLevel { easy, middle, hard }

extension BulletLevelExtension on BulletLevel {
  /// Seconds between two spawns of this bullet level.
  double getPeriod() {
    switch (this) {
      case BulletLevel.easy:
        return 0.1;
      case BulletLevel.middle:
        return 1.0;
      case BulletLevel.hard:
        return 2.0;
    }
  }

  Color getColor() {
    switch (this) {
      case BulletLevel.easy:
        return Colors.orange;
      case BulletLevel.middle:
        return Colors.yellow;
      case BulletLevel.hard:
        return Colors.red;
    }
  }

  /// Bullet speed in pixels per second (same in every direction).
  double getSpeed() {
    switch (this) {
      case BulletLevel.easy:
        return 150;
      case BulletLevel.middle:
        return 280;
      case BulletLevel.hard:
        return 450;
    }
  }

  double getRadius() {
    switch (this) {
      case BulletLevel.easy:
        return 2;
      case BulletLevel.middle:
        return 3;
      case BulletLevel.hard:
        return 4;
    }
  }
}

/// Tuning values for the homing bullet ([BulletLevel.hard]).
class HomingConfig {
  HomingConfig._();

  /// Maximum turning speed while homing, in radians per second.
  static const double maxTurnRate = 60 * pi / 180;

  /// How long the bullet keeps homing before it flies straight.
  static const double homingDuration = 2.5;
}

/// Random spread (radians) applied to easy bullets aimed at the screen center.
const double easyBulletSpread = 20 * pi / 180;
