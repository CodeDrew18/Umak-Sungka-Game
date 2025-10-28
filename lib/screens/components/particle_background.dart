// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class Particle extends PositionComponent with HasGameRef {
//   final Vector2 velocity;
//   final double maxLifetime;
//   double lifetime = 0;
//   final Color color;

//   Particle({
//     required Vector2 position,
//     required this.velocity,
//     required this.maxLifetime,
//     required this.color,
//   }) : super(
//           position: position,
//           size: Vector2(4, 4),
//         );

//   @override
//   void update(double dt) {
//     super.update(dt);
//     lifetime += dt;
//     position += velocity * dt;

//     if (lifetime >= maxLifetime) {
//       removeFromParent();
//     }
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     double opacityValue = 1 - (lifetime / maxLifetime);
//     opacityValue = opacityValue.clamp(0.0, 1.0);

//     canvas.drawCircle(
//       Offset(size.x / 2, size.y / 2),
//       size.x / 2,
//       Paint()
//         ..color = color.withOpacity(opacityValue)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
//     );
//   }
// }

// class ParticleBackground extends Component with HasGameRef {
//   final Random random = Random();
//   double emissionTimer = 0;
//   final double emissionRate = 0.05;

//   @override
//   void update(double dt) {
//     super.update(dt);
//     emissionTimer += dt;

//     while (emissionTimer > emissionRate) {
//       _emitParticle();
//       emissionTimer -= emissionRate;
//     }
//   }

//   void _emitParticle() {
//     final gameSize = gameRef.size;
//     if (gameSize.x == 0 || gameSize.y == 0) return;

//     final startX = random.nextDouble() * gameSize.x;
//     final startY = gameSize.y + 10;

//     final velocityX = (random.nextDouble() - 0.5) * 50;
//     final velocityY = -random.nextDouble() * 80 - 40;

//     final colors = [
//       const Color(0xFFFF6B35).withOpacity(0.7),
//       const Color(0xFFFFB627).withOpacity(0.7),
//       const Color(0xFFF7931E).withOpacity(0.6),
//       const Color(0xFFE6B428).withOpacity(0.6),
//     ];

//     final particle = Particle(
//       position: Vector2(startX, startY),
//       velocity: Vector2(velocityX, velocityY),
//       maxLifetime: random.nextDouble() * 2 + 1.5,
//       color: colors[random.nextInt(colors.length)],
//     );

//     add(particle);
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     final gameSize = gameRef.size;
//     if (gameSize.x <= 0 || gameSize.y <= 0) return;

//     final gradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [
//         Colors.transparent,
//         const Color(0xFF1E1E1E).withOpacity(0.4),
//       ],
//     );

//     final rect = Rect.fromLTWH(0, 0, gameSize.x, gameSize.y);

//     canvas.drawRect(
//       rect,
//       Paint()..shader = gradient.createShader(rect),
//     );
//   }
// }



import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Lightweight glowing floating particles for background animation.
/// Uses Flame's built-in particle system for optimal performance.
class ParticleBackground extends Component with HasGameRef {
  final Random _random = Random();
  double _emissionTimer = 0;
  final double _emissionRate = 0.2; // one burst every 0.2s (~5 per second)
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

    // pick a random warm color palette
    final colors = [
      const Color(0xFFFF6B35),
      const Color(0xFFFFB627),
      const Color(0xFFF7931E),
      const Color(0xFFE6B428),
    ];

    // create a burst of small floating glowing particles
    final particle = Particle.generate(
      count: _particlesPerBurst,
      lifespan: 2.5,
      generator: (i) {
        final dx = (_random.nextDouble() - 0.5) * 30;
        final dy = -_random.nextDouble() * 80 - 20;
        final color = colors[_random.nextInt(colors.length)]
            .withOpacity(0.25 + _random.nextDouble() * 0.5);

        return AcceleratedParticle(
          acceleration: Vector2(0, 15), // gravity pull down
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

    // subtle gradient overlay for depth
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
