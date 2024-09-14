import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  Vector2 _velocity;
  double _randomRadians;
  String title;
  TextPaint textPaint =
      TextPaint(style: const TextStyle(color: Colors.white, fontSize: 8));

  late Vector2 endPoint;

  Bullet(this._velocity, this._randomRadians, this.title)
      : super(
            radius: 2,
            paint: Paint()..color = Colors.yellow,
            anchor: Anchor.center);

  @override
  void onGameResize(Vector2 size) {
    debugPrint('[TONY] $hashCode Bullet onGameResize: $size');
    super.onGameResize(size);
  }

  @override
  void onMount() {
    position = position.translated(game.canvasSize.x / 2, game.canvasSize.y / 2);
    super.onMount();
  }

  @override
  void onRemove() {
    debugPrint('[TONY] $hashCode Bullet onRemove: $size');
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugPrint('[TONY] $hashCode Bullet onLoad: $size');

    add(CircleHitbox());
    //add(TextBoxComponent(textRenderer: textPaint, text: '$title'));

    var initX = game.gameSizeOfRadius * cos(_randomRadians);
    var initY = game.gameSizeOfRadius * sin(_randomRadians);

    position = positionOf(Vector2(initX, initY));
  }

  double bufferSize = 35;

  @override
  void update(double dt) {
    super.update(dt);
    final direction = Vector2(1, 0);
    position += direction + _velocity * dt;

    // if (position.y < 0 ||
    //     position.y > game.size.y ||
    //     position.x > game.size.x ||
    //     position.x + size.x < 0) {
    //   removeFromParent();
    // }

    // var distanceTo = position.distanceTo(endPoint);
    // if (distanceTo < 5) {
    //   removeFromParent();
    // }
  }
}
