import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedTitle extends PositionComponent with HasGameRef {
  late TextPaint textPaint;
  double animationTime = 0;
  final String title = 'Sungka Master';
  double glowIntensity = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (gameRef.size.isZero()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final screenSize = gameRef.size;
    position = Vector2(screenSize.x / 2, screenSize.y * 0.25);
    size = Vector2(400, 100);
    anchor = Anchor.center;

    textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 56,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dt.isNaN || dt.isInfinite) return;

    animationTime += dt;
    glowIntensity = ((sin(animationTime * 3) + 1) / 2).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (size.x <= 0 || size.y <= 0 || size.x.isNaN || size.y.isNaN) return;

    final clampedGlow = glowIntensity.clamp(0.0, 1.0);

    final glowPaint = Paint()
      ..color = const Color(0xFFE6B428).withOpacity(clampedGlow * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    try {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        80,
        glowPaint,
      );
    } catch (_) {
    }

    final shadowOffset = const Offset(2, 2);

    textPaint.render(
      canvas,
      title,
      Vector2(size.x / 2 + shadowOffset.dx, size.y / 2 + shadowOffset.dy),
      anchor: Anchor.center,
    );

    textPaint.render(
      canvas,
      title,
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
  }
}
