import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class HomeGameButton extends PositionComponent with TapCallbacks, HoverCallbacks {
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
      style: const TextStyle(
        color: Colors.white70,
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

    final glowPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCenter(
              center: Offset(centerX, centerY),
              width: size.x * hoverScale * 1.2,
              height: size.y * hoverScale * 1.2,
            ),
          );

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

    final buttonPaint =
        Paint()
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

    final borderPaint =
        Paint()
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

    _drawIcon(canvas, centerX, centerY - 20, 32.0);

    labelPaint.render(
      canvas,
      label,
      Vector2(centerX, centerY + 8),
      anchor: Anchor.center,
    );

    final lines = description.split('\n');
    final lineHeight = 12.0;
    final totalHeight = lines.length * lineHeight;
    for (int i = 0; i < lines.length; i++) {
      final lineY =
          centerY + 28 + (i * lineHeight) - totalHeight / 2 + lineHeight / 2;
      descriptionPaint.render(
        canvas,
        lines[i],
        Vector2(centerX, lineY),
        anchor: Anchor.center,
      );
    }
  }

  void _drawIcon(Canvas canvas, double x, double y, double size) {
    final iconBgPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), size / 2, iconBgPaint);

    final iconBorderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(x, y), size / 2, iconBorderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size * 0.6,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
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
