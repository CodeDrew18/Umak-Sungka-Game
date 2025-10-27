import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GameButton extends PositionComponent {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool hasIcon;
  final String? iconPath;
  final double width;
  final double height;

  late TextPaint textPaint;
  bool isHovered = false;
  double hoverScale = 1.0;
  double targetScale = 1.0;
  double glowIntensity = 0;
  double animationTime = 0;

  GameButton({
    required Vector2 position,
    required this.width,
    required this.height,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.hasIcon = false,
    this.iconPath,
  }) : super(
    position: position,
    size: Vector2(width, height),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    textPaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTime += dt;

    hoverScale += (targetScale - hoverScale) * 0.1;

    glowIntensity = (sin(animationTime * 2) + 1) / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final glowPaint = Paint()
      ..color = backgroundColor.withOpacity(glowIntensity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
        const Radius.circular(15),
      ),
      glowPaint,
    );

    final buttonPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
        const Radius.circular(15),
      ),
      buttonPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
        const Radius.circular(15),
      ),
      borderPaint,
    );

    textPaint.render(
      canvas,
      label,
      Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
  }
}
