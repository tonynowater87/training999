import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:training999/art/bullet_painter.dart';
import 'package:training999/art/ship_painter.dart';

void main() {
  test('ship hull is symmetric around the center line', () {
    final xs = shipHullPoints.map((p) => p.$1).toList();
    for (final (x, y) in shipHullPoints) {
      final mirrored = shipWidth - x;
      expect(
        shipHullPoints.any((p) => p.$1 == mirrored && p.$2 == y),
        isTrue,
        reason: 'missing mirror of ($x, $y)',
      );
    }
    expect(xs.reduce((a, b) => a < b ? a : b), greaterThanOrEqualTo(0));
    expect(xs.reduce((a, b) => a > b ? a : b), lessThanOrEqualTo(shipWidth));
  });

  test('painters draw without throwing', () {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    for (var t = 0.0; t < 2; t += 0.25) {
      ShipPainter.paint(canvas, t);
    }
    const color = Color(0xFFFF9800);
    BulletPainter.paintOrb(canvas, Offset.zero, 2, color);
    BulletPainter.paintOrb(canvas, Offset.zero, 2, color, pulse: 1.2);
    BulletPainter.paintTrail(canvas, Offset.zero, 1, 14, 4, color);
    BulletPainter.paintStar(canvas, Offset.zero, 7, 0.5, color);
    expect(recorder.endRecording(), isNotNull);
  });
}
