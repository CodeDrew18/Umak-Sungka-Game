import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/auth/auth_game.dart';
import 'package:sungka/screens/start_game_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

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
      onGoogleSignIn: _handleGoogleSignIn,
      onGuestSignIn: _handleGuestSignIn,
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await authService.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StartGameScreen()),
        );
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  Future<void> _handleGuestSignIn() async {
    try {
      final userCredential = await authService.signInAsGuest();
      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, null);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StartGameScreen()),
          );

          //           Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => UsernameScreen()),
          // );
      }
    } catch (e) {
      print('Guest Sign-In Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: authGame),
    );
  }

  @override
  void dispose() {
    authGame.removeFromParent();
    super.dispose();
  }
}
