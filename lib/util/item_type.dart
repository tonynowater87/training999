import 'package:flutter/services.dart';
import 'package:training999/util/music_manager.dart';

/// Items bought with graze points (one point per brilliant dodge).
enum ItemType {
  shield(
    label: '護盾',
    cost: 8,
    duration: 0,
    color: Color(0xFF66E0FF),
    sfx: Sfx.shieldOn,
    announcement: '護盾展開!',
  ),
  bomb(
    label: '清屏',
    cost: 12,
    duration: 0,
    color: Color(0xFFFF7043),
    sfx: Sfx.bomb,
    announcement: '清屏炸彈!',
  ),
  slow(
    label: '減速',
    cost: 5,
    duration: 4,
    color: Color(0xFFB388FF),
    sfx: Sfx.slow,
    announcement: '子彈減速!',
  ),
  shrink(
    label: '縮小',
    cost: 5,
    duration: 5,
    color: Color(0xFF69F0AE),
    sfx: Sfx.shrink,
    announcement: '機體縮小!',
  );

  const ItemType({
    required this.label,
    required this.cost,
    required this.duration,
    required this.color,
    required this.sfx,
    required this.announcement,
  });

  final String label;

  /// Graze points needed to use this item.
  final int cost;

  /// Effect duration in seconds; 0 for instant / until-consumed items.
  final double duration;
  final Color color;
  final Sfx sfx;
  final String announcement;

  /// Keyboard shortcut: 1, 2, 3, 4 in declaration order.
  LogicalKeyboardKey get shortcutKey => const [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.digit4,
      ][index];

  String get shortcutLabel => '${index + 1}';
}

/// Bullets move at this fraction of their speed while [ItemType.slow] is on.
const double slowBulletTimeScale = 0.4;

/// Player scale while [ItemType.shrink] is on.
const double shrinkPlayerScale = 0.5;

/// Invincibility after the shield absorbed a hit, in seconds.
const double shieldInvincibleDuration = 1.0;
