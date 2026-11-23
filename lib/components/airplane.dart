import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/ship_painter.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/components/explosion.dart';
import 'package:training999/training_999.dart';

/// Player ship, drawn with [ShipPainter]. The hitbox uses the same hull
/// polygon as the drawing.
class Airplane extends PositionComponent
    with HasPaint, HasGameReference<Training999>, CollisionCallbacks {
  Airplane()
      : super(
          size: Vector2(shipWidth, shipHeight),
          anchor: Anchor.center,
          priority: 100,
        );

  double _time = 0;
  final Paint _layerPaint = Paint();

  @override
  Future<void> onLoad() async {
    position = game.camera.viewport.size / 2;
    add(PolygonHitbox([for (final (x, y) in shipHullPoints) Vector2(x, y)]));
  }

  @override
  void render(Canvas canvas) {
    if (opacity < 1) {
      _layerPaint.color = Color.fromRGBO(0, 0, 0, opacity);
      canvas.saveLayer(null, _layerPaint);
      ShipPainter.paint(canvas, _time);
      canvas.restore();
    } else {
      ShipPainter.paint(canvas, _time);
    }
  }

  /// Uses [onCollision] (every frame while overlapping) instead of
  /// onCollisionStart, so a bullet still overlapping when invincibility ends
  /// is not ignored.
  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    if (other is! Bullet || game.isGameOver || game.isInvincible) {
      return;
    }
    if (game.consumeShield()) {
      other.removeFromParent();
      return;
    }
    explode();
    game.gameover();
  }

  @override
  void update(double dt) {
    _time += dt;
    if (game.isGameOver) {
      return;
    }
    // Keep the airplane inside the screen (size is affected by shrink).
    final halfWidth = scaledSize.x / 2;
    final halfHeight = scaledSize.y / 2;
    position.setValues(
      position.x.clamp(halfWidth, game.size.x - halfWidth).toDouble(),
      position.y.clamp(halfHeight, game.size.y - halfHeight).toDouble(),
    );
    // Blink while invincible.
    opacity = game.isInvincible && (game.invincibleTimeLeft * 10).floor().isEven
        ? 0.3
        : 1.0;
    super.update(dt);
  }

  void explode() {
    // The ship is destroyed; reset() makes it visible again.
    opacity = 0;
    game.add(ExplosionComponent(position: position));
  }
}
