// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class AnimatedTitle extends PositionComponent with HasGameRef {
//   late TextPaint textPaint;
//   late TextPaint subtitlePaint;
//   double animationTime = 0;
//   final String title = 'Sungka Master';
//   double glowIntensity = 0;

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     position = Vector2(game.size.x / 2, game.size.y * 0.25);
//     size = Vector2(400, 100);
//     anchor = Anchor.center;

//     textPaint = TextPaint(
//       textDirection: TextDirection.ltr,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 56,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Poppins',
//       ),
//     );
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     animationTime += dt;

//     // Pulsing glow effect
//     glowIntensity = (sin(animationTime * 3) + 1) / 2;
//   }

//   @override
// void render(Canvas canvas) {
//   super.render(canvas);

//   final glowPaint = Paint()
//     ..color = const Color(0xFFFF4444).withOpacity(glowIntensity * 0.3)
//     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

//   canvas.drawCircle(Offset(size.x / 2, size.y / 2), 90, glowPaint);

//   // Shadow
//   final shadowPaint = textPaint.copyWith(
//     (style) => style.copyWith(color: Colors.white),
//   );

//   shadowPaint.render(
//     canvas,
//     title,
//     Vector2(size.x / 2 + 3, size.y / 2 + 3),
//     anchor: Anchor.center,
//   );

//   // // Main text
//   // textPaint.render(
//   //   canvas,
//   //   title,
//   //   Vector2(size.x / 2, size.y / 2),
//   //   anchor: Anchor.center,
//   // );
// }

// }


import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedTitle extends PositionComponent with HasGameRef{
  late TextPaint textPaint;
  late TextPaint subtitlePaint;
  double animationTime = 0;
  final String title;
  final String subtitle;
  double glowIntensity = 0;

  AnimatedTitle({
    this.title = 'Sungka Master',
    this.subtitle = 'Welcome! Sign in to start your Sungka journey.',
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(gameRef.size.x / 2, gameRef.size.y * 0.25);
    size = Vector2(400, 100);
    anchor = Anchor.center;

    textPaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 56,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    subtitlePaint = TextPaint(
      textDirection: TextDirection.ltr,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontFamily: 'Poppins',
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    animationTime += dt;

    // Pulsing glow effect
    glowIntensity = (sin(animationTime * 3) + 1) / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final glowPaint = Paint()
      ..color = const Color(0xFFFF4444).withOpacity(glowIntensity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      90,
      glowPaint,
    );

    // Draw title text with shadow
    final shadowOffset = Offset(3, 3);
    textPaint.render(
      canvas,
      title,
      Vector2(size.x / 2 + shadowOffset.dx, size.y / 2 + shadowOffset.dy),
      anchor: Anchor.center,
    );

    // // Draw main text
    // textPaint.render(
    //   canvas,
    //   title,
    //   Vector2(size.x / 2, size.y / 2),
    //   anchor: Anchor.center,
    // );

    // // Draw subtitle
    // subtitlePaint.render(
    //   canvas,
    //   subtitle,
    //   Vector2(size.x / 2, size.y / 2 + 50),
    //   anchor: Anchor.center,
    // );
  }
}
