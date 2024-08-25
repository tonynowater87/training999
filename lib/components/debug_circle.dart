import 'dart:ui';

import 'package:flame/components.dart';
import 'package:training999/training_999.dart';

class DebugCircle extends CircleComponent with HasGameRef<Training999> {
  DebugCircle(radius)
      : super(
            radius: radius,
            paint: Paint()
              ..color = const Color(0xFF0000FF)
              ..style = PaintingStyle.stroke, anchor: Anchor.center);

  @override
  void onMount() {
    position = game.canvasSize / 2;
  }
}
