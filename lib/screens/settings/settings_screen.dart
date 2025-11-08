
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:sungka/screens/components/game_back_button.dart';
import 'package:sungka/screens/components/logout_button.dart';
import 'package:sungka/screens/home_screen.dart';

class SettingsGame extends FlameGame with TapDetector, PanDetector {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  SettingsGame({required this.navigateToScreen, required this.showError});

  double soundLevel = 0.8;
  double musicLevel = 0.6;

  final AudioPlayer _musicPlayer = AudioPlayer();

  late final GameBackButton backButton = GameBackButton(
    onPressed: () => navigateToScreen(
      GameWidget(
        game: HomeGame(
          navigateToScreen: navigateToScreen,
          showError: showError,
        ),
      ),
    ),
    primaryColor: AppColors.titleColor,
    accentColor: AppColors.primary,
  );

  late final LogoutButton logoutButton = LogoutButton(
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      
      navigateToScreen(
        AuthScreen(
          navigateToScreen: navigateToScreen,
          showError: showError,
        ),
      );
    },
    backgroundColor: Colors.redAccent,
    textColor: Colors.white,
    label: "Logout",
  );

  final TextComponent titleText = TextComponent(
    text: "Settings",
    textRenderer: TextPaint(
      style: GoogleFonts.poppins(
        color: const Color(0xFFFFD700),
        fontSize: 48,
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(
            offset: const Offset(0, 4),
            blurRadius: 12,
            color: const Color(0xFFE67E22).withOpacity(0.6),
          ),
          Shadow(
            offset: const Offset(0, 8),
            blurRadius: 20,
            color: const Color(0xFFE67E22).withOpacity(0.3),
          ),
        ],
      ),
    ),
    anchor: Anchor.center,
  );

  final TextComponent soundLabel = TextComponent(
    text: "Sound Volume",
    textRenderer: TextPaint(
      style: TextStyle(
        fontSize: 22,
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    anchor: Anchor.center,
  );

  final TextComponent musicLabel = TextComponent(
    text: "Music Volume",
    textRenderer: TextPaint(
      style: TextStyle(
        fontSize: 22,
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    anchor: Anchor.center,
  );

  final RectangleComponent soundBar = RectangleComponent(
    size: Vector2(250, 12),
    paint: Paint()..color = Colors.brown.shade400,
    anchor: Anchor.center,
  );

  final RectangleComponent musicBar = RectangleComponent(
    size: Vector2(250, 12),
    paint: Paint()..color = Colors.brown.shade400,
    anchor: Anchor.center,
  );

  final CircleComponent soundKnob = CircleComponent(
    radius: 12,
    paint: Paint()..color = Colors.amber,
    anchor: Anchor.center,
  );

  final CircleComponent musicKnob = CircleComponent(
    radius: 12,
    paint: Paint()..color = Colors.amber,
    anchor: Anchor.center,
  );

  @override
  Color backgroundColor() => const Color(0xFF101010);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(titleText);
    add(backButton);
    add(logoutButton);
    add(soundLabel);
    add(musicLabel);
    add(soundBar);
    add(musicBar);
    add(soundKnob);
    add(musicKnob);

    try {
      await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
      _musicPlayer.setReleaseMode(ReleaseMode.loop);
      _musicPlayer.setVolume(musicLevel);
      _musicPlayer.resume();
    } catch (e) {
      debugPrint('Error loading music: $e');
    }
  }


  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _layout(newSize);
  }

  void _layout(Vector2 screenSize) {
    titleText.position = Vector2(screenSize.x / 2, screenSize.y * 0.1);
    
    backButton.position = Vector2(backButton.size.x / 2 + 20, backButton.size.y / 2 + 20);

    soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
    soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
    soundKnob.position = Vector2(
      soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
      soundBar.position.y,
    );

    musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
    musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
    musicKnob.position = Vector2(
      musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
      musicBar.position.y,
    );

    logoutButton.anchor = Anchor.center;
    logoutButton.position = Vector2(
      screenSize.x / 2,
      screenSize.y * 0.8,
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    _handleTouch(info.eventPosition.global);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _handleTouch(info.eventPosition.global);
  }

  void _handleTouch(Vector2 pos) {
    if (_isInBar(pos, soundBar)) {
      soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
          .clamp(0.0, 1.0);
      soundKnob.position = Vector2(
        soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
        soundBar.position.y,
      );
      
    }

    if (_isInBar(pos, musicBar)) {
      musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
          .clamp(0.0, 1.0);
      musicKnob.position = Vector2(
        musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
        musicBar.position.y,
      );

      _musicPlayer.setVolume(musicLevel);
    }
  }

  bool _isInBar(Vector2 pos, RectangleComponent bar) {
    
    bool withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
        pos.x <= bar.position.x + bar.size.x / 2;
    
    bool withinY = (pos.y - bar.position.y).abs() <= 20;

    return withinX && withinY;
  }
}