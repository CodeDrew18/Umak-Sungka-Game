import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class Particle extends PositionComponent {
  Paint paintStyle;
  Vector2 velocity;
  double life;
  double maxLife;
  Random random = Random();

  Particle({
    required Vector2 position,
    required this.velocity,
    required this.life,
    required this.maxLife,
    required this.paintStyle,
  }) {
    this.position = position;
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    life -= dt;
    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = (life / maxLife).clamp(0.0, 1.0);
    final color = paintStyle.color.withOpacity(opacity);
    final p = Paint()..color = color;
    canvas.drawCircle(Offset(position.x, position.y), 2, p);
  }
}

class ParticleBackground extends Component {
  final Random _random = Random();
  final List<Color> colors = List.generate(
    5,
    (i) => HSVColor.fromAHSV(1, i * 60, 0.8, 1.0).toColor(),
  );

  @override
  void update(double dt) {
    if (children.length < 80 && _random.nextDouble() < 0.2) {
      add(
        Particle(
          position: Vector2(
            _random.nextDouble() * 800,
            _random.nextDouble() * 600,
          ),
          velocity: Vector2(
            (_random.nextDouble() - 0.5) * 30,
            (_random.nextDouble() - 0.5) * 30,
          ),
          life: 2 + _random.nextDouble() * 2,
          maxLife: 2 + _random.nextDouble() * 2,
          paintStyle: Paint()..color = colors[_random.nextInt(colors.length)],
        ),
      );
    }
  }
}
