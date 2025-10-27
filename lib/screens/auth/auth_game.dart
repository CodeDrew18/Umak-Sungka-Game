
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/auth/components/animated_title.dart';
import 'package:sungka/screens/auth/components/game_button.dart';
import 'package:sungka/screens/auth/components/particle_background.dart';

class AuthGame extends FlameGame {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onGuestSignIn;

  late ParticleBackground particleBackground;
  AnimatedTitle? titleComponent;
  GameButton? googleButton;
  GameButton? guestButton;

  AuthGame({
    required this.onGoogleSignIn,
    required this.onGuestSignIn,
  });

  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    particleBackground = ParticleBackground();
    add(particleBackground);

    await Future.delayed(const Duration(milliseconds: 50));

    titleComponent = AnimatedTitle();
    add(titleComponent!);


    const double gap = 90;


    googleButton = GameButton(
      position: Vector2(size.x / 2, size.y * 0.65),
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
      position: Vector2(size.x / 2, size.y * 0.65 + gap),
      width: 280,
      height: 70,
      label: 'Continue as Guest',
      backgroundColor: const Color(0xFFE6B428),
      textColor: Colors.black,
      onPressed: onGuestSignIn,
      hasIcon: false,
    );
    add(guestButton!);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);

    const double gap = 90;

    titleComponent?.position = Vector2(newSize.x / 2, newSize.y * 0.25);
    googleButton?.position = Vector2(newSize.x / 2, newSize.y * 0.65);
    guestButton?.position = Vector2(newSize.x / 2, newSize.y * 0.65 + gap);
  }
}
