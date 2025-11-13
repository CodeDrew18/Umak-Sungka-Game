// // falling_pebble.dart

// import 'dart:math';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';

// class FallingPebble extends SpriteComponent with HasGameRef<FlameGame> {
//   // All relevant properties are doubles
//   final double speed = 150.0; 
//   final String imagePath;
//   final Random _rng = Random();

//   FallingPebble({required this.imagePath}) : super();

//   @override
//  Future<void> onLoad() async {
//     sprite = await gameRef.loadSprite(imagePath);

//     // --- Type Correction Here ---
//     // All variables involved in size calculation are explicitly 'double'
//     final double minSize = 30.0;
//     final double maxSize = 60.0;
//     final double sizeValue = minSize + _rng.nextDouble() * (maxSize - minSize);
    
//     // Vector2 takes doubles, which is safe.
//     size = Vector2(sizeValue, sizeValue);

//     anchor = Anchor.topCenter;

//     return super.onLoad();
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     // position.y update is safe (double += double * double)
//     position.y += speed * dt;

//     // Remove the pebble when it falls off the screen
//     if (position.y > gameRef.size.y) {
//       removeFromParent();
//     }
//   }
// }


import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class FallingPebble extends SpriteComponent with HasGameRef<FlameGame> {
  final double speed = 150.0; // Vertical speed
  final String imagePath;
  final Random _rng = Random();

  late double horizontalSpeed; // NEW: horizontal (slant) speed

  FallingPebble({required this.imagePath}) : super();

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(imagePath);

    // Random pebble size
    final double minSize = 30.0;
    final double maxSize = 60.0;
    final double sizeValue = minSize + _rng.nextDouble() * (maxSize - minSize);
    size = Vector2(sizeValue, sizeValue);

    // Random slant direction and strength
    // Between -50 (leftward) and +50 (rightward) pixels per second
    horizontalSpeed = _rng.nextDouble() * 100 - 50;

    anchor = Anchor.topCenter;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move down + sideways for slant effect
    position.y += speed * dt;
    position.x += horizontalSpeed * dt;

    // Remove pebble if it leaves screen
    if (position.y > gameRef.size.y ||
        position.x < -size.x ||
        position.x > gameRef.size.x + size.x) {
      removeFromParent();
    }
  }
}
