import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:training999/components/has_opacity_provider.dart';
import 'package:training999/training_999.dart';

// TODO show multiple text and not cover each other
class InfoTextComponent extends TextComponent
    with HasGameRef<Training999>, HasOpacityProvider {
  InfoTextComponent(String text, Vector2 position)
      : super(
          position: position,
          text: text,
          textRenderer: TextPaint(
              style: const TextStyle(color: Colors.white, fontSize: 24)),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.topCenter;
    add(OpacityEffect.fadeOut(LinearEffectController(1.0), onComplete: () {
      removeFromParent(); // 淡出完成後移除組件
    }));
  }
}
