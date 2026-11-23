import 'dart:math';
import 'dart:ui';

/// Glowing bullet visuals. All paints are built once with shaders centered at
/// the origin; callers translate / rotate the canvas instead, so drawing
/// hundreds of bullets per frame stays cheap.
class BulletPainter {
  BulletPainter._();

  static final Map<(int, double), _OrbPaints> _orbCache = {};
  static final Map<(int, double, double), Paint> _trailCache = {};

  /// A round glowing orb: soft additive halo plus a hot white core.
  static void paintOrb(
      Canvas canvas, Offset center, double coreRadius, Color color,
      {double haloScale = 3.2, double pulse = 1.0}) {
    final paints = _orbCache.putIfAbsent((color.toARGB32(), coreRadius),
        () => _OrbPaints(coreRadius, color, haloScale));
    canvas
      ..save()
      ..translate(center.dx, center.dy);
    if (pulse != 1.0) {
      canvas.scale(pulse);
    }
    canvas.drawCircle(Offset.zero, coreRadius * haloScale, paints.halo);
    canvas.restore();
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..drawCircle(Offset.zero, coreRadius, paints.core)
      ..restore();
  }

  /// A fading streak behind a moving bullet, pointing along [angle].
  static void paintTrail(Canvas canvas, Offset center, double angle,
      double length, double width, Color color) {
    final paint = _trailCache.putIfAbsent(
        (color.toARGB32(), length, width),
        () => Paint()
          ..blendMode = BlendMode.plus
          ..shader = Gradient.linear(
            Offset(-length, 0),
            Offset.zero,
            [color.withValues(alpha: 0), color.withValues(alpha: 0.75)],
          ));
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(angle)
      ..drawRRect(
          RRect.fromLTRBR(
              -length, -width / 2, 0, width / 2, Radius.circular(width / 2)),
          paint)
      ..restore();
  }

  static final Paint _starPaint = Paint()..blendMode = BlendMode.plus;

  /// A rotating four-point star, used for homing bullets.
  static void paintStar(Canvas canvas, Offset center, double radius,
      double rotation, Color color) {
    _starPaint.color = color.withValues(alpha: 0.9);
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final r = i.isEven ? radius : radius * 0.28;
      final a = rotation + i * pi / 4;
      final point = Offset(cos(a) * r, sin(a) * r);
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..drawPath(path, _starPaint)
      ..restore();
  }
}

class _OrbPaints {
  _OrbPaints(double coreRadius, Color color, double haloScale)
      : halo = Paint()
          ..blendMode = BlendMode.plus
          ..shader = Gradient.radial(
            Offset.zero,
            coreRadius * haloScale,
            [
              color.withValues(alpha: 0.55),
              color.withValues(alpha: 0.18),
              color.withValues(alpha: 0),
            ],
            const [0.0, 0.45, 1.0],
          ),
        core = Paint()
          ..shader = Gradient.radial(
            Offset.zero,
            coreRadius,
            [
              const Color(0xFFFFFFFF),
              Color.lerp(color, const Color(0xFFFFFFFF), 0.35)!,
              color,
            ],
            const [0.0, 0.5, 1.0],
          );

  final Paint halo;
  final Paint core;
}
