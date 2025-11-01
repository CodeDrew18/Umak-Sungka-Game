import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WaterDrop extends PositionComponent {
  Vector2 velocity;
  final double maxLifetime;
  double lifetime = 0;
  final Paint _paint = Paint();
  final Random _random = Random();

  WaterDrop({
    required Vector2 position,
    required this.velocity,
    required this.maxLifetime,
    required double width,
  }) : super(
          position: position,
          size: Vector2(width, width * 2),
        );

  @override
  void update(double dt) {
    lifetime += dt;
    position += velocity * dt;

    velocity.y += 200 * dt;

    if (lifetime > maxLifetime) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final opacity = (1 - (lifetime / maxLifetime)).clamp(0.0, 1.0);
    _paint.shader = RadialGradient(
      colors: [
        const Color(0xFFFF5555).withOpacity(opacity),
        const Color(0xFFAA0000).withOpacity(opacity * 0.7),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    canvas.drawOval(Offset.zero & Size(size.x, size.y), _paint);
  }
}

class WaterEffect extends Component with HasGameRef {
  final Random _random = Random();
  double _emissionTimer = 0;
  final double _emissionRate = 0.025;
  final int _maxDrops = 120;
  final List<WaterDrop> _drops = [];

  @override
  void update(double dt) {
    _emissionTimer += dt;

    if (_drops.length < _maxDrops && _emissionTimer >= _emissionRate) {
      _emissionTimer = 0;
      _emitWaterDrop();
    }

    _drops.removeWhere((drop) => drop.isRemoved);
  }

  void _emitWaterDrop() {
    final gameSize = gameRef.size;
    if (gameSize.x == 0 || gameSize.y == 0) return;

    final startX = _random.nextDouble() * gameSize.x;
    final velocityX = (_random.nextDouble() - 0.5) * 20;
    final velocityY = _random.nextDouble() * 80 + 150;
    final width = _random.nextDouble() * 3 + 1.5;

    final drop = WaterDrop(
      position: Vector2(startX, -20),
      velocity: Vector2(velocityX, velocityY),
      maxLifetime: _random.nextDouble() * 1.5 + 1.5,
      width: width,
    );

    _drops.add(drop);
    add(drop);
  }

  @override
  void render(Canvas canvas) {

    final rect = Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y);
    final vignette = RadialGradient(
      colors: [
        Colors.transparent,
        const Color(0xFF000000).withOpacity(0.25),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = vignette.createShader(rect));
  }
}
