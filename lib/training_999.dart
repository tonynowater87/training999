import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:training999/components/airplane.dart';
import 'package:training999/components/bullet.dart';

class Training999 extends FlameGame with DragCallbacks, HasKeyboardHandlerComponents {
  late Airplane player;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;
  final Random _rng = Random();
  late double gameSizeOfRadius;

  Training999() : super();

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  void stepEngine({double stepTime = 1 / 60}) {
    debugPrint('[TONY] stepEngine: $stepTime');
    super.stepEngine();
  }

  @override
  Future onLoad() async {
    // debugMode = kDebugMode;
    await images.loadAllImages();
    gameSizeOfRadius = pow(pow(camera.viewport.size.x, 2) + pow(camera.viewport.size.y, 2), 0.5) / 2.0;
    debugPrint('[TONY] gameSizeOfRadius: $gameSizeOfRadius');
    debugPrint('[TONY] game.size: $size');
    debugPrint('[TONY] game.canvasSize: $canvasSize');
    debugPrint('[TONY] camera.viewport.size: ${camera.viewport.size}');
    debugPrint('[TONY] camera.viewfinder.camera.viewport.size: ${camera.viewfinder.camera.viewport.size}');

    add(player = Airplane());
    addJoystick();
    addBullet();
  }

  void addBullet() {
    add(TimerComponent(
        period: 0.1,
        repeat: true,
        autoStart: true,
        onTick: () {
          for (var i = 1; i <= 1; i++) {
            var angle = _rng.nextDouble() * 360;
            var radians = angle * pi / 180;
            Vector2 position = Vector2(gameSizeOfRadius * cos(radians) , gameSizeOfRadius * sin(radians)).translated(size.x / 2, size.y /2);
            add(Bullet(position));
          }
        })
      ..onTick());
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystickLeft = JoystickComponent(
        priority: 10,
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('Knob.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('Joystick.png'),
          ),
        ),
        position: Vector2(64, canvasSize.y - 64));
    add(joystickLeft);

    joystickRight = JoystickComponent(
        priority: 10,
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('Knob.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('Joystick.png'),
          ),
        ),
        position: Vector2(canvasSize.x - 64, canvasSize.y - 64));
    add(joystickRight);
  }

  void updateJoystick() {
    switch (joystickLeft.direction) {
      case JoystickDirection.left:
        player.position += Vector2(-0.75, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -0.75);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        player.position += Vector2(0.75, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, 0.75);
        break;
      case JoystickDirection.downLeft:
        player.position += Vector2(-0.75, 0.75);
        break;
      default:
        player.position += Vector2(0, 0);
        break;
    }

    switch (joystickRight.direction) {
      case JoystickDirection.left:
        player.position += Vector2(-0.75, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -0.75);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        player.position += Vector2(0.75, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, 0.75);
        break;
      case JoystickDirection.downLeft:
        player.position += Vector2(-0.75, 0.75);
        break;
      default:
        player.position += Vector2(0, 0);
        break;
    }
    player.position += joystickLeft.relativeDelta + joystickRight.relativeDelta;
  }
}
