import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ParticleBackground extends Component with HasGameRef {
  final Random _random = Random();
  double _emissionTimer = 0;
  final double _emissionRate = 0.2;
  final int _particlesPerBurst = 6;

  @override
  void update(double dt) {
    super.update(dt);
    _emissionTimer += dt;

    while (_emissionTimer > _emissionRate) {
      _emitParticleBurst();
      _emissionTimer -= _emissionRate;
    }
  }

  void _emitParticleBurst() {
    final gameSize = gameRef.size;
    if (gameSize.x == 0 || gameSize.y == 0) return;

    final baseX = _random.nextDouble() * gameSize.x;
    final baseY = gameSize.y + 10;

    final colors = [
      const Color(0xFFFF6B35),
      const Color(0xFFFFB627),
      const Color(0xFFF7931E),
      const Color(0xFFE6B428),
    ];

    final particle = Particle.generate(
      count: _particlesPerBurst,
      lifespan: 2.5,
      generator: (i) {
        final dx = (_random.nextDouble() - 0.5) * 30;
        final dy = -_random.nextDouble() * 80 - 20;
        final color = colors[_random.nextInt(colors.length)]
            .withOpacity(0.25 + _random.nextDouble() * 0.5);

        return AcceleratedParticle(
          acceleration: Vector2(0, 15),
          speed: Vector2(dx, dy),
          position: Vector2(baseX, baseY),
          child: CircleParticle(
            radius: 2 + _random.nextDouble() * 3,
            paint: Paint()
              ..color = color
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
          ),
        );
      },
    );

    add(ParticleSystemComponent(particle: particle));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final gameSize = gameRef.size;
    if (gameSize.x <= 0 || gameSize.y <= 0) return;

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        const Color(0xFF1E1E1E).withOpacity(0.5),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, gameSize.x, gameSize.y);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }
}
