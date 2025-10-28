import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Particle extends PositionComponent with HasGameRef {
  final Vector2 velocity;
  final double maxLifetime;
  double lifetime = 0;
  final Color color;

  Particle({
    required Vector2 position,
    required this.velocity,
    required this.maxLifetime,
    required this.color,
  }) : super(
          position: position,
          size: Vector2(4, 4),
        );

  @override
  void update(double dt) {
    super.update(dt);
    lifetime += dt;
    position += velocity * dt;

    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double opacityValue = 1 - (lifetime / maxLifetime);
    opacityValue = opacityValue.clamp(0.0, 1.0);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()
        ..color = color.withOpacity(opacityValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }
}

class ParticleBackground extends Component with HasGameRef {
  final Random random = Random();
  double emissionTimer = 0;
  final double emissionRate = 0.05;

  @override
  void update(double dt) {
    super.update(dt);
    emissionTimer += dt;

    while (emissionTimer > emissionRate) {
      _emitParticle();
      emissionTimer -= emissionRate;
    }
  }

  void _emitParticle() {
    final gameSize = gameRef.size;
    if (gameSize.x == 0 || gameSize.y == 0) return;

    final startX = random.nextDouble() * gameSize.x;
    final startY = gameSize.y + 10;

    final velocityX = (random.nextDouble() - 0.5) * 50;
    final velocityY = -random.nextDouble() * 80 - 40;

    final colors = [
      const Color(0xFFFF6B35).withOpacity(0.7),
      const Color(0xFFFFB627).withOpacity(0.7),
      const Color(0xFFF7931E).withOpacity(0.6),
      const Color(0xFFE6B428).withOpacity(0.6),
    ];

    final particle = Particle(
      position: Vector2(startX, startY),
      velocity: Vector2(velocityX, velocityY),
      maxLifetime: random.nextDouble() * 2 + 1.5,
      color: colors[random.nextInt(colors.length)],
    );

    add(particle);
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
        const Color(0xFF1E1E1E).withOpacity(0.4),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, gameSize.x, gameSize.y);

    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }
}
