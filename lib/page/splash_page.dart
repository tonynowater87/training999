import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/rendering.dart';
import 'package:training999/training_999.dart';

class SplashPage extends Component with HasGameReference<Training999>, TapCallbacks {

  late TextComponent _logo;

  @override
  Future<void> onLoad() async {
    addAll([
      _logo = TextComponent(
        text: '特訓999',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
        anchor: Anchor.center,
      ),
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  @override
  void onGameResize(Vector2 size) {
    _logo.position = Vector2(size.x / 2, size.y / 3);
    super.onGameResize(size);
  }

  @override
  void onMount() {
    remove(_logo);
    game.router.pushNamed('menu');
    super.onMount();
  }

  @override
  void onTapUp(TapUpEvent event) {
    remove(_logo);
    game.router.pushNamed('menu');
    super.onTapUp(event);
  }
}
