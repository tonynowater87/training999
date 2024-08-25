import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:training999/components/airplane.dart';

class Training999 extends FlameGame
    with DragCallbacks, HasKeyboardHandlerComponents {
  late Airplane _player;
  late JoystickComponent joystickLeft;
  late JoystickComponent joystickRight;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future onLoad() async {
    await images.loadAllImages();
    add(_player = Airplane());
    addJoystick();
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
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
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
      margin: const EdgeInsets.only(right: 32, bottom: 32),
    );
    add(joystickRight);
  }

  void updateJoystick() {
    switch (joystickLeft.direction) {
      case JoystickDirection.left:
        _player.position += Vector2(-1, 0);
        break;
      case JoystickDirection.upLeft:
        _player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        _player.position += Vector2(0, -1);
        break;
      case JoystickDirection.upRight:
        _player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        _player.position += Vector2(1, 0);
        break;
      case JoystickDirection.downRight:
        _player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        _player.position += Vector2(0, 1);
        break;
      case JoystickDirection.downLeft:
        _player.position += Vector2(-0.75, 0.75);
        break;
      default:
        _player.position += Vector2(0, 0);
        break;
    }

    switch (joystickRight.direction) {
      case JoystickDirection.left:
        _player.position += Vector2(-1, 0);
        break;
      case JoystickDirection.upLeft:
        _player.position += Vector2(-0.75, -0.75);
        break;
      case JoystickDirection.up:
        _player.position += Vector2(0, -1);
        break;
      case JoystickDirection.upRight:
        _player.position += Vector2(0.75, -0.75);
        break;
      case JoystickDirection.right:
        _player.position += Vector2(1, 0);
        break;
      case JoystickDirection.downRight:
        _player.position += Vector2(0.75, 0.75);
        break;
      case JoystickDirection.down:
        _player.position += Vector2(0, 1);
        break;
      case JoystickDirection.downLeft:
        _player.position += Vector2(-0.75, 0.75);
        break;
      default:
        _player.position += Vector2(0, 0);
        break;
    }
    _player.position +=
        joystickLeft.relativeDelta + joystickRight.relativeDelta;
  }
}
