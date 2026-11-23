import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/ui_painter.dart';
import 'package:training999/art/ui_theme.dart';

/// Game title with a neon glow and a slow breathing pulse.
class LogoComponent extends PositionComponent {
  LogoComponent({super.position})
      : super(size: Vector2(320, 100), anchor: Anchor.center);

  final TextPainter _title = UiPainter.layoutText('特訓999',
      fontSize: 64,
      fontWeight: FontWeight.w900,
      color: const Color(0xFFE8FFFB),
      glow: UiColors.cyan,
      letterSpacing: 6);
  final TextPainter _subtitle = UiPainter.layoutText('BULLET DODGE TRAINING',
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: UiColors.cyan,
      letterSpacing: 6);
  final Paint _linePaint = Paint()
    ..color = UiColors.cyan.withValues(alpha: 0.5)
    ..strokeWidth = 1;

  @override
  Future<void> onLoad() async {
    add(ScaleEffect.to(
      Vector2.all(1.03),
      EffectController(
        duration: 1.4,
        reverseDuration: 1.4,
        infinite: true,
        curve: Curves.easeInOut,
      ),
    ));
  }

  @override
  void render(Canvas canvas) {
    UiPainter.drawText(canvas, _title, Offset(size.x / 2, 42),
        alignX: 0.5, alignY: 0.5);
    const lineY = 84.0;
    final half = _subtitle.width / 2 + 12;
    canvas
      ..drawLine(Offset(size.x / 2 - half - 40, lineY),
          Offset(size.x / 2 - half, lineY), _linePaint)
      ..drawLine(Offset(size.x / 2 + half, lineY),
          Offset(size.x / 2 + half + 40, lineY), _linePaint);
    UiPainter.drawText(canvas, _subtitle, Offset(size.x / 2, lineY),
        alignX: 0.5, alignY: 0.5);
  }
}
