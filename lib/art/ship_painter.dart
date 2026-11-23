import 'dart:math';
import 'dart:ui';

/// Hull outline of the player's ship in local coordinates (32 x 39 box).
/// The same polygon is used for drawing and for the collision hitbox, so what
/// the player sees is exactly what can be hit.
final List<Vector2Like> shipHullPoints = [
  (16, 0), (12, 7), (12, 12), (10, 13), (10, 17), (2, 24), (2, 27), //
  (4, 27), (9, 25), (13, 25), (13, 29), (19, 29), (19, 25), (23, 25), //
  (28, 27), (30, 27), (30, 24), (22, 17), (22, 13), (20, 12), (20, 7),
];

typedef Vector2Like = (double, double);

const double shipWidth = 32;
const double shipHeight = 39;

/// Draws the ship with metallic shading, cockpit glass, wing stripes,
/// blinking wingtip lights and an animated engine flame.
class ShipPainter {
  ShipPainter._();

  static final Path _hull = _buildHull();

  static final Paint _hullPaint = Paint()
    ..shader = Gradient.linear(
      const Offset(2, 0),
      const Offset(30, 0),
      const [
        Color(0xFF26324A),
        Color(0xFF8EA2C4),
        Color(0xFFE4ECF8),
        Color(0xFF8EA2C4),
        Color(0xFF26324A),
      ],
      const [0.0, 0.3, 0.5, 0.7, 1.0],
    );

  static final Paint _hullShadePaint = Paint()
    ..shader = Gradient.linear(
      const Offset(0, 0),
      const Offset(0, 29),
      const [Color(0x00000000), Color(0x66000000)],
    );

  static final Paint _outlinePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..strokeJoin = StrokeJoin.round
    ..color = const Color(0xFF0A1020);

  static final Paint _stripePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFFFF4D6A);

  static final Paint _spinePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8
    ..color = const Color(0x55FFFFFF);

  static final Paint _cockpitPaint = Paint()
    ..shader = Gradient.linear(
      const Offset(16, 5),
      const Offset(16, 15),
      const [Color(0xFF9FF3FF), Color(0xFF1C5BB8), Color(0xFF0B1E4A)],
      const [0.0, 0.55, 1.0],
    );

  static final Paint _glintPaint = Paint()..color = const Color(0xCCFFFFFF);

  static final Paint _nozzlePaint = Paint()..color = const Color(0xFF3A4152);

  static final Paint _flameGlowPaint = Paint()
    ..blendMode = BlendMode.plus
    ..shader = Gradient.radial(
      const Offset(16, 31),
      9,
      const [Color(0x8840C8FF), Color(0x0040C8FF)],
    );

  static final Paint _flamePaint = Paint()..blendMode = BlendMode.plus;

  static final Paint _lightPaint = Paint()..blendMode = BlendMode.plus;

  static Path _buildHull() {
    final path = Path()
      ..moveTo(shipHullPoints.first.$1, shipHullPoints.first.$2);
    for (final (x, y) in shipHullPoints.skip(1)) {
      path.lineTo(x, y);
    }
    return path..close();
  }

  /// [time] is in seconds and drives the flame flicker and light blink.
  static void paint(Canvas canvas, double time) {
    _paintFlame(canvas, time);

    canvas.drawPath(_hull, _hullPaint);
    canvas.drawPath(_hull, _hullShadePaint);

    // Wing stripes and spine highlight.
    canvas.drawLine(
        const Offset(4, 25.5), const Offset(10.5, 19), _stripePaint);
    canvas.drawLine(
        const Offset(28, 25.5), const Offset(21.5, 19), _stripePaint);
    canvas.drawLine(const Offset(16, 15), const Offset(16, 27), _spinePaint);

    // Cockpit glass with a small glint.
    canvas.drawOval(const Rect.fromLTWH(13.5, 5, 5, 10), _cockpitPaint);
    canvas.drawOval(const Rect.fromLTWH(14.6, 6.4, 1.4, 3), _glintPaint);

    canvas.drawRect(const Rect.fromLTWH(13.5, 27.5, 5, 1.5), _nozzlePaint);
    canvas.drawPath(_hull, _outlinePaint);

    _paintWingLights(canvas, time);
  }

  static void _paintFlame(Canvas canvas, double time) {
    final flicker = 0.75 + 0.25 * sin(time * 40) * sin(time * 23 + 1);
    final length = 7 + 4 * flicker;
    canvas.drawCircle(const Offset(16, 31), 9, _flameGlowPaint);

    _flamePaint.shader = Gradient.linear(
      const Offset(16, 28.5),
      Offset(16, 28.5 + length),
      const [Color(0xFFFFFFFF), Color(0xFF7FE9FF), Color(0x002A7BFF)],
      const [0.0, 0.35, 1.0],
    );
    final flame = Path()
      ..moveTo(13.5, 28.5)
      ..quadraticBezierTo(14, 28.5 + length * 0.6, 16, 28.5 + length)
      ..quadraticBezierTo(18, 28.5 + length * 0.6, 18.5, 28.5)
      ..close();
    canvas.drawPath(flame, _flamePaint);
  }

  static void _paintWingLights(Canvas canvas, double time) {
    final on = (time * 2).floor().isEven;
    final alpha = on ? 0.95 : 0.25;
    _lightPaint.color = Color.fromRGBO(255, 70, 90, alpha);
    canvas.drawCircle(const Offset(3, 25.5), 1.1, _lightPaint);
    _lightPaint.color = Color.fromRGBO(80, 255, 140, alpha);
    canvas.drawCircle(const Offset(29, 25.5), 1.1, _lightPaint);
  }
}
