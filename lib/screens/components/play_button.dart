import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

class PlayButton extends SpriteComponent with TapCallbacks {
 final String spritePath;
 final VoidCallback onPressed;
 
 // Store the initial scale to ensure proper restoration if needed, though Vector2.all(1.0) works fine.
 final Vector2 initialScale = Vector2.all(1.0); 

 PlayButton({
  required this.spritePath,
  required this.onPressed,
  super.position,
  super.size,
  super.priority,
 }) : super(anchor: Anchor.center);

 @override
 Future<void> onLoad() async {
  await super.onLoad();
  sprite = await Sprite.load(spritePath);
 }

 @override
 void onTapDown(TapDownEvent event) {
  // Apply scale down for visual feedback
  scale = Vector2.all(0.8); 
 }

 @override
 void onTapUp(TapUpEvent event) {
  // Check if the tap ended within the bounds
  if (containsLocalPoint(event.localPosition)) {
        // FIX: Restore scale FIRST, then navigate.
        // This ensures the button visually resets before the screen transition begins.
    scale = initialScale; 
    onPressed(); 
  } else {
        // If the tap ended outside, just restore the scale.
        scale = initialScale;
    }
 }
 
 @override
 void onTapCancel(TapCancelEvent event) {
  // Restore size on cancel
  scale = initialScale;
 }
}