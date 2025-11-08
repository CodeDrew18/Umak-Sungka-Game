import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/components/play_button.dart';
import 'package:sungka/screens/home_screen.dart';

class StartMenuGame extends FlameGame with TapCallbacks {
final Function(Widget screen) navigateToScreen;
final Function(String message) showError;
    final AudioPlayer _musicPlayer = AudioPlayer();
StartMenuGame({
required this.navigateToScreen,
required this.showError,
});

late PlayButton playButtonComponent;

@override
Future<void> onLoad() async {

await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
_musicPlayer.setReleaseMode(ReleaseMode.loop);
_musicPlayer.resume();
await super.onLoad();

final backgroundSprite = await loadSprite('assets/bg.png');
final backgroundImage = SpriteComponent(
sprite: backgroundSprite,
size: size,
priority: -1,
);
add(backgroundImage);

final titleSprite = await loadSprite('assets/app_title.png');
final titleImageComponent = SpriteComponent(
sprite: titleSprite,
size: Vector2(450, 400),
anchor: Anchor.center,
position: Vector2(size.x / 2, size.y * 0.35),
priority: 0,
);
add(titleImageComponent);

playButtonComponent = PlayButton(
  spritePath: 'assets/play_button.png',
  size: Vector2(220, 80),
  position: Vector2(size.x / 2, size.y * 0.60),
  priority: 1,
  onPressed: () {
    navigateToScreen(
      GameWidget(
        game: HomeGame(
          navigateToScreen: navigateToScreen,
          showError: showError,
        ),
      ),
    );
  },
);
add(playButtonComponent);
}
}