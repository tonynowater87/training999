import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

enum BulletLevel { easy, middle, hard }

extension BulletLevelExtension on BulletLevel {
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

  Vector2 getVelocity(Vector2 direction) {
    switch (this) {
      case BulletLevel.easy:
        return Vector2(direction.x * 50, direction.y * 50);
      case BulletLevel.middle:
        return Vector2(direction.x * 150, direction.y * 100);
      case BulletLevel.hard:
        return Vector2(direction.x * 300, direction.y * 200);
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
