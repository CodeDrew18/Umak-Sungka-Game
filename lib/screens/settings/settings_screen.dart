
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flame/components.dart';
// // // // import 'package:flame/events.dart';
// // // // import 'package:flame/game.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:audioplayers/audioplayers.dart';
// // // // import 'package:sungka/core/constants/app_colors.dart';
// // // // import 'package:sungka/screens/auth/auth_screen.dart';
// // // // import 'package:sungka/screens/components/game_back_button.dart';
// // // // import 'package:sungka/screens/components/logout_button.dart';
// // // // import 'package:sungka/screens/home_screen.dart';

// // // // class SettingsGame extends FlameGame with TapDetector, PanDetector {
// // // //   final Function(Widget screen) navigateToScreen;
// // // //   final Function(String message) showError;

// // // //   SettingsGame({required this.navigateToScreen, required this.showError});

// // // //   double soundLevel = 0.8;
// // // //   double musicLevel = 0.6;

// // // //   final AudioPlayer _musicPlayer = AudioPlayer();

// // // //   late final GameBackButton backButton = GameBackButton(
// // // //     onPressed: () => navigateToScreen(
// // // //       GameWidget(
// // // //         game: HomeGame(
// // // //           navigateToScreen: navigateToScreen,
// // // //           showError: showError,
// // // //         ),
// // // //       ),
// // // //     ),
// // // //     primaryColor: AppColors.titleColor,
// // // //     accentColor: AppColors.primary,
// // // //   );

// // // //   late final LogoutButton logoutButton = LogoutButton(
// // // //     onPressed: () async {
// // // //       await FirebaseAuth.instance.signOut();
      
// // // //       navigateToScreen(
// // // //         AuthScreen(
// // // //           navigateToScreen: navigateToScreen,
// // // //           showError: showError,
// // // //         ),
// // // //       );
// // // //     },
// // // //     backgroundColor: Colors.redAccent,
// // // //     textColor: Colors.white,
// // // //     label: "Logout",
// // // //   );

// // // //   final TextComponent titleText = TextComponent(
// // // //     text: "Settings",
// // // //     textRenderer: TextPaint(
// // // //       style: GoogleFonts.poppins(
// // // //         color: const Color(0xFFFFD700),
// // // //         fontSize: 48,
// // // //         fontWeight: FontWeight.w800,
// // // //         shadows: [
// // // //           Shadow(
// // // //             offset: const Offset(0, 4),
// // // //             blurRadius: 12,
// // // //             color: const Color(0xFFE67E22).withOpacity(0.6),
// // // //           ),
// // // //           Shadow(
// // // //             offset: const Offset(0, 8),
// // // //             blurRadius: 20,
// // // //             color: const Color(0xFFE67E22).withOpacity(0.3),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     ),
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final TextComponent soundLabel = TextComponent(
// // // //     text: "Sound Volume",
// // // //     textRenderer: TextPaint(
// // // //       style: TextStyle(
// // // //         fontSize: 22,
// // // //         color: Colors.orangeAccent,
// // // //         fontWeight: FontWeight.bold,
// // // //       ),
// // // //     ),
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final TextComponent musicLabel = TextComponent(
// // // //     text: "Music Volume",
// // // //     textRenderer: TextPaint(
// // // //       style: TextStyle(
// // // //         fontSize: 22,
// // // //         color: Colors.orangeAccent,
// // // //         fontWeight: FontWeight.bold,
// // // //       ),
// // // //     ),
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final RectangleComponent soundBar = RectangleComponent(
// // // //     size: Vector2(250, 12),
// // // //     paint: Paint()..color = Colors.brown.shade400,
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final RectangleComponent musicBar = RectangleComponent(
// // // //     size: Vector2(250, 12),
// // // //     paint: Paint()..color = Colors.brown.shade400,
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final CircleComponent soundKnob = CircleComponent(
// // // //     radius: 12,
// // // //     paint: Paint()..color = Colors.amber,
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   final CircleComponent musicKnob = CircleComponent(
// // // //     radius: 12,
// // // //     paint: Paint()..color = Colors.amber,
// // // //     anchor: Anchor.center,
// // // //   );

// // // //   @override
// // // //   Color backgroundColor() => const Color(0xFF101010);

// // // //   @override
// // // //   Future<void> onLoad() async {
// // // //     await super.onLoad();
// // // //     add(titleText);
// // // //     add(backButton);
// // // //     add(logoutButton);
// // // //     add(soundLabel);
// // // //     add(musicLabel);
// // // //     add(soundBar);
// // // //     add(musicBar);
// // // //     add(soundKnob);
// // // //     add(musicKnob);

// // // //     try {
// // // //       await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
// // // //       _musicPlayer.setReleaseMode(ReleaseMode.loop);
// // // //       _musicPlayer.setVolume(musicLevel);
// // // //       _musicPlayer.resume();
// // // //     } catch (e) {
// // // //       debugPrint('Error loading music: $e');
// // // //     }
// // // //   }


// // // //   @override
// // // //   void onGameResize(Vector2 newSize) {
// // // //     super.onGameResize(newSize);
// // // //     _layout(newSize);
// // // //   }

// // // //   void _layout(Vector2 screenSize) {
// // // //     titleText.position = Vector2(screenSize.x / 2, screenSize.y * 0.1);
    
// // // //     backButton.position = Vector2(backButton.size.x / 2 + 20, backButton.size.y / 2 + 20);

// // // //     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
// // // //     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
// // // //     soundKnob.position = Vector2(
// // // //       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// // // //       soundBar.position.y,
// // // //     );

// // // //     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
// // // //     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
// // // //     musicKnob.position = Vector2(
// // // //       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// // // //       musicBar.position.y,
// // // //     );

// // // //     logoutButton.anchor = Anchor.center;
// // // //     logoutButton.position = Vector2(
// // // //       screenSize.x / 2,
// // // //       screenSize.y * 0.8,
// // // //     );
// // // //   }

// // // //   @override
// // // //   void onTapDown(TapDownInfo info) {
// // // //     _handleTouch(info.eventPosition.global);
// // // //   }

// // // //   @override
// // // //   void onPanUpdate(DragUpdateInfo info) {
// // // //     _handleTouch(info.eventPosition.global);
// // // //   }

// // // //   void _handleTouch(Vector2 pos) {
// // // //     if (_isInBar(pos, soundBar)) {
// // // //       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
// // // //           .clamp(0.0, 1.0);
// // // //       soundKnob.position = Vector2(
// // // //         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// // // //         soundBar.position.y,
// // // //       );
      
// // // //     }

// // // //     if (_isInBar(pos, musicBar)) {
// // // //       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
// // // //           .clamp(0.0, 1.0);
// // // //       musicKnob.position = Vector2(
// // // //         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// // // //         musicBar.position.y,
// // // //       );

// // // //       _musicPlayer.setVolume(musicLevel);
// // // //     }
// // // //   }

// // // //   bool _isInBar(Vector2 pos, RectangleComponent bar) {
    
// // // //     bool withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
// // // //         pos.x <= bar.position.x + bar.size.x / 2;
    
// // // //     bool withinY = (pos.y - bar.position.y).abs() <= 20;

// // // //     return withinX && withinY;
// // // //   }
// // // // }





// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flame/components.dart';
// // // import 'package:flame/events.dart';
// // // import 'package:flame/game.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:audioplayers/audioplayers.dart';
// // // import 'package:sungka/core/constants/app_colors.dart';
// // // import 'package:sungka/screens/auth/auth_screen.dart';
// // // import 'package:sungka/screens/home_screen.dart';
// // // import 'package:sungka/screens/components/game_back_button.dart';
// // // import 'package:sungka/screens/components/logout_button.dart';

// // // class SettingsGame extends FlameGame with TapDetector, PanDetector {
// // //   final Function(Widget screen) navigateToScreen;
// // //   final Function(String message) showError;

// // //   SettingsGame({required this.navigateToScreen, required this.showError});

// // //   double soundLevel = 0.8;
// // //   double musicLevel = 0.6;

// // //   final AudioPlayer _musicPlayer = AudioPlayer();

// // //   late final GameBackButton backButton = GameBackButton(
// // //     onPressed: () => navigateToScreen(
// // //       GameWidget(
// // //         game: HomeGame(
// // //           navigateToScreen: navigateToScreen,
// // //           showError: showError,
// // //         ),
// // //       ),
// // //     ),
// // //     primaryColor: AppColors.titleColor,
// // //     accentColor: AppColors.primary,
// // //   );

// // //   late final LogoutButton logoutButton = LogoutButton(
// // //     onPressed: () async {
// // //       await FirebaseAuth.instance.signOut();
// // //       navigateToScreen(
// // //         AuthScreen(
// // //           navigateToScreen: navigateToScreen,
// // //           showError: showError,
// // //         ),
// // //       );
// // //     },
// // //     backgroundColor: Colors.redAccent,
// // //     textColor: Colors.white,
// // //     label: "Logout",
// // //   );

// // //   late final SpriteComponent titleSprite = SpriteComponent(
// // //     sprite: Sprite.load('settings.png'),
// // //     size: Vector2(250, 80), // adjust size as needed
// // //     anchor: Anchor.center,
// // //   );

// // //   final TextComponent soundLabel = TextComponent(
// // //     text: "Sound Volume",
// // //     textRenderer: TextPaint(
// // //       style: TextStyle(
// // //         fontSize: 22,
// // //         color: Colors.orangeAccent,
// // //         fontWeight: FontWeight.bold,
// // //       ),
// // //     ),
// // //     anchor: Anchor.center,
// // //   );

// // //   final TextComponent musicLabel = TextComponent(
// // //     text: "Music Volume",
// // //     textRenderer: TextPaint(
// // //       style: TextStyle(
// // //         fontSize: 22,
// // //         color: Colors.orangeAccent,
// // //         fontWeight: FontWeight.bold,
// // //       ),
// // //     ),
// // //     anchor: Anchor.center,
// // //   );

// // //   final RectangleComponent soundBar = RectangleComponent(
// // //     size: Vector2(250, 12),
// // //     paint: Paint()..color = Colors.brown.shade400,
// // //     anchor: Anchor.center,
// // //   );

// // //   final RectangleComponent musicBar = RectangleComponent(
// // //     size: Vector2(250, 12),
// // //     paint: Paint()..color = Colors.brown.shade400,
// // //     anchor: Anchor.center,
// // //   );

// // //   final CircleComponent soundKnob = CircleComponent(
// // //     radius: 12,
// // //     paint: Paint()..color = Colors.amber,
// // //     anchor: Anchor.center,
// // //   );

// // //   final CircleComponent musicKnob = CircleComponent(
// // //     radius: 12,
// // //     paint: Paint()..color = Colors.amber,
// // //     anchor: Anchor.center,
// // //   );

// // //   @override
// // //   Color backgroundColor() => const Color(0xFF101010);

// // //   @override
// // //   Future<void> onLoad() async {
// // //     await super.onLoad();
// // //     add(titleSprite); // add sprite instead of text
// // //     add(backButton);
// // //     add(logoutButton);
// // //     add(soundLabel);
// // //     add(musicLabel);
// // //     add(soundBar);
// // //     add(musicBar);
// // //     add(soundKnob);
// // //     add(musicKnob);

// // //     try {
// // //       await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
// // //       _musicPlayer.setReleaseMode(ReleaseMode.loop);
// // //       _musicPlayer.setVolume(musicLevel);
// // //       _musicPlayer.resume();
// // //     } catch (e) {
// // //       debugPrint('Error loading music: $e');
// // //     }
// // //   }

// // //   @override
// // //   void onGameResize(Vector2 newSize) {
// // //     super.onGameResize(newSize);
// // //     _layout(newSize);
// // //   }

// // //   void _layout(Vector2 screenSize) {
// // //     titleSprite.position = Vector2(screenSize.x / 2, screenSize.y * 0.1);

// // //     backButton.position =
// // //         Vector2(backButton.size.x / 2 + 20, backButton.size.y / 2 + 20);

// // //     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
// // //     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
// // //     soundKnob.position = Vector2(
// // //       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// // //       soundBar.position.y,
// // //     );

// // //     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
// // //     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
// // //     musicKnob.position = Vector2(
// // //       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// // //       musicBar.position.y,
// // //     );

// // //     logoutButton.anchor = Anchor.center;
// // //     logoutButton.position = Vector2(
// // //       screenSize.x / 2,
// // //       screenSize.y * 0.8,
// // //     );
// // //   }

// // //   @override
// // //   void onTapDown(TapDownInfo info) {
// // //     _handleTouch(info.eventPosition.global);
// // //   }

// // //   @override
// // //   void onPanUpdate(DragUpdateInfo info) {
// // //     _handleTouch(info.eventPosition.global);
// // //   }

// // //   void _handleTouch(Vector2 pos) {
// // //     if (_isInBar(pos, soundBar)) {
// // //       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) /
// // //               soundBar.size.x)
// // //           .clamp(0.0, 1.0);
// // //       soundKnob.position = Vector2(
// // //         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// // //         soundBar.position.y,
// // //       );
// // //     }

// // //     if (_isInBar(pos, musicBar)) {
// // //       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) /
// // //               musicBar.size.x)
// // //           .clamp(0.0, 1.0);
// // //       musicKnob.position = Vector2(
// // //         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// // //         musicBar.position.y,
// // //       );

// // //       _musicPlayer.setVolume(musicLevel);
// // //     }
// // //   }

// // //   bool _isInBar(Vector2 pos, RectangleComponent bar) {
// // //     bool withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
// // //         pos.x <= bar.position.x + bar.size.x / 2;

// // //     bool withinY = (pos.y - bar.position.y).abs() <= 20;

// // //     return withinX && withinY;
// // //   }
// // // }




// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flame/components.dart';
// // import 'package:flame/events.dart';
// // import 'package:flame/game.dart';
// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:sungka/core/constants/app_colors.dart';
// // import 'package:sungka/screens/auth/auth_screen.dart';
// // import 'package:sungka/screens/components/game_back_button.dart';
// // import 'package:sungka/screens/components/logout_button.dart';
// // import 'package:sungka/screens/home_screen.dart';

// // class SettingsGame extends FlameGame with TapDetector, PanDetector {
// //   final Function(Widget screen) navigateToScreen;
// //   final Function(String message) showError;

// //   SettingsGame({required this.navigateToScreen, required this.showError});

// //   double soundLevel = 0.8;
// //   double musicLevel = 0.6;

// //   final AudioPlayer _musicPlayer = AudioPlayer();

// //   late final GameBackButton backButton = GameBackButton(
// //     onPressed: () => navigateToScreen(
// //       GameWidget(
// //         game: HomeGame(
// //           navigateToScreen: navigateToScreen,
// //           showError: showError,
// //         ),
// //       ),
// //     ),
// //     primaryColor: AppColors.titleColor,
// //     accentColor: AppColors.primary,
// //   );

// //   late final LogoutButton logoutButton = LogoutButton(
// //     onPressed: () async {
// //       await FirebaseAuth.instance.signOut();

// //       navigateToScreen(
// //         AuthScreen(
// //           navigateToScreen: navigateToScreen,
// //           showError: showError,
// //         ),
// //       );
// //     },
// //     backgroundColor: Colors.redAccent,
// //     textColor: Colors.white,
// //     label: "Logout",
// //   );

// //   // SpriteComponent for the Settings title
// // late final SpriteComponent? titleSprite;
// // late final SpriteComponent? backgroundSprite;

// //   final TextComponent soundLabel = TextComponent(
// //     text: "Sound Volume",
// //     textRenderer: TextPaint(
// //       style: TextStyle(
// //         fontSize: 22,
// //         color: Colors.orangeAccent,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //     anchor: Anchor.center,
// //   );

// //   final TextComponent musicLabel = TextComponent(
// //     text: "Music Volume",
// //     textRenderer: TextPaint(
// //       style: TextStyle(
// //         fontSize: 22,
// //         color: Colors.orangeAccent,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //     anchor: Anchor.center,
// //   );

// //   final RectangleComponent soundBar = RectangleComponent(
// //     size: Vector2(250, 12),
// //     paint: Paint()..color = Colors.brown.shade400,
// //     anchor: Anchor.center,
// //   );

// //   final RectangleComponent musicBar = RectangleComponent(
// //     size: Vector2(250, 12),
// //     paint: Paint()..color = Colors.brown.shade400,
// //     anchor: Anchor.center,
// //   );

// //   final CircleComponent soundKnob = CircleComponent(
// //     radius: 12,
// //     paint: Paint()..color = Colors.amber,
// //     anchor: Anchor.center,
// //   );

// //   final CircleComponent musicKnob = CircleComponent(
// //     radius: 12,
// //     paint: Paint()..color = Colors.amber,
// //     anchor: Anchor.center,
// //   );

// //   @override
// //   Color backgroundColor() => const Color(0xFF101010);

// //   @override
// //   Future<void> onLoad() async {
// //     await super.onLoad();

// //     // Load the title sprite asynchronously
// //     final sprite = await Sprite.load('assets/settings.png');
// //     titleSprite = SpriteComponent(
// //       sprite: sprite,
// //       size: Vector2(420, 400), // adjust as needed
// //       anchor: Anchor.center,
// //     );
// //     add(titleSprite!);

// //     final bgSprite = await Sprite.load('assets/bg.png');
// //     backgroundSprite = SpriteComponent(
// //       sprite: bgSprite,
// //       size: size, // full screen
// //       anchor: Anchor.topLeft,
// //     );
// //     add(backgroundSprite!);

// //     // Add other components
// //     add(backButton);
// //     add(logoutButton);
// //     add(soundLabel);
// //     add(musicLabel);
// //     add(soundBar);
// //     add(musicBar);
// //     add(soundKnob);
// //     add(musicKnob);

// //     try {
// //       await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
// //       _musicPlayer.setReleaseMode(ReleaseMode.loop);
// //       _musicPlayer.setVolume(musicLevel);
// //       _musicPlayer.resume();
// //     } catch (e) {
// //       debugPrint('Error loading music: $e');
// //     }
// //   }

// //   @override
// //   void onGameResize(Vector2 newSize) {
// //     super.onGameResize(newSize);
// //     _layout(newSize);
// //   }

// //   void _layout(Vector2 screenSize) {

// //     backgroundSprite?.size = screenSize;
// //     // Position title sprite
// //     titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.1);

// //     // Back button position
// //     backButton.position = Vector2(backButton.size.x / 2 + 20, backButton.size.y / 2 + 20);

// //     // Sound controls
// //     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
// //     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
// //     soundKnob.position = Vector2(
// //       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// //       soundBar.position.y,
// //     );

// //     // Music controls
// //     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
// //     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
// //     musicKnob.position = Vector2(
// //       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// //       musicBar.position.y,
// //     );

// //     // Logout button
// //     logoutButton.anchor = Anchor.center;
// //     logoutButton.position = Vector2(
// //       screenSize.x / 2,
// //       screenSize.y * 0.8,
// //     );
// //   }

// //   @override
// //   void onTapDown(TapDownInfo info) {
// //     _handleTouch(info.eventPosition.global);
// //   }

// //   @override
// //   void onPanUpdate(DragUpdateInfo info) {
// //     _handleTouch(info.eventPosition.global);
// //   }

// //   void _handleTouch(Vector2 pos) {
// //     if (_isInBar(pos, soundBar)) {
// //       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
// //           .clamp(0.0, 1.0);
// //       soundKnob.position = Vector2(
// //         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
// //         soundBar.position.y,
// //       );
// //     }

// //     if (_isInBar(pos, musicBar)) {
// //       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
// //           .clamp(0.0, 1.0);
// //       musicKnob.position = Vector2(
// //         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
// //         musicBar.position.y,
// //       );

// //       _musicPlayer.setVolume(musicLevel);
// //     }
// //   }

// //   bool _isInBar(Vector2 pos, RectangleComponent bar) {
// //     final withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
// //         pos.x <= bar.position.x + bar.size.x / 2;
// //     final withinY = (pos.y - bar.position.y).abs() <= 20;

// //     return withinX && withinY;
// //   }
// // }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/auth/auth_screen.dart';
// import 'package:sungka/screens/components/game_back_button.dart';
// import 'package:sungka/screens/components/logout_button.dart';
// import 'package:sungka/screens/components/pebble_bounce.dart';
// import 'package:sungka/screens/home_screen.dart';

// class SettingsGame extends FlameGame with TapDetector, PanDetector {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   SettingsGame({required this.navigateToScreen, required this.showError});

//   double soundLevel = 0.8;
//   double musicLevel = 0.6;

//   final AudioPlayer _musicPlayer = AudioPlayer();

//    GameBackButton? backButton;
//    LogoutButton? logoutButton;

//    SpriteComponent? backgroundSprite;
//    SpriteComponent? titleSprite;

//   final TextComponent soundLabel = TextComponent(
//     text: "Sound Volume",
//     textRenderer: TextPaint(
//       style: TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final TextComponent musicLabel = TextComponent(
//     text: "Music Volume",
//     textRenderer: TextPaint(
//       style: TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final RectangleComponent soundBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final RectangleComponent musicBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final CircleComponent soundKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   final CircleComponent musicKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   @override
//   Color backgroundColor() => const Color(0xFF101010);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // Load background sprite
//     final bgSprite = await Sprite.load('assets/bg.png');
//     backgroundSprite = SpriteComponent(
//       sprite: bgSprite,
//       size: size, // placeholder, will resize in onGameResize
//       anchor: Anchor.topLeft,
//     );
//     add(backgroundSprite!);

//     // Load title sprite
//     final tSprite = await Sprite.load('assets/settings.png');
//     titleSprite = SpriteComponent(
//       sprite: tSprite,
//       size: Vector2(420, 400),
//       anchor: Anchor.center,
//     );
//     add(titleSprite!);

//     // Initialize backButton
//     backButton = GameBackButton(
//       onPressed: () async{
//                             final overlay = OverlayEntry(
//                                 builder: (_) => const PebbleBounce());
//                             Overlay.of(context).insert(overlay);

//                             await Future.delayed(
//                                 const Duration(milliseconds: 300));

//                             overlay.remove();

//                             widget.navigateToScreen(
//                               GameWidget(
//                                 game: HomeGame(
//                                   navigateToScreen: widget.navigateToScreen,
//                                   showError: widget.showError,
//                                 ),
//                               ),
//                             );
//       },
//       primaryColor: AppColors.titleColor,
//       accentColor: AppColors.primary,
//     );
//     add(backButton!);

//     // Initialize logoutButton
//     logoutButton = LogoutButton(
//       onPressed: () async {
//         await FirebaseAuth.instance.signOut();
//         navigateToScreen(
//           AuthScreen(
//             navigateToScreen: navigateToScreen,
//             showError: showError,
//           ),
//         );
//       },
//       backgroundColor: Colors.redAccent,
//       textColor: Colors.white,
//       label: "Logout",
//     );
//     add(logoutButton!);

//     // Add remaining components
//     add(soundLabel);
//     add(musicLabel);
//     add(soundBar);
//     add(musicBar);
//     add(soundKnob);
//     add(musicKnob);

//     // Load music
//     try {
//       await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
//       _musicPlayer.setReleaseMode(ReleaseMode.loop);
//       _musicPlayer.setVolume(musicLevel);
//       _musicPlayer.resume();
//     } catch (e) {
//       debugPrint('Error loading music: $e');
//     }
//   }

//   @override
//   void onGameResize(Vector2 newSize) {
//     super.onGameResize(newSize);

//     // Resize background to full screen
//     backgroundSprite?.size = newSize;

//     _layout(newSize);
//   }

//   void _layout(Vector2 screenSize) {
//     // Position title
//     titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.20);

//     // Back button
//     backButton?.position = Vector2(backButton!.size.x / 2-10, backButton!.size.y / 2);

//     // Sound controls
//     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
//     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
//     soundKnob.position = Vector2(
//       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//       soundBar.position.y,
//     );

//     // Music controls
//     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
//     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
//     musicKnob.position = Vector2(
//       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//       musicBar.position.y,
//     );

//     // Logout button
//     logoutButton?.anchor = Anchor.center;
//     logoutButton?.position = Vector2(
//       screenSize.x / 2,
//       screenSize.y * 0.8,
//     );
//   }

//   @override
//   void onTapDown(TapDownInfo info) {
//     _handleTouch(info.eventPosition.global);
//   }

//   @override
//   void onPanUpdate(DragUpdateInfo info) {
//     _handleTouch(info.eventPosition.global);
//   }

//   void _handleTouch(Vector2 pos) {
//     if (_isInBar(pos, soundBar)) {
//       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
//           .clamp(0.0, 1.0);
//       soundKnob.position = Vector2(
//         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//         soundBar.position.y,
//       );
//     }

//     if (_isInBar(pos, musicBar)) {
//       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
//           .clamp(0.0, 1.0);
//       musicKnob.position = Vector2(
//         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//         musicBar.position.y,
//       );

//       _musicPlayer.setVolume(musicLevel);
//     }
//   }

//   bool _isInBar(Vector2 pos, RectangleComponent bar) {
//     final withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
//         pos.x <= bar.position.x + bar.size.x / 2;
//     final withinY = (pos.y - bar.position.y).abs() <= 20;
//     return withinX && withinY;
//   }
// }




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/auth/auth_screen.dart';
// import 'package:sungka/screens/components/game_back_button.dart';
// import 'package:sungka/screens/components/logout_button.dart';
// import 'package:sungka/screens/components/pebble_bounce.dart';
// import 'package:sungka/screens/home_screen.dart';

// class SettingsGame extends FlameGame with TapDetector, PanDetector {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;
  
//   // FIX 1: Add nullable BuildContext field
//   final BuildContext? flutterContext; 

//   SettingsGame({required this.navigateToScreen, required this.showError, this.flutterContext});

//   double soundLevel = 0.8;
//   double musicLevel = 0.6;

//   final AudioPlayer _musicPlayer = AudioPlayer();

//   GameBackButton? backButton;
//   LogoutButton? logoutButton;

//   SpriteComponent? backgroundSprite;
//   SpriteComponent? titleSprite;

//   final TextComponent soundLabel = TextComponent(
//     text: "Sound Volume",
//     textRenderer: TextPaint(
//       style: TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final TextComponent musicLabel = TextComponent(
//     text: "Music Volume",
//     textRenderer: TextPaint(
//       style: TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final RectangleComponent soundBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final RectangleComponent musicBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final CircleComponent soundKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   final CircleComponent musicKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   @override
//   Color backgroundColor() => const Color(0xFF101010);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // Load background sprite
//     final bgSprite = await Sprite.load('assets/bg.png');
//     backgroundSprite = SpriteComponent(
//       sprite: bgSprite,
//       size: size,
//       anchor: Anchor.topLeft,
//     );
//     add(backgroundSprite!);

//     // Load title sprite
//     final tSprite = await Sprite.load('assets/settings.png');
//     titleSprite = SpriteComponent(
//       sprite: tSprite,
//       size: Vector2(420, 400),
//       anchor: Anchor.center,
//     );
//     add(titleSprite!);

//     // Initialize backButton (FIX 2: Use provided flutterContext and navigateToScreen field)
//     backButton = GameBackButton(
//       onPressed: () async {
//         if (flutterContext != null) {
//           final overlay = OverlayEntry(
//             builder: (_) => const PebbleBounce());
//           Overlay.of(flutterContext!).insert(overlay);

//           await Future.delayed(
//             const Duration(milliseconds: 300));

//           overlay.remove();

//           navigateToScreen( // Use the field, not 'widget.navigateToScreen'
//             GameWidget(
//               game: HomeGame(
//                 navigateToScreen: navigateToScreen,
//                 showError: showError,
//               ),
//             ),
//           );
//         } else {
//             // Fallback if context is somehow missing
//             navigateToScreen(
//                 GameWidget(
//                     game: HomeGame(
//                         navigateToScreen: navigateToScreen,
//                         showError: showError,
//                     ),
//                 ),
//             );
//         }
//       },
//       primaryColor: AppColors.titleColor,
//       accentColor: AppColors.primary,
//     );
//     add(backButton!);

//     // Initialize logoutButton
//     logoutButton = LogoutButton(
//       onPressed: () async {
//         await FirebaseAuth.instance.signOut();
//         navigateToScreen(
//           AuthScreen(
//             navigateToScreen: navigateToScreen,
//             showError: showError,
//           ),
//         );
//       },
//       backgroundColor: Colors.redAccent,
//       textColor: Colors.white,
//       label: "Logout",
//     );
//     add(logoutButton!);

//     // Add remaining components
//     add(soundLabel);
//     add(musicLabel);
//     add(soundBar);
//     add(musicBar);
//     add(soundKnob);
//     add(musicKnob);

//     // Load music
//     try {
//       await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
//       _musicPlayer.setReleaseMode(ReleaseMode.loop);
//       _musicPlayer.setVolume(musicLevel);
//       _musicPlayer.resume();
//     } catch (e) {
//       debugPrint('Error loading music: $e');
//     }
//   }

//   @override
//   void onGameResize(Vector2 newSize) {
//     super.onGameResize(newSize);

//     // Resize background to full screen
//     backgroundSprite?.size = newSize;

//     _layout(newSize);
//   }

//   void _layout(Vector2 screenSize) {
//     // Position title
//     titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.20);

//     // Back button
//     if (backButton != null) {
//       backButton!.position = Vector2(backButton!.size.x / 2 - 10, backButton!.size.y / 2);
//     }

//     // Sound controls
//     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
//     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
//     soundKnob.position = Vector2(
//       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//       soundBar.position.y,
//     );

//     // Music controls
//     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
//     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
//     musicKnob.position = Vector2(
//       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//       musicBar.position.y,
//     );

//     // Logout button
//     if (logoutButton != null) {
//       logoutButton!.anchor = Anchor.center;
//       logoutButton!.position = Vector2(
//         screenSize.x / 2,
//         screenSize.y * 0.8,
//       );
//     }
//   }

//   @override
//   void onTapDown(TapDownInfo info) {
//     _handleTouch(info.eventPosition.global);
//   }

//   @override
//   void onPanUpdate(DragUpdateInfo info) {
//     _handleTouch(info.eventPosition.global);
//   }

//   void _handleTouch(Vector2 pos) {
//     if (_isInBar(pos, soundBar)) {
//       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
//           .clamp(0.0, 1.0);
//       soundKnob.position = Vector2(
//         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//         soundBar.position.y,
//       );
//     }

//     if (_isInBar(pos, musicBar)) {
//       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
//           .clamp(0.0, 1.0);
//       musicKnob.position = Vector2(
//         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//         musicBar.position.y,
//       );

//       _musicPlayer.setVolume(musicLevel);
//     }
//   }

//   bool _isInBar(Vector2 pos, RectangleComponent bar) {
//     final withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
//         pos.x <= bar.position.x + bar.size.x / 2;
//     final withinY = (pos.y - bar.position.y).abs() <= 20;
//     return withinX && withinY;
//   }
// }





// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/auth/auth_screen.dart';
// import 'package:sungka/screens/components/game_back_button.dart';
// import 'package:sungka/screens/components/logout_button.dart';
// import 'package:sungka/screens/components/pebble_bounce.dart';
// import 'package:sungka/screens/home_screen.dart';

// class SettingsGame extends FlameGame with TapDetector, PanDetector {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;
  
//   final BuildContext? flutterContext; // optional context

//   SettingsGame({required this.navigateToScreen, required this.showError, this.flutterContext});

//   double soundLevel = 0.8;
//   double musicLevel = 0.6;

//   final AudioPlayer _musicPlayer = AudioPlayer();

//   GameBackButton? backButton;
//   LogoutButton? logoutButton;

//   SpriteComponent? backgroundSprite;
//   SpriteComponent? titleSprite;

//   final TextComponent soundLabel = TextComponent(
//     text: "Sound Volume",
//     textRenderer: TextPaint(
//       style: const TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final TextComponent musicLabel = TextComponent(
//     text: "Music Volume",
//     textRenderer: TextPaint(
//       style: const TextStyle(
//         fontSize: 22,
//         color: Colors.orangeAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     anchor: Anchor.center,
//   );

//   final RectangleComponent soundBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final RectangleComponent musicBar = RectangleComponent(
//     size: Vector2(250, 12),
//     paint: Paint()..color = Colors.brown.shade400,
//     anchor: Anchor.center,
//   );

//   final CircleComponent soundKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   final CircleComponent musicKnob = CircleComponent(
//     radius: 12,
//     paint: Paint()..color = Colors.amber,
//     anchor: Anchor.center,
//   );

//   @override
//   Color backgroundColor() => const Color(0xFF101010);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // Load background sprite
//     final bgSprite = await Sprite.load('assets/bg.png');
//     backgroundSprite = SpriteComponent(
//       sprite: bgSprite,
//       size: size,
//       anchor: Anchor.topLeft,
//     );
//     add(backgroundSprite!);

//     // Load title sprite
//     final tSprite = await Sprite.load('assets/settings.png');
//     titleSprite = SpriteComponent(
//       sprite: tSprite,
//       size: Vector2(420, 400),
//       anchor: Anchor.center,
//     );
//     add(titleSprite!);

//     // Initialize backButton
//     backButton = GameBackButton(
//       onPressed: () async {
//         if (flutterContext != null) {
//           final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
//           Overlay.of(flutterContext!)?.insert(overlay);
//           await Future.delayed(const Duration(milliseconds: 300));
//           overlay.remove();
//         }
//         navigateToScreen(
//           GameWidget(
//             game: HomeGame(
//               navigateToScreen: navigateToScreen,
//               showError: showError,
//             ),
//           ),
//         );
//       },
//       primaryColor: AppColors.titleColor,
//       accentColor: AppColors.primary,
//     );
//     add(backButton!);

//     // Initialize logoutButton
//     logoutButton = LogoutButton(
//       onPressed: () async {
//         await FirebaseAuth.instance.signOut();
//         navigateToScreen(
//           AuthScreen(
//             navigateToScreen: navigateToScreen,
//             showError: showError,
//           ),
//         );
//       },
//       backgroundColor: Colors.redAccent,
//       textColor: Colors.white,
//       label: "Logout",
//     );
//     add(logoutButton!);

//     // Add remaining components
//     add(soundLabel);
//     add(musicLabel);
//     add(soundBar);
//     add(musicBar);
//     add(soundKnob);
//     add(musicKnob);

//     if (_musicPlayer.state != PlayerState.playing) {
//       try {
//         await _musicPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
//         _musicPlayer.setReleaseMode(ReleaseMode.loop);
//         _musicPlayer.setVolume(musicLevel);
//         _musicPlayer.resume();
//       } catch (e) {
//         debugPrint('Error loading music: $e');
//       }
//     } else {
//       _musicPlayer.setVolume(musicLevel);
//     }
//   }

//   @override
//   void onGameResize(Vector2 newSize) {
//     super.onGameResize(newSize);

//     // Resize background to full screen
//     backgroundSprite?.size = newSize;

//     _layout(newSize);
//   }

//   void _layout(Vector2 screenSize) {
//     titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.20);

//     if (backButton != null) {
//       backButton!.position = Vector2(backButton!.size.x / 2 - 10, backButton!.size.y / 2);
//     }

//     soundLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.35);
//     soundBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.42);
//     soundKnob.position = Vector2(
//       soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//       soundBar.position.y,
//     );

//     musicLabel.position = Vector2(screenSize.x / 2, screenSize.y * 0.55);
//     musicBar.position = Vector2(screenSize.x / 2, screenSize.y * 0.62);
//     musicKnob.position = Vector2(
//       musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//       musicBar.position.y,
//     );

//     if (logoutButton != null) {
//       logoutButton!.anchor = Anchor.center;
//       logoutButton!.position = Vector2(screenSize.x / 2, screenSize.y * 0.8);
//     }
//   }

//   @override
//   void onTapDown(TapDownInfo info) => _handleTouch(info.eventPosition.global);

//   @override
//   void onPanUpdate(DragUpdateInfo info) => _handleTouch(info.eventPosition.global);

//   void _handleTouch(Vector2 pos) {
//     if (_isInBar(pos, soundBar)) {
//       soundLevel = ((pos.x - (soundBar.position.x - soundBar.size.x / 2)) / soundBar.size.x)
//           .clamp(0.0, 1.0);
//       soundKnob.position = Vector2(
//         soundBar.position.x - soundBar.size.x / 2 + soundBar.size.x * soundLevel,
//         soundBar.position.y,
//       );
//     }

//     if (_isInBar(pos, musicBar)) {
//       musicLevel = ((pos.x - (musicBar.position.x - musicBar.size.x / 2)) / musicBar.size.x)
//           .clamp(0.0, 1.0);
//       musicKnob.position = Vector2(
//         musicBar.position.x - musicBar.size.x / 2 + musicBar.size.x * musicLevel,
//         musicBar.position.y,
//       );

//       // Just adjust volume, do not reload music
//       _musicPlayer.setVolume(musicLevel);
//     }
//   }

//   bool _isInBar(Vector2 pos, RectangleComponent bar) {
//     final withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
//         pos.x <= bar.position.x + bar.size.x / 2;
//     final withinY = (pos.y - bar.position.y).abs() <= 20;
//     return withinX && withinY;
//   }
// }





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

/// --- SettingsGame ---
class SettingsGame extends FlameGame with TapDetector, PanDetector {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final BuildContext? flutterContext;

  SettingsGame({
    required this.navigateToScreen,
    required this.showError,
    this.flutterContext,
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

  /// AudioPlayer directly in the game
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Color backgroundColor() => const Color(0xFF101010);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load background sprite
    final bgSprite = await Sprite.load('assets/bg.png');
    backgroundSprite = SpriteComponent(
      sprite: bgSprite,
      size: size,
      anchor: Anchor.topLeft,
    );
    add(backgroundSprite!);

    // Load title sprite
    final tSprite = await Sprite.load('assets/settings.png');
    titleSprite = SpriteComponent(
      sprite: tSprite,
      size: Vector2(420, 400),
      anchor: Anchor.center,
    );
    add(titleSprite!);

    // Back button
    backButton = GameBackButton(
      onPressed: () async {
        if (flutterContext != null) {
          final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
          Overlay.of(flutterContext!)?.insert(overlay);
          await Future.delayed(const Duration(milliseconds: 300));
          overlay.remove();
        }
        navigateToScreen(
          GameWidget(
            game: HomeGame(
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

    // Logout button
    logoutButton = LogoutButton(
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
    add(logoutButton!);

    // Add volume controls
    add(soundLabel);
    add(musicLabel);
    add(soundBar);
    add(musicBar);
    add(soundKnob);
    add(musicKnob);

    // Start music directly
    await _audioPlayer.setSource(AssetSource('audio/sunngka_music.mp3'));
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(musicLevel);
    await _audioPlayer.resume();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    backgroundSprite?.size = newSize;
    _layout(newSize);
  }

  void _layout(Vector2 screenSize) {
    titleSprite?.position = Vector2(screenSize.x / 2, screenSize.y * 0.20);
    backButton?.position = Vector2(backButton!.size.x / 2 - 10, backButton!.size.y / 2);

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
  void onPanUpdate(DragUpdateInfo info) => _handleTouch(info.eventPosition.global);

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
      _audioPlayer.setVolume(musicLevel); // Adjust volume in real-time
    }
  }

  bool _isInBar(Vector2 pos, RectangleComponent bar) {
    final withinX = pos.x >= bar.position.x - bar.size.x / 2 &&
        pos.x <= bar.position.x + bar.size.x / 2;
    final withinY = (pos.y - bar.position.y).abs() <= 20;
    return withinX && withinY;
  }
}
