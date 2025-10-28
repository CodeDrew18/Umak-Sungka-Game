
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeGameButton extends PositionComponent {
  final String label;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onPressed;

  late TextPaint labelPaint;
  late TextPaint descriptionPaint;
  bool isHovered = false;
  double hoverScale = 1.0;
  double targetScale = 1.0;
  double glowIntensity = 0;
  double animationTime = 0;

  HomeGameButton({
    required Vector2 position,
    required this.label,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onPressed,
  }) : super(
    position: position,
    size: Vector2(140, 160),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    labelPaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    descriptionPaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 10,
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

    final centerX = size.x / 2;
    final centerY = size.y / 2;

    final glowPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: size.x * hoverScale * 1.2,
          height: size.y * hoverScale * 1.2,
        ),
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15 * glowIntensity);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: size.x * hoverScale * 1.2,
          height: size.y * hoverScale * 1.2,
        ),
        const Radius.circular(12),
      ),
      glowPaint,
    );

    final buttonPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
      );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
        const Radius.circular(12),
      ),
      buttonPaint,
    );

    // Draw border with gradient effect
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: size.x * hoverScale,
          height: size.y * hoverScale,
        ),
        const Radius.circular(12),
      ),
      borderPaint,
    );

    // Draw icon
    final iconSize = 32.0;
    _drawIcon(canvas, centerX, centerY - 20, iconSize);

    // Draw label text
    labelPaint.render(
      canvas,
      label,
      Vector2(centerX, centerY + 8),
      anchor: Anchor.center,
    );

    // Draw description text
    descriptionPaint.render(
      canvas,
      description,
      Vector2(centerX, centerY + 35),
      anchor: Anchor.center,
    );
  }

  void _drawIcon(Canvas canvas, double x, double y, double size) {
    // Draw a simple circle icon background
    final iconBgPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), size / 2, iconBgPaint);

    // Draw icon border
    final iconBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(x, y), size / 2, iconBorderPaint);
  }

  @override
  void onHoverEnter() {
    targetScale = 1.08;
    isHovered = true;
  }

  @override
  void onHoverExit() {
    targetScale = 1.0;
    isHovered = false;
  }

  @override
  void onTapDown(TapDownEvent event) {
    targetScale = 0.95;
  }

  @override
  void onTapUp(TapUpEvent event) {
    targetScale = isHovered ? 1.08 : 1.0;
    onPressed();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    targetScale = isHovered ? 1.08 : 1.0;
  }
}
