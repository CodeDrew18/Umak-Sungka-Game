import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SettingsButton extends PositionComponent with TapCallbacks, HoverCallbacks {
  final VoidCallback onPressed;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;

  bool isHovered = false;
  double hoverScale = 1.0;
  double pressScale = 1.0;

  static const double diameter = 60.0;

  SettingsButton({
    required this.onPressed,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
  }) : super(
          size: Vector2.all(diameter),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    final radius = diameter / 2;
    final center = Offset(radius, radius);

    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(diameter, diameter),
        [primaryColor, accentColor],
      );

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center.translate(2, 3), radius, shadowPaint);
    canvas.drawCircle(center, radius, gradientPaint);

    final borderPaint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          fontSize: radius * 1.0,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    hoverScale = isHovered ? 1.1 : 1.0;
    scale = Vector2.all(hoverScale * pressScale);
  }

  @override
  void onTapDown(TapDownEvent event) {
    pressScale = 0.95;
  }

  @override
  void onTapUp(TapUpEvent event) {
    pressScale = 1.0;
    onPressed(); 
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    pressScale = 1.0;
  }

  @override
  void onHoverEnter() {
    isHovered = true;
  }

  @override
  void onHoverExit() {
    isHovered = false;
  }
}
