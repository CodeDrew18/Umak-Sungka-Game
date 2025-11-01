import 'package:flutter/material.dart';
import 'dart:math' as math;

class PebbleAnimation {
  final Offset startPos;
  final Offset targetPos;
  final double delay;
  final double duration;
  final int colorIndex;

  double elapsed = 0;

  static const List<Color> stoneColors = [
    Color(0xFF1E90FF),
    Color(0xFF32CD32),
    Color(0xFFFF8C00),
    Color(0xFFFFD700),
    Color(0xFFFF69B4),
    Color(0xFF00CED1),
    Color(0xFFFFB6C1),
  ];

  PebbleAnimation({
    required this.startPos,
    required this.targetPos,
    required this.delay,
    required this.duration,
    required this.colorIndex,
  });

  bool get isComplete => elapsed >= delay + duration;
  bool get isActive => elapsed >= delay;

  void update(double dt) {
    elapsed += dt;
  }

  void render(Canvas canvas) {
    if (!isActive) return;

    final progress = ((elapsed - delay) / duration).clamp(0.0, 1.0);
    final easeProgress = _easeInOutCubic(progress);

    final currentX = startPos.dx + (targetPos.dx - startPos.dx) * easeProgress;
    final currentY = startPos.dy + (targetPos.dy - startPos.dy) * easeProgress;

    final heightOffset = math.sin(progress * math.pi) * 40;

    canvas.drawCircle(
      Offset(currentX, currentY - heightOffset + 1.5),
      6,
      Paint()..color = Colors.black.withOpacity(0.15),
    );

    final stoneColor = stoneColors[colorIndex % stoneColors.length];
    canvas.drawCircle(
      Offset(currentX, currentY - heightOffset),
      6,
      Paint()..color = stoneColor,
    );

    canvas.drawCircle(
      Offset(currentX - 2, currentY - heightOffset - 2),
      2,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
  }

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - (math.pow(-2 * t + 2, 3) as double) / 2;
  }
}