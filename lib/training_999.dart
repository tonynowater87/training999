import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Route;
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
        TapCallbacks,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {

  static double _joystickControllerConstant = 0.75;
  static double _keyControllerConstant = 1.5;

  late Airplane player;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;
  late double gameSizeOfRadius;
  int bulletCount = 0;
  bool isGameOver = false;
  BulletLevel bulletLevel = BulletLevel.easy;
  int gameTime = 0;
  int lastTime = 0;
  int surviveTime = 0;
  late final RouterComponent router;
  late Set<LogicalKeyboardKey> pressedKeySets;

  Training999() : super();

  @override
  bool get pauseWhenBackgrounded => true;

  // 0xFF001030
  // 0xFF000030
  @override
  Color backgroundColor() => const Color(0xFF000000);

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
    pressedKeySets = {};
  }

  void start() {
    isGameOver = false;
    if (!contains(player)) {
      add(player);
    }
    if (!contains(joystickLeft) || !contains(joystickRight)) {
      addJoystick();
    }
    add(TimerComponent(
        period: 1,
        repeat: true,
        autoStart: true,
        removeOnFinish: true,
        onTick: () {
          if (isGameOver) {
            return;
          }
          if (gameTime % 10 == 0) {
            addBullet();
          }

          if (gameTime == 20) {
            bulletLevel = BulletLevel.middle;
            addBullet();
          }

          if (gameTime == 30) {
            bulletLevel = BulletLevel.hard;
            addBullet();
          }
          gameTime++;
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
        period: getPeriodByLevel(),
        repeat: true,
        removeOnFinish: true,
        onTick: () {
          for (var i = 1; i <= 1; i++) {
            var angle = _rng.nextDouble() * 360;
            var radians = angle * pi / 180;
            Vector2 position = Vector2(gameSizeOfRadius * cos(radians),
                    gameSizeOfRadius * sin(radians))
                .translated(size.x / 2, size.y / 2);
            add(Bullet(position, bulletLevel));
          }
        }));
  }

  @override
  void update(double dt) {
    updateJoystick();
    updateKeys();
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

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    if (isGameOver) {
      return KeyEventResult.ignored;
    }

    _clearPressedKeys();
    for (final key in keysPressed) {
      if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
        pressedKeySets.add(key);
      } else if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) {
        pressedKeySets.add(key);
      } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) {
        pressedKeySets.add(key);
      } else if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) {
        pressedKeySets.add(key);
      } else {
        return KeyEventResult.ignored;
      }
    }

    return KeyEventResult.handled;
  }

  void _clearPressedKeys() {
    pressedKeySets.clear();
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
    bulletLevel = BulletLevel.easy;
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
        player.position += Vector2(-_joystickControllerConstant, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-_joystickControllerConstant, -_joystickControllerConstant);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -_joystickControllerConstant);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(_joystickControllerConstant, -_joystickControllerConstant);
        break;
      case JoystickDirection.right:
        player.position += Vector2(_joystickControllerConstant, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(_joystickControllerConstant, _joystickControllerConstant);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, _joystickControllerConstant);
        break;
      case JoystickDirection.downLeft:
        player.position += Vector2(-_joystickControllerConstant, _joystickControllerConstant);
        break;
      default:
        player.position += Vector2(0, 0);
        break;
    }

    switch (joystickRight.direction) {
      case JoystickDirection.left:
        player.position += Vector2(-_joystickControllerConstant, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-_joystickControllerConstant, -_joystickControllerConstant);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -_joystickControllerConstant);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(_joystickControllerConstant, -_joystickControllerConstant);
        break;
      case JoystickDirection.right:
        player.position += Vector2(_joystickControllerConstant, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(_joystickControllerConstant, _joystickControllerConstant);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, _joystickControllerConstant);
        break;
      case JoystickDirection.downLeft:
        player.position += Vector2(-_joystickControllerConstant, _joystickControllerConstant);
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

  void updateKeys() {
    if (isGameOver) {
      return;
    }
    if (pressedKeySets.contains(LogicalKeyboardKey.arrowUp) ||
        pressedKeySets.contains(LogicalKeyboardKey.keyW)) {
      player.position += Vector2(0, -_keyControllerConstant);
    }
    if (pressedKeySets.contains(LogicalKeyboardKey.arrowDown) ||
        pressedKeySets.contains(LogicalKeyboardKey.keyS)) {
      player.position += Vector2(0, _keyControllerConstant);
    }
    if (pressedKeySets.contains(LogicalKeyboardKey.arrowLeft) ||
        pressedKeySets.contains(LogicalKeyboardKey.keyA)) {
      player.position += Vector2(-_keyControllerConstant, 0);
    }
    if (pressedKeySets.contains(LogicalKeyboardKey.arrowRight) ||
        pressedKeySets.contains(LogicalKeyboardKey.keyD)) {
      player.position += Vector2(_keyControllerConstant, 0);
    }
  }

  double getPeriodByLevel() {
    switch (bulletLevel) {
      case BulletLevel.easy:
        return 0.1;
      case BulletLevel.middle:
        return 1.0;
      case BulletLevel.hard:
        return 2.0;
      default:
        return -1.0;
    }
  }
}
