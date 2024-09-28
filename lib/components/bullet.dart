import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';

class Bullet extends CircleComponent
    with HasGameRef<Training999>, CollisionCallbacks {
  late Vector2 _velocity;
  double _randomRadians;
  String title;
  late Vector2 direction;

  late Vector2 endPoint;

  Bullet(this._randomRadians, this.title)
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
    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;
    debugPrint('[TONY] $hashCode Bullet onMount $position ($centerX, $centerY)');
    super.onMount();
  }

  @override
  void onRemove() {
    debugPrint('[TONY] $hashCode Bullet onRemove');
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var random = Vector2.random();

    add(CircleHitbox());

    var initX = game.gameSizeOfRadius * cos(_randomRadians);
    var initY = game.gameSizeOfRadius * sin(_randomRadians);

    var centerX = game.canvasSize.x / 2;
    var centerY = game.canvasSize.y / 2;

    direction = Vector2(centerX > initX ? 1 : -1, centerY > initY ? 1 : -1);

    position = positionOf(Vector2(initX, initY));

    _velocity = random * 100 + Vector2(direction.x, direction.y);

    debugPrint('[TONY] $hashCode Bullet onLoad: $direction, $_randomRadians');
  }

  double bufferSize = 35;

  @override
  void update(double dt) {
    super.update(dt);
    position += direction + _velocity * dt;

    if (position.y < -game.gameSizeOfRadius / 2 ||
        position.y > game.size.y + game.gameSizeOfRadius / 2 ||
        position.x > game.size.x + game.gameSizeOfRadius / 2 ||
        position.x + size.x < -game.gameSizeOfRadius / 2) {
      removeFromParent();
    }
  }
}
