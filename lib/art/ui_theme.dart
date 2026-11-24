import 'dart:ui';

/// Shared neon palette for Flame HUD components and Flutter overlays.
class UiColors {
  UiColors._();

  static const Color background = Color(0xFF001030);
  static const Color cyan = Color(0xFF66E0FF);
  static const Color pink = Color(0xFFFF4D8D);
  static const Color gold = Color(0xFFFFD54F);
  static const Color silver = Color(0xFFCFD8DC);
  static const Color bronze = Color(0xFFFFAB76);
  static const Color panelTop = Color(0xFF13234A);
  static const Color panelBottom = Color(0xFF060B1E);
  static const Color text = Color(0xFFFFFFFF);
  static const Color textDim = Color(0xB3FFFFFF);
  static const Color textFaint = Color(0x66FFFFFF);
}

/// Soft neon glow for text.
List<Shadow> neonGlow(Color color, {double blur = 8}) => [
      Shadow(color: color.withValues(alpha: 0.9), blurRadius: blur / 2),
      Shadow(color: color.withValues(alpha: 0.6), blurRadius: blur),
    ];

/// Keeps digits the same width, so changing numbers do not jitter.
const List<FontFeature> tabularFigures = [FontFeature.tabularFigures()];
