import 'package:flame/components.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/bullet_level.dart';

/// Shared behaviour of every bullet: frame-rate independent movement and
/// removal once the bullet has left the play field.
mixin Bullet on PositionComponent, HasGameReference<Training999> {
  BulletLevel get level;

  /// Velocity in pixels per second.
  Vector2 velocity = Vector2.zero();

  /// Points [velocity] from the current position towards [target].
  void aimAt(Vector2 target, {double angleOffset = 0}) {
    final direction = target - position;
    if (direction.isZero()) {
      direction.setValues(1, 0);
    }
    direction
      ..normalize()
      ..rotate(angleOffset);
    velocity = direction * level.getSpeed();
  }

  void moveBullet(double dt) {
    position.addScaled(velocity, dt);
    // Bullets spawn on a circle around the screen center, so use the same
    // distance-based rule to decide when a bullet has left the field.
    if (position.distanceTo(game.size / 2) > game.bulletDespawnRadius) {
      removeFromParent();
    }
  }
}
