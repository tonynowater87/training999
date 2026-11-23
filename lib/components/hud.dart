import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/ui_painter.dart';
import 'package:training999/art/ui_theme.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/time_utils.dart';

/// Top-left panel: survive time, current title and brilliant dodges.
class HudComponent extends PositionComponent
    with HasGameReference<Training999> {
  HudComponent()
      : super(position: Vector2(12, 10), size: Vector2(220, 74), priority: 10);

  final TextPainter _timeLabel = UiPainter.layoutText('TIME',
      fontSize: 10,
      color: UiColors.cyan,
      fontWeight: FontWeight.w800,
      letterSpacing: 2);
  final TextPainter _secondsLabel =
      UiPainter.layoutText('秒', fontSize: 12, color: UiColors.textDim);

  String _lastTime = '';
  String _lastTitle = '';
  int _lastDodges = -1;
  late TextPainter _time;
  late TextPainter _title;
  late TextPainter _dodges;

  @override
  void update(double dt) {
    super.update(dt);
    // Re-layout only when the text changed.
    final time = formatMilliseconds(game.surviveTime);
    if (time != _lastTime) {
      _lastTime = time;
      _time = UiPainter.layoutText(time,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          glow: UiColors.cyan,
          tabular: true);
    }
    final title = game.currentFullTitle;
    if (title != _lastTitle) {
      _lastTitle = title;
      _title = UiPainter.layoutText('「$title」',
          fontSize: 13, color: UiColors.gold, glow: UiColors.gold);
    }
    final dodges = game.brilliantlyDodgedTheBullet;
    if (dodges != _lastDodges) {
      _lastDodges = dodges;
      _dodges = UiPainter.layoutText('絕妙度 $dodges',
          fontSize: 11, color: UiColors.textDim, tabular: true);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_lastTime.isEmpty) {
      return;
    }
    UiPainter.paintPanel(canvas, size.toRect(), fillAlpha: 0.55, glow: 0.6);
    UiPainter.drawText(canvas, _timeLabel, const Offset(12, 8));
    UiPainter.drawText(canvas, _time, const Offset(12, 18));
    UiPainter.drawText(canvas, _secondsLabel, Offset(16 + _time.width, 30));
    UiPainter.drawText(canvas, _dodges, Offset(size.x - 12, 10), alignX: 1);
    // Long titles are scaled down to fit the panel.
    final maxWidth = size.x - 16;
    final scale = _title.width > maxWidth ? maxWidth / _title.width : 1.0;
    canvas
      ..save()
      ..translate(8, size.y - 8)
      ..scale(scale);
    UiPainter.drawText(canvas, _title, Offset.zero, alignY: 1);
    canvas.restore();
  }
}
