
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:sungka/screens/components/play_button.dart';
// import 'package:sungka/screens/home_screen.dart';

// class StartMenuGame extends FlameGame with TapCallbacks {
// final Function(Widget screen) navigateToScreen;
// final Function(String message) showError;
// StartMenuGame({
// required this.navigateToScreen,
// required this.showError,
// });

// late PlayButton playButtonComponent;

// @override
// Future<void> onLoad() async {

// await super.onLoad();

// final backgroundSprite = await loadSprite('assets/bg.png');
// final backgroundImage = SpriteComponent(
// sprite: backgroundSprite,
// size: size,
// priority: -1,
// );
// add(backgroundImage);

// final titleSprite = await loadSprite('assets/app_title.png');
// final titleImageComponent = SpriteComponent(
// sprite: titleSprite,
// size: Vector2(450, 400),
// anchor: Anchor.center,
// position: Vector2(size.x / 2, size.y * 0.35),
// priority: 0,
// );
// add(titleImageComponent);

// playButtonComponent = PlayButton(
//   spritePath: 'assets/play_button.png',
//   size: Vector2(220, 80),
//   position: Vector2(size.x / 2, size.y * 0.60),
//   priority: 1,
//   onPressed: () {
//     navigateToScreen(
//       Scaffold(
//         body: GameWidget(
//           game: HomeGame(
//             navigateToScreen: navigateToScreen,
//             showError: showError,
//           ),
//         ),
//       ),
//     );
//   },
// );
// add(playButtonComponent);
// }
// }




import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/components/play_button.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/components/falling_pebble.dart'; // REQUIRED IMPORT
import 'dart:math';

class StartMenuGame extends FlameGame with TapCallbacks {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;
  StartMenuGame({required this.navigateToScreen, required this.showError, required this.bgmPlayer});

  late PlayButton playButtonComponent;

  // List of the images to fall. Assuming your files are in the 'assets/' folder.
  final List<String> pebbleImagePaths = [
    'assets/pebble1.png',
    'assets/pebble2.png',
    'assets/pebble3.png',
  ];
  

  late Timer pebbleSpawnTimer;
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // --- Background and Title ---

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

    // --- Play Button ---

    playButtonComponent = PlayButton(
      spritePath: 'assets/play_button.png',
      size: Vector2(220, 80),
      position: Vector2(size.x / 2, size.y * 0.60),
      priority: 1,
      onPressed: () {
        navigateToScreen(
          Scaffold(
            body: GameWidget(
              game: HomeGame(
                bgmPlayer: bgmPlayer,
                navigateToScreen: navigateToScreen,
                showError: showError,
              ),
            ),
          ),
        );
      },
    );
    add(playButtonComponent);

    // --- Falling Pebble Logic ---

    // Initialize the timer to trigger every 0.5 seconds
    pebbleSpawnTimer = Timer(0.5, onTick: _spawnPebble, repeat: true);
    pebbleSpawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    pebbleSpawnTimer.update(dt);
  }

  // Function to spawn a new pebble
void _spawnPebble() {
    final String imagePath =
        pebbleImagePaths[_rng.nextInt(pebbleImagePaths.length)];

    final pebble = FallingPebble(imagePath: imagePath);

    // Add the pebble first
    add(pebble);

    // Wait for the pebble to load (which sets its size) before positioning it.
    pebble.onLoad().then((_) {
      // randomX is a double, which is correct
      final double randomX = _rng.nextDouble() * size.x;
      
      // Vector2 takes doubles, which is correct.
      pebble.position = Vector2(
        randomX,
        -pebble.size.y,
      );
      
      pebble.priority = -1;
    });
  }
}