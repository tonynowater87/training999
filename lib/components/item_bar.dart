import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:training999/training_999.dart';
import 'package:training999/util/item_type.dart';

/// Bottom-center HUD: current graze points and one button per item.
class ItemBar extends PositionComponent with HasGameReference<Training999> {
  static const double _buttonWidth = 64;
  static const double _buttonHeight = 44;
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

  late final TextComponent _pointsText;

  @override
  Future<void> onLoad() async {
    _pointsText = TextComponent(
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 0),
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
    add(_pointsText);
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
    _pointsText.text = '擦彈點數 ${game.grazePoints}';
  }
}

class ItemButton extends PositionComponent
    with TapCallbacks, HasGameReference<Training999> {
  ItemButton(this.type, {super.position, super.size});

  final ItemType type;

  static final TextPaint _labelPaint = TextPaint(
    style: const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
  );
  static final TextPaint _costPaint = TextPaint(
    style: const TextStyle(color: Colors.black87, fontSize: 11),
  );

  late final RRect _rrect =
      RRect.fromLTRBR(0, 0, size.x, size.y, const Radius.circular(8));
  final Paint _bgPaint = Paint();
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _progressPaint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    final usable = game.canUseItem(type);
    final active = game.itemActiveRatio(type);
    _bgPaint.color = type.color.withValues(alpha: usable ? 0.95 : 0.3);
    _borderPaint.color = active > 0 ? Colors.white : type.color;
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);

    _labelPaint.render(canvas, type.label, Vector2(size.x / 2, size.y * 0.4),
        anchor: Anchor.center);
    _costPaint.render(canvas, '[${type.shortcutLabel}] ${type.cost}點',
        Vector2(size.x / 2, size.y * 0.78),
        anchor: Anchor.center);

    // Remaining duration of an active effect.
    if (active > 0) {
      canvas.drawRect(Rect.fromLTWH(4, size.y - 4, (size.x - 8) * active, 2),
          _progressPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.useItem(type);
  }
}
