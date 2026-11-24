import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:training999/art/ui_theme.dart';

/// Canvas helpers for the neon HUD (used by Flame components).
class UiPainter {
  UiPainter._();

  /// Font family for HUD text; null uses the platform default. Only tests
  /// set it, to render previews with a known CJK font.
  static String? fontFamily;

  static final Paint _fillPaint = Paint();
  static final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  static final Paint _glowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  /// Translucent dark panel with a neon border and an optional outer glow.
  static void paintPanel(
    Canvas canvas,
    Rect rect, {
    Color accent = UiColors.cyan,
    double radius = 10,
    double fillAlpha = 0.8,
    double borderAlpha = 0.75,
    double glow = 1,
  }) {
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    if (glow > 0) {
      _glowPaint.color = accent.withValues(alpha: 0.35 * glow);
      canvas.drawRRect(rrect, _glowPaint);
    }
    _fillPaint.shader = ui.Gradient.linear(
      rect.topCenter,
      rect.bottomCenter,
      [
        UiColors.panelTop.withValues(alpha: fillAlpha),
        UiColors.panelBottom.withValues(alpha: fillAlpha),
      ],
    );
    canvas.drawRRect(rrect, _fillPaint);
    _borderPaint.color = accent.withValues(alpha: borderAlpha);
    canvas.drawRRect(rrect, _borderPaint);
  }

  /// Lays out [text]; reuse the result when the text does not change.
  static TextPainter layoutText(
    String text, {
    required double fontSize,
    Color color = UiColors.text,
    FontWeight fontWeight = FontWeight.w600,
    Color? glow,
    double letterSpacing = 0,
    bool tabular = false,
  }) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          shadows: glow == null ? null : neonGlow(glow),
          fontFeatures: tabular ? tabularFigures : null,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  /// Paints [painter] with its anchor point ([alignX], [alignY] in 0..1 of
  /// the text box) at [position].
  static void drawText(Canvas canvas, TextPainter painter, Offset position,
      {double alignX = 0, double alignY = 0}) {
    painter.paint(
      canvas,
      position - Offset(painter.width * alignX, painter.height * alignY),
    );
  }
}
