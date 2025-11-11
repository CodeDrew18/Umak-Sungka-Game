// lib/screens/play_with_friends/avatar_selection/avatar_icon_component.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class AvatarIconComponent extends PositionComponent with TapCallbacks, HoverCallbacks {
  final int index;
  final String name;
  final Color color;
  final IconData icon;
  final void Function(int) onSelect;
  bool isHovered = false;

  AvatarIconComponent({
    required this.index,
    required this.name,
    required this.color,
    required this.icon,
    required this.onSelect,
  }) : super(size: Vector2.all(100));

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = isHovered ? color.withOpacity(0.9) : color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
    canvas.drawRRect(rrect, paint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 40,
          fontFamily: icon.fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(size.x / 2 - iconPainter.width / 2, size.y / 2 - iconPainter.height / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onSelect(index);
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
