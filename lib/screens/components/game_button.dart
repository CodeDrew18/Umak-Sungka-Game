// // import 'package:flame/components.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:math';

// // class GameButton extends PositionComponent {
// //   final String label;
// //   final Color backgroundColor;
// //   final Color textColor;
// //   final VoidCallback onPressed;
// //   final bool hasIcon;
// //   final String? iconPath;
// //   final double width;
// //   final double height;

// //   late TextPaint textPaint;
// //   bool isHovered = false;
// //   double hoverScale = 1.0;
// //   double targetScale = 1.0;
// //   double glowIntensity = 0;
// //   double animationTime = 0;

// //   GameButton({
// //     required Vector2 position,
// //     required this.width,
// //     required this.height,
// //     required this.label,
// //     required this.backgroundColor,
// //     required this.textColor,
// //     required this.onPressed,
// //     this.hasIcon = false,
// //     this.iconPath,
// //   }) : super(
// //     position: position,
// //     size: Vector2(width, height),
// //     anchor: Anchor.center,
// //   );

// //   @override
// //   Future<void> onLoad() async {
// //     super.onLoad();
// //     textPaint = TextPaint(
// //       textDirection: TextDirection.ltr,
// //       style: TextStyle(
// //         color: textColor,
// //         fontSize: 18,
// //         fontWeight: FontWeight.bold,
// //         fontFamily: 'Poppins',
// //       ),
// //     );
// //   }

// //   @override
// //   void update(double dt) {
// //     super.update(dt);
// //     animationTime += dt;

// //     hoverScale += (targetScale - hoverScale) * 0.1;

// //     glowIntensity = (sin(animationTime * 2) + 1) / 2;
// //   }

// //   @override
// //   void render(Canvas canvas) {
// //     super.render(canvas);

// //     final glowPaint = Paint()
// //       ..color = backgroundColor.withOpacity(glowIntensity * 0.3)
// //       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

// //     canvas.drawRRect(
// //       RRect.fromRectAndRadius(
// //         Rect.fromCenter(
// //           center: Offset(size.x / 2, size.y / 2),
// //           width: size.x * hoverScale,
// //           height: size.y * hoverScale,
// //         ),
// //         const Radius.circular(15),
// //       ),
// //       glowPaint,
// //     );

// //     final buttonPaint = Paint()
// //       ..color = backgroundColor
// //       ..style = PaintingStyle.fill;

// //     canvas.drawRRect(
// //       RRect.fromRectAndRadius(
// //         Rect.fromCenter(
// //           center: Offset(size.x / 2, size.y / 2),
// //           width: size.x * hoverScale,
// //           height: size.y * hoverScale,
// //         ),
// //         const Radius.circular(15),
// //       ),
// //       buttonPaint,
// //     );

// //     final borderPaint = Paint()
// //       ..color = Colors.black.withOpacity(0.2)
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 2;

// //     canvas.drawRRect(
// //       RRect.fromRectAndRadius(
// //         Rect.fromCenter(
// //           center: Offset(size.x / 2, size.y / 2),
// //           width: size.x * hoverScale,
// //           height: size.y * hoverScale,
// //         ),
// //         const Radius.circular(15),
// //       ),
// //       borderPaint,
// //     );

// //     textPaint.render(
// //       canvas,
// //       label,
// //       Vector2(size.x / 2, size.y / 2),
// //       anchor: Anchor.center,
// //     );
// //   }
// // }



// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class GameButton extends PositionComponent {
//   final String label;
//   final Color backgroundColor;
//   final Color textColor;
//   final VoidCallback onPressed;
//   final bool hasIcon;
//   final String? iconPath;
//   final double width;
//   final double height;

//   late TextPaint textPaint;
//   bool isHovered = false;
//   double hoverScale = 1.0;
//   double targetScale = 1.0;
//   double glowIntensity = 0;
//   double animationTime = 0;

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
//   }) : super(
//     position: position,
//     size: Vector2(width, height),
//     anchor: Anchor.center,
//   );

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     textPaint = TextPaint(
//       textDirection: TextDirection.ltr,
//       style: TextStyle(
//         color: textColor,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Poppins',
//       ),
//     );
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     animationTime += dt;

//     // Smooth scale animation
//     hoverScale += (targetScale - hoverScale) * 0.1;

//     // Pulsing glow effect
//     glowIntensity = (sin(animationTime * 2) + 1) / 2;
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     final glowColor = backgroundColor == Colors.white 
//       ? const Color(0xFFFF4444).withOpacity(glowIntensity * 0.2)
//       : backgroundColor.withOpacity(glowIntensity * 0.3);

//     final glowPaint = Paint()
//       ..color = glowColor
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(size.x / 2, size.y / 2),
//           width: size.x * hoverScale,
//           height: size.y * hoverScale,
//         ),
//         const Radius.circular(15),
//       ),
//       glowPaint,
//     );

//     // Draw button background
//     final buttonPaint = Paint()
//       ..color = backgroundColor
//       ..style = PaintingStyle.fill;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(size.x / 2, size.y / 2),
//           width: size.x * hoverScale,
//           height: size.y * hoverScale,
//         ),
//         const Radius.circular(15),
//       ),
//       buttonPaint,
//     );

//     // Draw border for depth
//     final borderPaint = Paint()
//       ..color = Colors.black.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(size.x / 2, size.y / 2),
//           width: size.x * hoverScale,
//           height: size.y * hoverScale,
//         ),
//         const Radius.circular(15),
//       ),
//       borderPaint,
//     );

//     // Draw text
//     textPaint.render(
//       canvas,
//       label,
//       Vector2(size.x / 2, size.y / 2),
//       anchor: Anchor.center,
//     );
//   }

//   @override
//   void onHoverEnter() {
//     targetScale = 1.08;
//     isHovered = true;
//   }

//   @override
//   void onHoverExit() {
//     targetScale = 1.0;
//     isHovered = false;
//   }

//   @override
//   void onTapDown(TapDownEvent event) {
//     targetScale = 0.95;
//   }

//   @override
//   void onTapUp(TapUpEvent event) {
//     targetScale = isHovered ? 1.08 : 1.0;
//     onPressed();
//   }

//   @override
//   void onTapCancel(TapCancelEvent event) {
//     targetScale = isHovered ? 1.08 : 1.0;
//   }
// }




import 'package:flame/components.dart';
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

    // Draw label
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

    // Load icon if needed
    if (hasIcon && iconPath != null) {
      try {
        final sprite = await Sprite.load(iconPath!);
        iconSprite = SpriteComponent(
          sprite: sprite,
          size: Vector2(28, 28),
          position: Vector2(20, size.y / 2 - 14),
        );
        add(iconSprite!);

        // Move text slightly to the right to avoid overlap
        labelText.position = Vector2(size.x / 2 + 15, size.y / 2);
      } catch (e) {
        debugPrint('⚠️ Failed to load icon at $iconPath: $e');
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = backgroundColor;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}
