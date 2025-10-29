import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/components/animated_title.dart';
import 'package:sungka/screens/components/game_button.dart';
import 'package:sungka/screens/components/particle_background.dart';
import 'package:sungka/screens/components/water_effect.dart';

class AuthGame extends FlameGame {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onGuestSignIn;

  ParticleBackground? particleBackground;
  AnimatedTitle? titleComponent;
  GameButton? googleButton;
  GameButton? guestButton;
  WaterEffect? waterEffect;

  AuthGame({
    required this.onGoogleSignIn,
    required this.onGuestSignIn,
  });

  @override
  Color backgroundColor() => const Color(0xFF1E1E1E);

  @override
  Future<void> onLoad() async {
    waterEffect = WaterEffect();
    add(waterEffect!);

    particleBackground = ParticleBackground();
    add(particleBackground!);

    titleComponent = AnimatedTitle();
    add(titleComponent!);

    googleButton = GameButton(
      position: Vector2(size.x / 2, size.y * 0.55),
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
      position: Vector2(size.x / 2, size.y * 0.78),
      width: 280,
      height: 70,
      label: 'Continue as Guest',
      backgroundColor: const Color(0xFFE6B428),
      textColor: Colors.white,
      onPressed: onGuestSignIn,
      hasIcon: false,
    );
    add(guestButton!);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    googleButton?.position = Vector2(newSize.x / 2, newSize.y * 0.55);
    guestButton?.position = Vector2(newSize.x / 2, newSize.y * 0.78);
    titleComponent?.position = Vector2(newSize.x / 2, newSize.y * 0.25);
  }
}