import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:training999/components/airplane.dart';
import 'package:training999/components/bullet.dart';
import 'package:training999/components/debug_circle.dart';
import 'package:training999/components/space.dart';

class Training999 extends FlameGame
    with DragCallbacks, HasKeyboardHandlerComponents {
  late Airplane player;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;
  final Random _rng = Random();
  late double gameSizeOfRadius;

  Training999()
      : super(
            camera: CameraComponent(
                viewport: FixedAspectRatioViewport(aspectRatio: 1 / 1)),
            world: Space());

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future onLoad() async {
    await images.loadAllImages();
    gameSizeOfRadius = pow(
            pow(camera.viewport.size.x, 2) + pow(camera.viewport.size.y, 2),
            0.5) /
        4.0;

    add(player = Airplane());
    add(DebugCircle(gameSizeOfRadius));
    addJoystick();
    addBullet();
  }

  void addBullet() {
    var random1 = Vector2.random(_rng);
    var random2 = Vector2.random(_rng);
    final velocity = (random1 - random2) * 80;

    for (var i = 0; i <= 10; i++) {
      add(Bullet(velocity, 0 + ((360 / 11) * i * pi) / 180, 'Bullet $i'));
    }
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
        player.position += Vector2(-1, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -1);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        player.position += Vector2(1, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, 1);
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
        player.position += Vector2(-1, 0);
        break;
      case JoystickDirection.upLeft:
        player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        player.position += Vector2(0, -1);
        break;
      case JoystickDirection.upRight:
        player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        player.position += Vector2(1, 0);
        break;
      case JoystickDirection.downRight:
        player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        player.position += Vector2(0, 1);
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
