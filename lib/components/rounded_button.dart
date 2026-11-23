import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:training999/art/ui_painter.dart';
import 'package:training999/art/ui_theme.dart';

/// Neon menu button.
class RoundedButton extends PositionComponent
    with TapCallbacks, KeyboardHandler {
  RoundedButton({
    required this.text,
    required this.action,
    this.accent = UiColors.cyan,
    this.hint,
    this.shortcutKeys = const {},
    super.position,
    super.anchor = Anchor.center,
  }) : super(size: Vector2(230, 46));

  final String text;
  final void Function() action;
  final Color accent;

  /// Small text on the right, e.g. a keyboard shortcut.
  final String? hint;

  /// Keys that trigger [action]. Only one button on a page should own a key,
  /// otherwise a single key press triggers several buttons at once.
  final Set<LogicalKeyboardKey> shortcutKeys;

  late final TextPainter _label = UiPainter.layoutText(text,
      fontSize: 20,
      fontWeight: FontWeight.w800,
      glow: accent,
      letterSpacing: 4);
  late final TextPainter? _hint = hint == null
      ? null
      : UiPainter.layoutText(hint!,
          fontSize: 10, color: UiColors.textFaint, letterSpacing: 1);

  bool _pressed = false;

  @override
  void render(Canvas canvas) {
    UiPainter.paintPanel(
      canvas,
      size.toRect(),
      accent: accent,
      radius: size.y / 2,
      fillAlpha: _pressed ? 0.95 : 0.75,
      borderAlpha: _pressed ? 1 : 0.8,
      glow: _pressed ? 1.6 : 1,
    );
    final hint = _hint;
    // With a hint on the right, center the label in the remaining space.
    final labelCenterX =
        hint == null ? size.x / 2 : (size.x - hint.width - 16) / 2 + 8;
    UiPainter.drawText(canvas, _label, Offset(labelCenterX, size.y / 2),
        alignX: 0.5, alignY: 0.5);
    if (hint != null) {
      UiPainter.drawText(canvas, hint, Offset(size.x - 16, size.y / 2),
          alignX: 1, alignY: 0.5);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
    scale = Vector2.all(1.05);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _release();
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _release();
  }

  void _release() {
    _pressed = false;
    scale = Vector2.all(1.0);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyUpEvent && shortcutKeys.contains(event.logicalKey)) {
      action();
      return false;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
