import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:training999/components/rounded_button.dart';
import 'package:training999/training_999.dart';

class MenuPage extends Component with HasGameReference<Training999> {

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
      _button1 = RoundedButton(
        text: '開始遊戲',
        action: () {
          remove(_logo);
          remove(_button1);
          game.start();
        },
        color: const Color(0xffadde6c),
        borderColor: const Color(0xffedffab),
      )
    ]);
  }

  late final TextComponent _logo;
  late final RoundedButton _button1;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
  }

  @override
  bool containsPoint(Vector2 point) => true;
}
