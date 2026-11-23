import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/art/ui_theme.dart';

/// Short announcement that floats up and fades out, then removes itself.
class InfoTextComponent extends TextComponent {
  InfoTextComponent(
    String text,
    Vector2 position, {
    this.color = Colors.white,
    this.fontSize = 22,
    this.duration = 1.2,
    this.floatDistance = 16,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.topCenter,
          priority: 120,
        );

  final Color color;
  final double fontSize;

  /// Fade-out duration in seconds.
  final double duration;

  /// Pixels the text moves up while fading.
  final double floatDistance;

  double _elapsed = 0;
  late final double _startY = position.y;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _applyStyle(1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    if (progress >= 1) {
      removeFromParent();
      return;
    }
    // Stay fully visible for the first 40%, then fade out.
    final opacity = progress < 0.4 ? 1.0 : 1 - (progress - 0.4) / 0.6;
    position.y = _startY - floatDistance * Curves.easeOut.transform(progress);
    _applyStyle(opacity);
  }

  void _applyStyle(double opacity) {
    final glow = color == Colors.white ? UiColors.cyan : color;
    textRenderer = TextPaint(
      style: TextStyle(
        color: color.withValues(alpha: opacity),
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        shadows: neonGlow(glow.withValues(alpha: opacity)),
      ),
    );
  }
}
