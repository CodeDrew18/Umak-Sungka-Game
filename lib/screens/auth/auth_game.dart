
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

    // Add particle background
    particleBackground = ParticleBackground();
    add(particleBackground);

    // Wait a frame to ensure size is available
    await Future.delayed(const Duration(milliseconds: 50));

    // Add animated title
    titleComponent = AnimatedTitle();
    add(titleComponent!);

    // Gap between buttons
    const double gap = 90;

    // Add Google Sign-In button
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

    // Add Guest Sign-In button below Google button
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

    // Reposition elements when the window resizes
    const double gap = 90;

    titleComponent?.position = Vector2(newSize.x / 2, newSize.y * 0.25);
    googleButton?.position = Vector2(newSize.x / 2, newSize.y * 0.65);
    guestButton?.position = Vector2(newSize.x / 2, newSize.y * 0.65 + gap);
  }
}
