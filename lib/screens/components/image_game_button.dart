import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

class ImageGameButton extends SpriteComponent with TapCallbacks {
  final String spritePath;
  final VoidCallback onPressed;

  ImageGameButton({
    required this.spritePath,
    required this.onPressed,
    super.position,
    super.size,
    super.priority,
  }) : super(anchor: Anchor.center); // Set anchor to center for easier positioning

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load the sprite from the assets path
    sprite = await Sprite.load(spritePath);
  }

@override
bool containsLocalPoint(Vector2 point) {
  // FIX: Convert the component's size to a Rect and the point to an Offset 
  // to perform the correct containment check.
  return size.toRect().contains(point.toOffset()); 
}

  @override
  void onTapDown(TapDownEvent event) {
    // Optional: Add a visual feedback on tap down, like scaling down
    scale = Vector2.all(0.95);
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Restore size and trigger action on tap up
    onPressed();
    scale = Vector2.all(1.0);
  }
  
  @override
  void onTapCancel(TapCancelEvent event) {
    // Restore size on cancel
    scale = Vector2.all(1.0);
  }
}