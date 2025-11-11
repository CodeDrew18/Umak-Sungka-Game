import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedTitle extends PositionComponent with HasGameRef {
  late TextPaint textPaint;
  late TextPaint subtitlePaint;
  double animationTime = 0;
  final String title;
  double glowIntensity = 0;

  AnimatedTitle({
    this.title = 'Sungka Master',
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(gameRef.size.x / 2, gameRef.size.y * 0.25);
    size = Vector2(600, 150);
    anchor = Anchor.center;
    textPaint = TextPaint(
  textDirection: TextDirection.ltr,
  style: const TextStyle(
    color: Color(0xFFFFD700),
    fontSize: 32,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins',
    shadows: [
      Shadow(
        offset: Offset(0, 4),
        blurRadius: 10,
        color: Color(0xFFB8860B),
      ),
      Shadow(
        offset: Offset(0, 8),
        blurRadius: 20,
        color: Color(0xFF8B4513),
      ),
    ],
  ),
);
    subtitlePaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTime += dt;

    glowIntensity = (sin(animationTime * 2.5) + 1) / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final glowPaint = Paint()
      ..color = const Color(0xFFE67E22).withOpacity(glowIntensity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      110,
      glowPaint,
    );

    textPaint.render(
      canvas,
      title,
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );

  }
}
