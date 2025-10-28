// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class WaterDrop extends PositionComponent {
//   final Vector2 velocity;
//   final double maxLifetime;
//   double lifetime = 0;
//   final double width;
//   final Vector2 gameSize;

//   WaterDrop({
//     required Vector2 position,
//     required this.velocity,
//     required this.maxLifetime,
//     required this.width,
//     required this.gameSize,
//   }) : super(
//     position: position,
//     size: Vector2(width, width * 2),
//   );

//   @override
//   void update(double dt) {
//     super.update(dt);
//     lifetime += dt;
//     position += velocity * dt;

//     // Add gravity effect
//     velocity.y += 150 * dt;

//     if (lifetime >= maxLifetime || position.y > gameSize.y + 50) {
//       removeFromParent();
//     }
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     final opacityValue = 1 - (lifetime / maxLifetime);
    
//     // Draw water drop with gradient
//     final gradient = RadialGradient(
//       colors: [
//         const Color(0xFFFF4444).withOpacity(opacityValue * 0.9),
//         const Color(0xFFCC0000).withOpacity(opacityValue * 0.7),
//       ],
//     );

//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(size.x / 2, size.y / 2),
//         width: size.x,
//         height: size.y,
//       ),
//       Paint()
//         ..shader = gradient.createShader(
//           Rect.fromCenter(
//             center: Offset(size.x / 2, size.y / 2),
//             width: size.x,
//             height: size.y,
//           ),
//         )
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
//     );
//   }
// }

// class WaterEffect extends PositionComponent with HasGameRef{
//   final Random random = Random();
//   double emissionTimer = 0;
//   final double emissionRate = 0.03; // Water drops per frame

//   WaterEffect() : super(
//     size: Vector2.zero(), // Will be set by parent
//   );

//   @override
//   void onMount() {
//     super.onMount();
//     size = gameRef.size;
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     emissionTimer += dt;

//     // Emit water drops
//     while (emissionTimer > emissionRate) {
//       _emitWaterDrop();
//       emissionTimer -= emissionRate;
//     }
//   }

//   void _emitWaterDrop() {
//     final gameSize = gameRef.size;
//     final startX = random.nextDouble() * gameSize.x;
//     final startY = -20.0;
//     final velocityX = (random.nextDouble() - 0.5) * 30;
//     final velocityY = random.nextDouble() * 50 + 100;

//     final dropWidth = random.nextDouble() * 3 + 2;

//     final waterDrop = WaterDrop(
//       position: Vector2(startX, startY),
//       velocity: Vector2(velocityX, velocityY),
//       maxLifetime: random.nextDouble() * 1.5 + 2,
//       width: dropWidth,
//       gameSize: gameSize,
//     );

//     add(waterDrop);
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     // Optional: Add a subtle vignette effect
//     final vignette = RadialGradient(
//       colors: [
//         Colors.transparent,
//         const Color(0xFF1E1E1E).withOpacity(0.2),
//       ],
//     );

//     canvas.drawRect(
//       Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
//       Paint()
//         ..shader = vignette.createShader(
//           Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
//         ),
//     );
//   }
// }




// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class WaterDrop extends PositionComponent {
//   Vector2 velocity; // make mutable
//   final double maxLifetime;
//   double lifetime = 0;
//   final double width;
//   final Vector2 gameSize;

//   WaterDrop({
//     required Vector2 position,
//     required this.velocity,
//     required this.maxLifetime,
//     required this.width,
//     required this.gameSize,
//   }) : super(
//           position: position,
//           size: Vector2(width, width * 2),
//         );

//   @override
//   void update(double dt) {
//     super.update(dt);
//     lifetime += dt;
//     position += velocity * dt;

//     // Add gravity effect
//     velocity = Vector2(velocity.x, velocity.y + 150 * dt);

//     if (lifetime >= maxLifetime || position.y > gameSize.y + 50) {
//       removeFromParent();
//     }
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     // Skip rendering if size is invalid
//     if (size.x <= 0 || size.y <= 0) return;

//     final opacityValue = (1 - (lifetime / maxLifetime)).clamp(0.0, 1.0);

//     final rect = Rect.fromCenter(
//       center: Offset(size.x / 2, size.y / 2),
//       width: size.x,
//       height: size.y,
//     );

//     // Prevent shader crash: validate dimensions
//     if (rect.width <= 0 || rect.height <= 0) return;

//     final gradient = RadialGradient(
//       colors: [
//         const Color(0xFFFF4444).withOpacity(opacityValue * 0.9),
//         const Color(0xFFCC0000).withOpacity(opacityValue * 0.7),
//       ],
//     );

//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

//     canvas.drawOval(rect, paint);
//   }
// }

// class WaterEffect extends PositionComponent with HasGameRef {
//   final Random random = Random();
//   double emissionTimer = 0;
//   final double emissionRate = 0.03; // Water drops per frame

//   WaterEffect() : super(size: Vector2.zero());

//   @override
//   void onMount() {
//     super.onMount();
//     size = gameRef.size;
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     emissionTimer += dt;

//     // Emit water drops safely
//     while (emissionTimer > emissionRate) {
//       _emitWaterDrop();
//       emissionTimer -= emissionRate;
//     }
//   }

//   void _emitWaterDrop() {
//     final gameSize = gameRef.size;
//     if (gameSize.x <= 0 || gameSize.y <= 0) return;

//     final startX = random.nextDouble() * gameSize.x;
//     final startY = -20.0;
//     final velocityX = (random.nextDouble() - 0.5) * 30;
//     final velocityY = random.nextDouble() * 50 + 100;

//     final dropWidth = random.nextDouble() * 3 + 2;

//     final waterDrop = WaterDrop(
//       position: Vector2(startX, startY),
//       velocity: Vector2(velocityX, velocityY),
//       maxLifetime: random.nextDouble() * 1.5 + 2,
//       width: dropWidth,
//       gameSize: gameSize,
//     );

//     add(waterDrop);
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);

//     final gameSize = gameRef.size;
//     if (gameSize.x <= 0 || gameSize.y <= 0) return;

//     final rect = Rect.fromLTWH(0, 0, gameSize.x, gameSize.y);

//     final vignette = RadialGradient(
//       colors: [
//         Colors.transparent,
//         const Color(0xFF1E1E1E).withOpacity(0.2),
//       ],
//     );

//     canvas.drawRect(
//       rect,
//       Paint()..shader = vignette.createShader(rect),
//     );
//   }
// }



import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// A single animated drop component
class WaterDrop extends PositionComponent {
  Vector2 velocity;
  final double maxLifetime;
  double lifetime = 0;
  final Paint _paint = Paint();
  final Random _random = Random();

  WaterDrop({
    required Vector2 position,
    required this.velocity,
    required this.maxLifetime,
    required double width,
  }) : super(
          position: position,
          size: Vector2(width, width * 2),
        );

  @override
  void update(double dt) {
    lifetime += dt;
    position += velocity * dt;

    // simple gravity
    velocity.y += 200 * dt;

    // fade out over lifetime
    if (lifetime > maxLifetime) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final opacity = (1 - (lifetime / maxLifetime)).clamp(0.0, 1.0);
    _paint.shader = RadialGradient(
      colors: [
        const Color(0xFFFF5555).withOpacity(opacity),
        const Color(0xFFAA0000).withOpacity(opacity * 0.7),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    canvas.drawOval(Offset.zero & Size(size.x, size.y), _paint);
  }
}

/// Efficient particle emitter
class WaterEffect extends Component with HasGameRef {
  final Random _random = Random();
  double _emissionTimer = 0;
  final double _emissionRate = 0.025; // controls particle density
  final int _maxDrops = 120; // limit total active particles for performance
  final List<WaterDrop> _drops = [];

  @override
  void update(double dt) {
    _emissionTimer += dt;

    // Emit new drops only when below cap
    if (_drops.length < _maxDrops && _emissionTimer >= _emissionRate) {
      _emissionTimer = 0;
      _emitWaterDrop();
    }

    // Clean up finished drops efficiently
    _drops.removeWhere((drop) => drop.isRemoved);
  }

  void _emitWaterDrop() {
    final gameSize = gameRef.size;
    if (gameSize.x == 0 || gameSize.y == 0) return;

    final startX = _random.nextDouble() * gameSize.x;
    final velocityX = (_random.nextDouble() - 0.5) * 20;
    final velocityY = _random.nextDouble() * 80 + 150;
    final width = _random.nextDouble() * 3 + 1.5;

    final drop = WaterDrop(
      position: Vector2(startX, -20),
      velocity: Vector2(velocityX, velocityY),
      maxLifetime: _random.nextDouble() * 1.5 + 1.5,
      width: width,
    );

    _drops.add(drop);
    add(drop);
  }

  @override
  void render(Canvas canvas) {
    // Optional soft vignette background
    final rect = Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y);
    final vignette = RadialGradient(
      colors: [
        Colors.transparent,
        const Color(0xFF000000).withOpacity(0.25),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = vignette.createShader(rect));
  }
}
