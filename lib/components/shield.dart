import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:training999/util/item_type.dart';

/// Ring drawn around the airplane while a shield is active.
class ShieldComponent extends CircleComponent {
  ShieldComponent({required Vector2 parentSize})
      : super(
          radius: parentSize.length / 2,
          anchor: Anchor.center,
          position: parentSize / 2,
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = ItemType.shield.color,
        );

  double _time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    // Gentle pulse so the shield reads as "active".
    _time += dt;
    final pulse = 0.6 + 0.4 * (0.5 + 0.5 * sin(_time * 6));
    paint.color = ItemType.shield.color.withValues(alpha: pulse);
  }
}
