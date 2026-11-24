import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:training999/art/ui_painter.dart';
import 'package:training999/art/ui_theme.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/item_type.dart';

/// Bottom-center HUD: current graze points and one button per item.
class ItemBar extends PositionComponent with HasGameReference<Training999> {
  static const double _buttonWidth = 64;
  static const double _buttonHeight = 46;
  static const double _gap = 8;
  static const double _bottomMargin = 12;
  static const double _pointsHeight = 22;

  ItemBar()
      : super(
          anchor: Anchor.bottomCenter,
          priority: 10,
          size: Vector2(
            ItemType.values.length * (_buttonWidth + _gap) - _gap,
            _buttonHeight + _pointsHeight,
          ),
        );

  final TextPainter _pointsLabel = UiPainter.layoutText('擦彈點數',
      fontSize: 11, color: UiColors.textDim, letterSpacing: 1);
  int _lastPoints = -1;
  late TextPainter _points;

  @override
  Future<void> onLoad() async {
    for (final type in ItemType.values) {
      add(ItemButton(
        type,
        position: Vector2(type.index * (_buttonWidth + _gap), _pointsHeight),
        size: Vector2(_buttonWidth, _buttonHeight),
      ));
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, size.y - _bottomMargin);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.grazePoints != _lastPoints) {
      _lastPoints = game.grazePoints;
      _points = UiPainter.layoutText('$_lastPoints',
          fontSize: 16,
          fontWeight: FontWeight.w800,
          glow: UiColors.cyan,
          tabular: true);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_lastPoints < 0) {
      return;
    }
    final totalWidth = _pointsLabel.width + 6 + _points.width;
    final left = size.x / 2 - totalWidth / 2;
    UiPainter.drawText(canvas, _pointsLabel, Offset(left, 10), alignY: 0.5);
    UiPainter.drawText(
        canvas, _points, Offset(left + _pointsLabel.width + 6, 10),
        alignY: 0.5);
  }
}

class ItemButton extends PositionComponent
    with TapCallbacks, HasGameReference<Training999> {
  ItemButton(this.type, {super.position, super.size});

  final ItemType type;

  late final TextPainter _labelOn = UiPainter.layoutText(type.label,
      fontSize: 16, fontWeight: FontWeight.w800, glow: type.color);
  late final TextPainter _labelOff = UiPainter.layoutText(type.label,
      fontSize: 16, fontWeight: FontWeight.w800, color: UiColors.textFaint);
  late final TextPainter _costOn = UiPainter.layoutText(
      '${type.shortcutLabel} · ${type.cost}點',
      fontSize: 10,
      color: type.color);
  late final TextPainter _costOff = UiPainter.layoutText(
      '${type.shortcutLabel} · ${type.cost}點',
      fontSize: 10,
      color: UiColors.textFaint);
  final Paint _progressPaint = Paint();

  @override
  void render(Canvas canvas) {
    final usable = game.canUseItem(type);
    final active = game.itemActiveRatio(type);
    UiPainter.paintPanel(
      canvas,
      size.toRect(),
      accent: active > 0 ? UiColors.text : type.color,
      radius: 8,
      fillAlpha: 0.7,
      borderAlpha: usable || active > 0 ? 0.95 : 0.25,
      glow: usable ? 1 : (active > 0 ? 0.8 : 0),
    );
    UiPainter.drawText(canvas, usable || active > 0 ? _labelOn : _labelOff,
        Offset(size.x / 2, size.y * 0.4),
        alignX: 0.5, alignY: 0.5);
    UiPainter.drawText(
        canvas, usable ? _costOn : _costOff, Offset(size.x / 2, size.y * 0.78),
        alignX: 0.5, alignY: 0.5);

    // Remaining duration of an active effect.
    if (active > 0) {
      _progressPaint.color = type.color;
      canvas.drawRRect(
          RRect.fromLTRBR(6, size.y - 5, 6 + (size.x - 12) * active, size.y - 3,
              const Radius.circular(1)),
          _progressPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.useItem(type);
  }
}
