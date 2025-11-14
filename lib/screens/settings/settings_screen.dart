import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:sungka/screens/components/game_back_button.dart';
import 'package:sungka/screens/components/logout_button.dart';
import 'package:sungka/screens/components/pebble_bounce.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsGame extends FlameGame with TapDetector, PanDetector {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final BuildContext? flutterContext;
  final AudioPlayer bgmPlayer;

  SettingsGame({
    required this.navigateToScreen,
    required this.showError,
    this.flutterContext,
    required this.bgmPlayer
  });

  double soundLevel = 0.8;
  double musicLevel = 1.0;

  GameBackButton? backButton;
  LogoutButton? logoutButton;

  SpriteComponent? backgroundSprite;
  SpriteComponent? titleSprite;

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
    paint: Paint()..color = Colors.brown,
    anchor: Anchor.center,
  );

  final RectangleComponent musicBar = RectangleComponent(
    size: Vector2(250, 12),
    paint: Paint()..color = Colors.brown,
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

    final bgSprite = await Sprite.load('assets/bg.png');
    backgroundSprite = SpriteComponent(
      sprite: bgSprite,
      size: size,
      anchor: Anchor.topLeft,
    );
    add(backgroundSprite!);

    final tSprite = await Sprite.load('assets/settings.png');
    titleSprite = SpriteComponent(
      sprite: tSprite,
      size: Vector2(420, 400),
      anchor: Anchor.center,
    );
    add(titleSprite!);

    backButton = GameBackButton(
      onPressed: () async {
        if (flutterContext != null) {
          final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
          Overlay.of(flutterContext!).insert(overlay);
          await Future.delayed(const Duration(milliseconds: 300));
          overlay.remove();
        }
        navigateToScreen(
          GameWidget(
            game: HomeGame(
              bgmPlayer: bgmPlayer,
              navigateToScreen: navigateToScreen,
              showError: showError,
            ),
          ),
        );
      },
      primaryColor: AppColors.titleColor,
      accentColor: AppColors.primary,
    );
    add(backButton!);

    logoutButton = LogoutButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        navigateToScreen(
          AuthScreen(navigateToScreen: navigateToScreen, showError: showError, bgmPlayer: bgmPlayer,),
        );
      },
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      label: "Logout",
    );
    add(logoutButton!);

    add(soundLabel);
    add(musicLabel);
    add(soundBar);
    add(musicBar);
    add(soundKnob);
    add(musicKnob);

    
    bgmPlayer.setVolume(musicLevel);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    backgroundSprite?.size = newSize;
    _layout(newSize);
  }

  void _layout(Vector2 screenSize) {
    titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.20);
    backButton?.position = Vector2(
      backButton!.size.x / 2 - 10,
      backButton!.size.y / 2,
    );

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

    logoutButton?.anchor = Anchor.center;
    logoutButton?.position = Vector2(screenSize.x / 2, screenSize.y * 0.8);
  }

  @override
  void onTapDown(TapDownInfo info) => _handleTouch(info.eventPosition.global);
  @override
  void onPanUpdate(DragUpdateInfo info) =>
      _handleTouch(info.eventPosition.global);

  void _handleTouch(Vector2 pos) {
    if (_isInBar(pos, soundBar)) {
      soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) /
              soundBar.size.x)
          .clamp(0.0, 1.0);
      soundKnob.position = Vector2(
        soundBar.position.x -
            soundBar.size.x / 2 +
            soundBar.size.x * soundLevel,
        soundBar.position.y,
      );
    }

    if (_isInBar(pos, musicBar)) {
      musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) /
              musicBar.size.x)
          .clamp(0.0, 1.0);
      musicKnob.position = Vector2(
        musicBar.position.x -
            musicBar.size.x / 2 +
            musicBar.size.x * musicLevel,
        musicBar.position.y,
      );
      bgmPlayer.setVolume(musicLevel);
    }
  }

  bool _isInBar(Vector2 pos, RectangleComponent bar) {
    final withinX =
        pos.x >= bar.position.x - bar.size.x / 2 &&
        pos.x <= bar.position.x + bar.size.x / 2;
    final withinY = (pos.y - bar.position.y).abs() <= 20;
    return withinX && withinY;
  }
}
