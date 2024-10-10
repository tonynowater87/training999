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
import 'package:training999/components/star_background_creator.dart';
import 'package:training999/page/game_over_page.dart';
import 'package:training999/page/menu_page.dart';
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
  int defaultLevel = 2;
  int gameTime = 0;
  int lastTime = 0;
  int surviveTime = 0;
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

    add(router = RouterComponent(initialRoute: "splash", routes: {
      'splash': Route(SplashPage.new),
      'menu': Route(MenuPage.new),
      'gameover': Route(GameOverPage.new),
    }));

    await images.loadAllImages();
    gameSizeOfRadius = pow(
            pow(camera.viewport.size.x, 2) + pow(camera.viewport.size.y, 2),
            0.5) /
        2.0;
    debugPrint('[TONY] game.size: $size, gameSizeOfRadius: $gameSizeOfRadius');
    player = Airplane();
    add(StarBackGroundCreator());
    initJoystick();
  }

  void start() {
    isGameOver = false;
    if (!contains(player)) {
      add(player);
    }
    if (!contains(joystickLeft) || !contains(joystickRight)) {
      addJoystick();
    }

    for (var i = 1; i <= defaultLevel; i++) {
      addBullet();
    }
    add(TimerComponent(
        period: 1,
        repeat: true,
        autoStart: true,
        onTick: () {
          if (isGameOver) {
            return;
          }
          gameTime++;
          if (gameTime % 10 == 0) {
            addBullet();
          }
          debugPrint('[TONY] TimerComponent.onTick() called! gameTime: $gameTime');
        }));
  }

  void addBulletCountText() {
    calcBulletCount();
    add(BulletText());
  }

  void addBullet() {
    final Random _rng = Random(DateTime.now().millisecondsSinceEpoch);
    debugPrint('[TONY] addBullet() called! _rng: ${_rng.hashCode}');
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
    if (!isGameOver) {
      var dateTime = DateTime.now();
      if (lastTime == 0) {
        lastTime = dateTime.millisecondsSinceEpoch;
      }
      var now = dateTime.millisecondsSinceEpoch;
      surviveTime = now - lastTime;
    }
    super.update(dt);
  }

  void initJoystick() {
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
  }

  void addJoystick() {
    add(joystickLeft);
    add(joystickRight);
  }

  void gameover() {
    isGameOver = true;
    removeWhere((c) => c is TimerComponent);
  }

  void reset() {
    removeWhere((c) =>
        c is Bullet ||
        c is TimerComponent ||
        c is ExplosionComponent ||
        c is BulletText);
    defaultLevel = 2;
    bulletCount = 0;
    gameTime = 0;
    surviveTime = 0;
    lastTime = 0;
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

  void calcBulletCount() {
    bulletCount = children.whereType<Bullet>().length;
  }
}
