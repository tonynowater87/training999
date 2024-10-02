import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';
import 'package:training999/components/airplane.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/components/bullet_text.dart';
import 'package:training999/components/explosion.dart';
import 'package:training999/page/splash_page.dart';

class Training999 extends FlameGame
    with
        DragCallbacks,
        HasKeyboardHandlerComponents,
        TapCallbacks,
        HasCollisionDetection {
  late Airplane player;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;
  late double gameSizeOfRadius;
  int bulletCount = 0;
  bool isGameOver = false;
  late final RouterComponent router;

  Training999() : super();

  @override
  bool get pauseWhenBackgrounded => true;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  void stepEngine({double stepTime = 1 / 60}) {
    super.stepEngine();
  }

  @override
  Future onLoad() async {
    // debugMode = kDebugMode;

    add(router = RouterComponent(initialRoute: "splash",
        routes: { 'splash': Route(SplashScreenPage.new) }
    ));

    await images.loadAllImages();
    gameSizeOfRadius = pow(
            pow(camera.viewport.size.x, 2) + pow(camera.viewport.size.y, 2),
            0.5) /
        2.0;
    debugPrint('[TONY] game.size: $size, gameSizeOfRadius: $gameSizeOfRadius');

    add(player = Airplane());
    addBullet();
    addBulletCountText();
    addJoystick();
  }

  void addBulletCountText() {
    add(BulletText());
  }

  void addBullet() {
    final Random _rng = Random(DateTime.now().millisecondsSinceEpoch);
    add(TimerComponent(
        period: 0.1,
        repeat: true,
        autoStart: true,
        onTick: () {
          for (var i = 1; i <= 1; i++) {
            var angle = _rng.nextDouble() * 360;
            var radians = angle * pi / 180;
            Vector2 position = Vector2(gameSizeOfRadius * cos(radians),
                    gameSizeOfRadius * sin(radians))
                .translated(size.x / 2, size.y / 2);
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

  @override
  void onTapUp(TapUpEvent event) {
    removeWhere((c) => c is Bullet || c is TimerComponent || c is ExplosionComponent);
    Future.delayed(const Duration(seconds: 1), () {
      reset();
    });
    super.onTapUp(event);
  }

  void reset() {
    addBullet();
    bulletCount = 0;
    isGameOver = false;
  }

  void updateJoystick() {
    if (isGameOver) {
      return;
    }
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
