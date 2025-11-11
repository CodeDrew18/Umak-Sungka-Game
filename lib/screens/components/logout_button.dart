import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class LogoutButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String label;

  LogoutButton({
    required this.onPressed,
    this.backgroundColor = Colors.redAccent,
    this.textColor = Colors.white,
    this.label = 'Logout',
  });

  late final _ButtonBackground _background;
  late final TextComponent _text;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = Vector2(180, 60);
    anchor = Anchor.center;

    _background =
        _ButtonBackground(size: size, color: backgroundColor, cornerRadius: 12)
          ..anchor = Anchor.center
          ..position = Vector2(size.x / 2, size.y / 2);

    _text = TextComponent(
      text: label,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2),
    );

    add(_background);
    add(_text);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _background.setOpacity(0.7);
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _background.setOpacity(1.0);
    onPressed();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _background.setOpacity(1.0);
  }
}

class _ButtonBackground extends PositionComponent {
  final Color color;
  final double cornerRadius;
  late Paint _paint;

  _ButtonBackground({
    required Vector2 size,
    required this.color,
    this.cornerRadius = 12,
  }) {
    this.size = size;
    _paint = Paint()..color = color;
    anchor = Anchor.center;
  }

  void setOpacity(double opacity) {
    _paint.color = color.withOpacity(opacity);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: size.x,
        height: size.y,
      ),
      Radius.circular(cornerRadius),
    );
    canvas.drawRRect(rect, _paint);
  }
}
