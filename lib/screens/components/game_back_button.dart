import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameBackButton extends PositionComponent with TapCallbacks, HoverCallbacks {
  final VoidCallback onPressed;
  final Color primaryColor;
  final Color accentColor;

  late Paint gradientPaint;
  late Paint shadowPaint;
  late Paint borderPaint;

  bool isHovered = false;
  double hoverScale = 1.0;
  double pressScale = 1.0;

  static const double buttonSize = 60.0;
  static const double borderWidth = 2.5;
  static const double shadowBlur = 15.0;

  GameBackButton({
    required this.onPressed,
    this.primaryColor = const Color(0xFF6366F1),
    this.accentColor = const Color(0xFFA78BFA),
  }) : super(
    size: Vector2(buttonSize, buttonSize),
    anchor: Anchor.topLeft,
  );

  @override
  void onMount() {
    super.onMount();
    _setupPaints();
  }

  void _setupPaints() {
    gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.x, size.y),
        [primaryColor, accentColor],
        [0.0, 1.0],
      )
      ..style = PaintingStyle.fill;

    shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur)
      ..style = PaintingStyle.fill;

    borderPaint = Paint()
      ..color = accentColor.withOpacity(0.6)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
  }

  @override
  void render(Canvas canvas) {
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = (size.x / 2) - (borderWidth / 2);

    // Draw shadow
    canvas.drawCircle(
      Offset(centerX + 2, centerY + 3),
      radius + 2,
      shadowPaint,
    );

    // Draw gradient background
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      gradientPaint,
    );

    // Draw border
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      borderPaint,
    );

    // Draw back arrow icon
    _drawArrowIcon(canvas, centerX, centerY);

    // Draw hover glow effect
    if (isHovered) {
      _drawGlowEffect(canvas, centerX, centerY, radius);
    }
  }

void _drawArrowIcon(Canvas canvas, double centerX, double centerY) {
  final arrowPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  const arrowSize = 14.0;

  // Shaft of the arrow (horizontal line)
// Shaft (horizontal line)
canvas.drawLine(
  Offset(centerX + 5, centerY),
  Offset(centerX - 10, centerY),
  arrowPaint,
);

// Lower diagonal (bottom-left)
canvas.drawLine(
  Offset(centerX - 10, centerY),
  Offset(centerX - 10 + arrowSize / 2, centerY + arrowSize / 2),
  arrowPaint,
);

// Upper diagonal (top-left)
canvas.drawLine(
  Offset(centerX - 10, centerY),
  Offset(centerX  - 10 +  arrowSize / 2, centerY - arrowSize / 2),
  arrowPaint,
);


}


  void _drawGlowEffect(Canvas canvas, double centerX, double centerY, double radius) {
    final glowPaint = Paint()
      ..color = accentColor.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius + 8,
      glowPaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Smooth hover animation
    hoverScale = isHovered ? 1.1 : 1.0;

    // Apply scale transform
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
