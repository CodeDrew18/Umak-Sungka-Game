  // import 'package:flame/components.dart';
  // import 'package:flame/events.dart';
  // import 'package:flutter/material.dart';

  // class GameButton extends PositionComponent with TapCallbacks, HasGameRef {
  //   final double width;
  //   final double height;
  //   final String label;
  //   final Color backgroundColor;
  //   final Color textColor;
  //   final VoidCallback onPressed;
  //   final bool hasIcon;
  //   final String? iconPath;

  //   late final TextComponent labelText;
  //   SpriteComponent? iconSprite;

  //   GameButton({
  //     required Vector2 position,
  //     required this.width,
  //     required this.height,
  //     required this.label,
  //     required this.backgroundColor,
  //     required this.textColor,
  //     required this.onPressed,
  //     this.hasIcon = false,
  //     this.iconPath,
  //   }) : super(position: position, anchor: Anchor.center);

  //   @override
  //   Future<void> onLoad() async {
  //     size = Vector2(width, height);


  //     labelText = TextComponent(
  //       text: label,
  //       textRenderer: TextPaint(
  //         style: TextStyle(
  //           color: textColor,
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       anchor: Anchor.center,
  //       position: Vector2(size.x / 2, size.y / 2),
  //     );
  //     add(labelText);

  //     if (hasIcon && iconPath != null) {
  //       try {
  //         final sprite = await Sprite.load(iconPath!);
  //         iconSprite = SpriteComponent(
  //           sprite: sprite,
  //           size: Vector2(28, 28),
  //           position: Vector2(20, size.y / 2 - 14),
  //         );
  //         add(iconSprite!);

  //         labelText.position = Vector2(size.x / 2 + 15, size.y / 2);
  //       } catch (e) {
  //         debugPrint('Failed to load icon at $iconPath: $e');
  //       }
  //     }
  //   }

  //   @override
  //   void render(Canvas canvas) {
  //     super.render(canvas);

  //     final paint = Paint()..color = backgroundColor;
  //     final rect = RRect.fromRectAndRadius(
  //       Rect.fromLTWH(0, 0, size.x, size.y),
  //       const Radius.circular(12),
  //     );

  //     canvas.drawRRect(rect, paint);
  //   }

  //   @override
  //   void onTapDown(TapDownEvent event) {
  //     onPressed();
  //   }
  // }



import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameButton extends PositionComponent with TapCallbacks, HasGameRef {
  final double width;
  final double height;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool hasIcon;
  final String? iconPath;

  late final TextComponent labelText;
  SpriteComponent? iconSprite;

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
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    size = Vector2(width, height);

    labelText = TextComponent(
      text: label,
      textRenderer: TextPaint(
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(labelText);

    if (hasIcon && iconPath != null) {
      try {
        final sprite = await Sprite.load(iconPath!);
        iconSprite = SpriteComponent(
          sprite: sprite,
          size: Vector2(28, 28),
          position: Vector2(20, size.y / 2 - 14),
        );
        add(iconSprite!);

        labelText.position = Vector2(size.x / 2 + 15, size.y / 2);
      } catch (e) {
        debugPrint('Failed to load icon at $iconPath: $e');
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = backgroundColor;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, paint);

    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Scale down effect
    add(
      ScaleEffect.to(
        Vector2.all(0.9),
        EffectController(
          duration: 0.08,
          reverseDuration: 0.08,
          curve: Curves.easeInOut,
        ),
      ),
    );

    onPressed();
  }
}
