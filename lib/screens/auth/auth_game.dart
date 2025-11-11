import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/components/game_button.dart';

class AuthGame extends FlameGame {
 final VoidCallback onGoogleSignIn;
 final VoidCallback onGuestSignIn;

 SpriteComponent? backgroundImage;
 GameButton? googleButton;
 GameButton? guestButton;
 SpriteComponent? titleImageComponent; 

 AuthGame({
  required this.onGoogleSignIn,
  required this.onGuestSignIn,
 });

 @override
 Color backgroundColor() => Colors.transparent;

 @override
 Future<void> onLoad() async {
  backgroundImage = SpriteComponent()
   ..sprite = await loadSprite('assets/bg.png')
   ..size = size
   ..anchor = Anchor.topLeft
   ..priority = -1;
  add(backgroundImage!);

  final titleSprite = await loadSprite('assets/app_title.png');
  titleImageComponent = SpriteComponent( 
   sprite: titleSprite,
   size: Vector2(450, 400),
   anchor: Anchor.center,
   position: Vector2(size.x / 2, size.y * 0.35),
   priority: 0,
  );
  add(titleImageComponent!);

  googleButton = GameButton(
   position: Vector2(size.x / 2, size.y * 0.58), 
   width: 280,
   height: 70,
   label: 'Continue with Google',
   backgroundColor: Colors.white,
   textColor: Colors.black,
   onPressed: onGoogleSignIn,
   hasIcon: true,
   iconPath: 'assets/google.png',
  );
  add(googleButton!);

  guestButton = GameButton(
   position: Vector2(size.x / 2, size.y * 0.70), 
   width: 280,
   height: 70,
   label: 'Continue as Guest',
   backgroundColor: AppColors.gamebuttonPrimary,
   textColor: AppColors.white,
   onPressed: onGuestSignIn,
   hasIcon: false,
  );
  add(guestButton!);
 }

 @override
 void onGameResize(Vector2 newSize) {
  super.onGameResize(newSize);

  backgroundImage?.size = newSize;

  titleImageComponent?.position = Vector2(newSize.x / 2, newSize.y * 0.35);
  googleButton?.position = Vector2(newSize.x / 2, newSize.y * 0.55);
  guestButton?.position = Vector2(newSize.x / 2, newSize.y * 0.65);
 }
}