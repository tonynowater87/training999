import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:training999/training_999.dart';

/// Explosion sprite plus additive sparks and an expanding shockwave ring.
class ExplosionComponent extends SpriteAnimationComponent
    with HasGameReference<Training999> {
  ExplosionComponent({super.position})
      : super(
            size: Vector2.all(50),
            anchor: Anchor.center,
            removeOnFinish: false,
            priority: 200);

  static const int _sparkCount = 36;
  static const double _sparkLifespan = 0.8;
  static const List<Color> _sparkColors = [
    Color(0xFFFFFFFF),
    Color(0xFFFFF176),
    Color(0xFFFFB74D),
    Color(0xFFFF7043),
  ];

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.1,
        amount: 6,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    game
      ..add(ParticleSystemComponent(
        position: position.clone(),
        priority: priority - 1,
        particle: _sparks(),
      ))
      ..add(_shockwave());
  }

  Particle _sparks() {
    final rng = Random();
    return Particle.generate(
      count: _sparkCount,
      lifespan: _sparkLifespan,
      generator: (i) {
        final angle = rng.nextDouble() * 2 * pi;
        final speed = 60 + rng.nextDouble() * 220;
        final direction = Vector2(cos(angle), sin(angle));
        final color = _sparkColors[i % _sparkColors.length];
        final paint = Paint()..blendMode = BlendMode.plus;
        return AcceleratedParticle(
          speed: direction * speed,
          // Drag: slow down to almost zero by the end of the lifespan.
          acceleration: direction * (-speed / _sparkLifespan * 0.9),
          child: ComputedParticle(renderer: (canvas, particle) {
            final life = 1 - particle.progress;
            paint.color = color.withValues(alpha: life);
            canvas.drawCircle(Offset.zero, 0.5 + 1.8 * life, paint);
          }),
        );
      },
    );
  }

  Component _shockwave() {
    final ring = CircleComponent(
      radius: 6,
      anchor: Anchor.center,
      position: position.clone(),
      priority: priority - 1,
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xCCFFE0B2),
    );
    ring.addAll([
      ScaleEffect.to(
        Vector2.all(7),
        EffectController(duration: 0.45, curve: Curves.easeOut),
      ),
      OpacityEffect.fadeOut(
        EffectController(duration: 0.45),
        onComplete: ring.removeFromParent,
      ),
    ]);
    return ring;
  }
}
