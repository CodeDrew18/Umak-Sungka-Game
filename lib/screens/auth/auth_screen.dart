import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/auth/auth_game.dart';
import 'package:sungka/screens/start_game_screen.dart';
import 'package:sungka/screens/username_screen.dart';

class AuthScreen extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;
  final musicLevel;
  const AuthScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
    required this.bgmPlayer,
    required this.musicLevel
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authService = FirebaseAuthService();
  final firestoreService = FirebaseFirestoreService();
  late AuthGame authGame;

  @override
  void initState() {
    super.initState();
    authGame = AuthGame(
      onGoogleSignIn: signInWithGoogle,
      onGuestSignIn: _handleGuestSignIn,
    );
  }

  void signInWithGoogle() async {
    if (!mounted) return;

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential == null) {
        return;
      }

      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, user.displayName);

        if (mounted) {
          final nextScreen = GameWidget(
            game: StartMenuGame(
              bgmPlayer: widget.bgmPlayer,
              navigateToScreen: widget.navigateToScreen,
              showError: widget.showError,
              musiclevel: widget.musicLevel
            ),
          );

          widget.navigateToScreen(nextScreen);
        }
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');

      if (mounted) {
        widget.showError('Failed to sign in with Google. Please try again.');
      }
    }
  }

  Future<void> _handleGuestSignIn() async {
    if (!mounted) return;
    try {
      final userCredential = await authService.signInAsGuest();
      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, null);

        if (mounted) {
          final nextScreen = UsernameScreen(
            bgmPlayer: widget.bgmPlayer,
            navigateToScreen: widget.navigateToScreen,
            showError: widget.showError,
            musicLevel: widget.musicLevel,
          );
          widget.navigateToScreen(nextScreen);
        }
      }
    } catch (e) {
      print('Guest Sign-In Error: $e');
      if (mounted) {
        widget.showError('Failed to sign in as guest. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: authGame));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
