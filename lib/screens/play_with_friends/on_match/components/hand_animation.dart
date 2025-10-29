import 'package:flutter/material.dart';

class HandAnimation {
  final double startX;
  final double startY;
  final double targetX;
  final double targetY;
  final VoidCallback onComplete;

  double elapsed = 0;
  final double duration = 0.4;

  HandAnimation({
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
    required this.onComplete,
  });

  bool get isComplete => elapsed >= duration;

  void update(double dt) {
    elapsed += dt;
    if (isComplete) {
      onComplete();
    }
  }

  void render(Canvas canvas) {
    final progress = (elapsed / duration).clamp(0.0, 1.0);

    final currentX = startX + (targetX - startX) * progress;
    final currentY = startY + (targetY - startY) * progress;

    _drawHand(canvas, currentX, currentY);
  }

  void _drawHand(Canvas canvas, double x, double y) {
    // Hand shadow
    canvas.drawCircle(
      Offset(x, y),
      13,
      Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Hand palm
    canvas.drawCircle(
      Offset(x, y),
      12,
      Paint()..color = const Color(0xFFD4A574),
    );

    // Fingers
    final fingerOffsets = [
      Offset(x - 8, y - 10),
      Offset(x - 2, y - 12),
      Offset(x + 4, y - 12),
      Offset(x + 10, y - 10),
    ];

    for (final offset in fingerOffsets) {
      canvas.drawCircle(
        offset,
        4,
        Paint()..color = const Color(0xFFD4A574),
      );
    }

    // Highlight
    canvas.drawCircle(
      Offset(x - 3, y - 3),
      3,
      Paint()..color = Colors.white.withOpacity(0.4),
    );
  }
}