import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/start_game_screen.dart';

class UsernameGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF0F0F1E);

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'assets/bg.png',
      'assets/app_title.png',
      'assets/board.png',
    ]);

    add(
      SpriteComponent(
        sprite: Sprite(images.fromCache('assets/bg.png')),
        size: size,
      )..priority = -10,
    );

    add(
      SpriteComponent(
        sprite: Sprite(images.fromCache('assets/app_title.png')),
        size: Vector2(450, 400),
        position: Vector2(size.x / 2, size.y * 0.30),
        anchor: Anchor.center,
      ),
    );

    // Board Image
    add(
      SpriteComponent(
        sprite: Sprite(images.fromCache('assets/board.png')),
        size: Vector2(220, 200),
        position: Vector2(size.x / 2, size.y * 0.83),
        anchor: Anchor.center,
      )..priority = -1,
    );
  }
}

class UsernameScreen extends StatefulWidget {
  final AudioPlayer bgmPlayer;
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final musicLevel;
  const UsernameScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
    required this.bgmPlayer,
    required this.musicLevel,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final UsernameGame _usernameGame = UsernameGame();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();

  bool _isButtonHovered = false;

  static const String InputOverlayKey = 'InputOverlay';

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handlePlayGame() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      widget.showError('Please enter a username to continue');
      return;
    }
    if (username.length < 3) {
      widget.showError('Username must be at least 3 characters');
      return;
    }
    if (username.length > 20) {
      widget.showError('Username must be less than 20 characters');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        widget.showError('No user is signed in.');
        return;
      }

      await user.updateDisplayName(username);
      await user.reload();

      await _firestoreService.saveUser(user.uid, username);

      debugPrint('✅ User data saved successfully with name: $username');

      final StartMenuGame game = StartMenuGame(
        bgmPlayer: widget.bgmPlayer,
        navigateToScreen: widget.navigateToScreen,
        showError: widget.showError,
        musiclevel: widget.musicLevel,
      );

      widget.navigateToScreen(flame.GameWidget(game: game));
    } catch (e) {
      widget.showError('Failed to save user data: $e');
    }
  }

  Widget _buildInputSectionOverlay(
    BuildContext overlayContext,
    UsernameGame game,
  ) {
    final screenSize = MediaQuery.of(overlayContext).size;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.45,
        bottom: MediaQuery.of(overlayContext).viewInsets.bottom,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Your Username",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Gap(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  counterStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
            const SizedBox(height: 30),

            MouseRegion(
              onEnter: (_) => setState(() => _isButtonHovered = true),
              onExit: (_) => setState(() => _isButtonHovered = false),
              child: GestureDetector(
                onTap: _handlePlayGame,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: screenSize.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC300),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          _isButtonHovered ? 0.8 : 0.4,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'PLAY',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: flame.GameWidget(
        game: _usernameGame,
        overlayBuilderMap: {InputOverlayKey: _buildInputSectionOverlay},
        initialActiveOverlays: const [InputOverlayKey],
      ),
    );
  }
}
