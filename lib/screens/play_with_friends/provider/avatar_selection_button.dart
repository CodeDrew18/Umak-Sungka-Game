// lib/screens/play_with_friends/avatar_selection/avatar_selection_button.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class AvatarSelectionButton extends PositionComponent with TapCallbacks, HoverCallbacks {
  final String label;
  final VoidCallback onPressed;
  bool isHovered = false;

  AvatarSelectionButton({
    required this.label,
    required this.onPressed,
  }) : super(size: Vector2(220, 60));

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = isHovered ? Colors.orangeAccent : Colors.orange
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(30));
    canvas.drawRRect(rrect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.x);
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, size.y / 2 - textPainter.height / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
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
