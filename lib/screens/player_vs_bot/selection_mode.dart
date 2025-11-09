// // import 'dart:math';
// // import 'package:flame/camera.dart';
// // import 'package:flame/components.dart';
// // import 'package:flame/events.dart';
// // import 'package:flame/game.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:sungka/screens/components/pebble_bounce.dart';
// // import 'package:sungka/screens/home_screen.dart';
// // import 'package:sungka/screens/player_vs_bot/game_match/player_vs_bot.dart';
// // import 'package:sungka/screens/player_vs_bot/on_match/match_game_screen.dart';
// // import 'package:sungka/screens/start_game_screen.dart';

// // class SelectionModeGame extends FlameGame with TapCallbacks, HoverCallbacks {
// //   final List<String> emojis;
// //   final BuildContext context;
// //   SelectionModeGame(this.emojis, this.context);

// //   late FallingEmojiManager _emojiManager;

// //   @override
// //   Future<void> onLoad() async {
// //     camera.viewport = FixedResolutionViewport(resolution: Vector2(1080, 1920));
// //     _emojiManager = FallingEmojiManager(emojis);
// //     add(_emojiManager);
// //   }

// //   void updateEmojis(List<String> newEmojis) {
// //     _emojiManager.updateEmojiList(newEmojis);
// //   }

// //   @override
// //   Color backgroundColor() => const Color(0xFF0A0E12);
// // }

// // class FallingEmojiManager extends Component with HasGameRef<SelectionModeGame> {
// //   List<String> emojis;
// //   final Random random = Random();
// //   double timer = 0;

// //   FallingEmojiManager(this.emojis);

// //   void updateEmojiList(List<String> newEmojis) {
// //     emojis = newEmojis;
// //   }

// //   @override
// //   void update(double dt) {
// //     timer += dt;
// //     if (timer > 0.3) {
// //       timer = 0;
// //       if (emojis.isEmpty) return;
// //       final emoji = emojis[random.nextInt(emojis.length)];
// //       final x = random.nextDouble() * gameRef.size.x;
// //       final size = random.nextDouble() * 30 + 20;
// //       final speed = random.nextDouble() * 100 + 40;
// //       gameRef.add(FallingEmoji(emoji, Vector2(x, -size), size, speed));
// //     }
// //   }
// // }

// // class FallingEmoji extends TextComponent with HasGameRef<SelectionModeGame> {
// //   final double speed;
// //   FallingEmoji(String emoji, Vector2 position, double fontSize, this.speed)
// //       : super(
// //           text: emoji,
// //           position: position,
// //           textRenderer: TextPaint(
// //             style: TextStyle(
// //               fontSize: fontSize,
// //               color: Colors.white.withOpacity(0.3),
// //               shadows: [
// //                 Shadow(blurRadius: 6, color: Colors.white.withOpacity(0.15)),
// //               ],
// //             ),
// //           ),
// //         );

// //   @override
// //   void update(double dt) {
// //     y += speed * dt;
// //     if (y > gameRef.size.y + 50) removeFromParent();
// //   }
// // }

// // class SelectionMode extends StatefulWidget {
// //   final Function(Widget screen) navigateToScreen;
// //   final Function(String message) showError;

// //   const SelectionMode({
// //     super.key,
// //     required this.navigateToScreen,
// //     required this.showError,
// //   });

// //   @override
// //   State<SelectionMode> createState() => _SelectionModeState();
// // }

// // class _SelectionModeState extends State<SelectionMode> {
// //   late SelectionModeGame game;
// //   int _currentPage = 0;
// //   final PageController _pageController = PageController(viewportFraction: 0.75);

// //   final List<Map<String, dynamic>> modes = [
// //     {
// //       'label': 'Easy',
// //       'emoji': ["😄"],
// //       'gradient': [const Color(0xFF0D1F1B), const Color(0xFF052D1F)],
// //       'color': const Color(0xFF34D399),
// //     },
// //     {
// //       'label': 'Medium',
// //       'emoji': ["😐"],
// //       'gradient': [const Color(0xFF1E1A04), const Color(0xFF332100)],
// //       'color': const Color(0xFFFBBF24),
// //     },
// //     {
// //       'label': 'Hard',
// //       'emoji': ["😈"],
// //       'gradient': [const Color(0xFF250505), const Color(0xFF3B0A0A)],
// //       'color': const Color(0xFFDC2626),
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     game = SelectionModeGame(modes[_currentPage]['emoji'], context);
// //   }

// //   void _onPageChanged(int index) {
// //     setState(() => _currentPage = index);
// //     game.updateEmojis(modes[index]['emoji']);
// //   }

// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final currentMode = modes[_currentPage];
// //     final screenHeight = MediaQuery.of(context).size.height;

// //     return WillPopScope(
// //       onWillPop: () async {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => GameWidget(
// //               game: StartMenuGame(
// //                 navigateToScreen: widget.navigateToScreen,
// //                 showError: widget.showError,
// //               ),
// //             ),
// //           ),
// //         );
// //         return false;
// //       },
// //       child: GameWidget(
// //         game: game,
// //         overlayBuilderMap: {
// //           'UI': (context, game) => Stack(
// //                 children: [
// //                   AnimatedContainer(
// //                     duration: const Duration(milliseconds: 600),
// //                     curve: Curves.easeInOut,
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors:
// //                             (currentMode['gradient'] as List<Color>)
// //                                 .map((c) => c.withOpacity(0.8))
// //                                 .toList(),
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight,
// //                       ),
// //                     ),
// //                   ),
// //                   SafeArea(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 40.0),
// //                           child: AnimatedDefaultTextStyle(
// //                             duration: const Duration(milliseconds: 300),
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 38,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                               decoration: TextDecoration.none,
// //                               shadows: [
// //                                 Shadow(
// //                                   color: currentMode['color'].withOpacity(0.7),
// //                                   blurRadius: 15,
// //                                 ),
// //                               ],
// //                             ),
// //                             child: const Text("Select Your Mode"),
// //                           ),
// //                         ),
// //                         SizedBox(
// //                           height: screenHeight * 0.45,
// //                           child: PageView.builder(
// //                             controller: _pageController,
// //                             onPageChanged: _onPageChanged,
// //                             itemCount: modes.length,
// //                             itemBuilder: (context, index) {
// //                               final mode = modes[index];
// //                               final isActive = index == _currentPage;
// //                               final scale = isActive ? 1.0 : 0.85;

// //                               return TweenAnimationBuilder<double>(
// //                                 tween: Tween(begin: scale, end: scale),
// //                                 duration: const Duration(milliseconds: 350),
// //                                 builder: (context, value, child) {
// //                                   return Transform.scale(
// //                                     scale: value,
// //                                     child: AnimatedOpacity(
// //                                       duration: const Duration(
// //                                         milliseconds: 300,
// //                                       ),
// //                                       opacity: isActive ? 1 : 0.6,
// //                                       child: _ModeCard(
// //                                         label: mode['label'],
// //                                         color: mode['color'],
// //                                         onPressed: () {
// //                                           Difficulty difficulty;

// //                                           switch (mode['label']) {
// //                                             case 'Easy':
// //                                               difficulty = Difficulty.easy;
// //                                               break;
// //                                             case 'Medium':
// //                                               difficulty = Difficulty.medium;
// //                                               break;
// //                                             default:
// //                                               difficulty = Difficulty.hard;
// //                                           }

// //                                           Navigator.push(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                               builder: (_) => PlayerVsBot(difficulty: difficulty),
// //                                             ),
// //                                           );
// //                                         },
// //                                       ),
// //                                     ),
// //                                   );
// //                                 },
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: List.generate(
// //                             modes.length,
// //                             (index) => AnimatedContainer(
// //                               duration: const Duration(milliseconds: 300),
// //                               margin: const EdgeInsets.symmetric(horizontal: 6),
// //                               width: _currentPage == index ? 24 : 8,
// //                               height: 8,
// //                               decoration: BoxDecoration(
// //                                 color: _currentPage == index
// //                                     ? Colors.white
// //                                     : Colors.white.withOpacity(0.4),
// //                                 borderRadius: BorderRadius.circular(20),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 40),
// //                       ],
// //                     ),
// //                   ),
// //                   SafeArea(
// //                     child: Align(
// //                       alignment: Alignment.topLeft,
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(16),
// //                         child: GestureDetector(
// //             //              onTap: () {
// //             //   widget.navigateToScreen(
// //             //    GameWidget(
// //             //     game: HomeGame(
// //             //      navigateToScreen: widget.navigateToScreen,
// //             //      showError: widget.showError,
// //             //     ),
// //             //    ),
// //             //   );
// //             //  },
// //             onTap: () async {
// //                           final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
// //                           Overlay.of(context).insert(overlay);

// //                           await Future.delayed(const Duration(milliseconds: 300));

// //                           overlay.remove();

// //                           widget.navigateToScreen(
// //                             GameWidget(
// //                               game: HomeGame(
// //                                 navigateToScreen: widget.navigateToScreen,
// //                                 showError: widget.showError,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                           child: Container(
// //                             width: 60,
// //                             height: 60,
// //                             decoration: BoxDecoration(
// //                               color: Colors.red,
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black.withOpacity(0.3),
// //                                   blurRadius: 8,
// //                                   offset: const Offset(0, 3),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: const Icon(
// //                               Icons.arrow_back,
// //                               color: Colors.white,
// //                               size: 28,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //         },
// //         initialActiveOverlays: const ['UI'],
// //       ),
// //     );
// //   }
// // }

// // class _ModeCard extends StatelessWidget {
// //   final String label;
// //   final Color color;
// //   final VoidCallback onPressed;

// //   const _ModeCard({
// //     required this.label,
// //     required this.color,
// //     required this.onPressed,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: GestureDetector(
// //         onTap: onPressed,
// //         child: Container(
// //           width: 240,
// //           height: 140,
// //           decoration: BoxDecoration(
// //             color: color,
// //             borderRadius: BorderRadius.circular(28),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: color.withOpacity(0.4),
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 3),
// //               ),
// //             ],
// //           ),
// //           child: Center(
// //             child: Material(
// //               color: Colors.transparent,
// //               child: Text(
// //                 label,
// //                 textAlign: TextAlign.center,
// //                 style: GoogleFonts.poppins(
// //                   color: Colors.white,
// //                   fontSize: 34,
// //                   fontWeight: FontWeight.bold,
// //                   letterSpacing: 1,
// //                   decoration: TextDecoration.none,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }






// import 'dart:math';
// import 'package:flame/camera.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sungka/screens/components/pebble_bounce.dart';
// import 'package:sungka/screens/home_screen.dart';
// import 'package:sungka/screens/player_vs_bot/game_match/player_vs_bot.dart';
// import 'package:sungka/screens/player_vs_bot/on_match/match_game_screen.dart';
// import 'package:sungka/screens/start_game_screen.dart';

// // Removed FlameSpriteTitleComponent class

// class SelectionModeGame extends FlameGame with TapCallbacks, HoverCallbacks {
//   final List<String> emojis;
//   final BuildContext context;
//   SelectionModeGame(this.emojis, this.context);

//   late FallingEmojiManager _emojiManager;

//   // The title component is no longer a class member, as it will be created and added directly in onLoad.
//   // We can still keep a reference if we need to modify it later, but for a static title, it's optional.

// @override
// Future<void> onLoad() async {
//   camera.viewport = FixedResolutionViewport(resolution:  Vector2(1080, 1920));

//   final double centerX = size.x / 2;

//   const spriteWidth = 800.0;
//   const spriteHeight = 100.0;

//   _emojiManager = FallingEmojiManager(emojis);
//   add(_emojiManager);

//   // Create the title sprite
//   final titleSpriteComponent = SpriteComponent(
//     sprite: await loadSprite('assets/mode_selection.png'),
//     size: Vector2(spriteWidth, spriteHeight),
//     anchor: Anchor.topCenter,
//     position: Vector2(centerX, 80),
//     priority: 1000, // HIGH priority to render on top
//   );

//   // Add the title sprite
//   add(titleSpriteComponent);



//   _titleSpriteComponent = titleSpriteComponent; 
// }

//   void updateEmojis(List<String> newEmojis) {
//     _emojiManager.updateEmojiList(newEmojis);
//   }

//   @override
//   Color backgroundColor() => const Color(0xFF0A0E12);
// }

// class FallingEmojiManager extends Component with HasGameRef<SelectionModeGame> {
//   List<String> emojis;
//   final Random random = Random();
//   double timer = 0;

//   FallingEmojiManager(this.emojis);

//   void updateEmojiList(List<String> newEmojis) {
//     emojis = newEmojis;
//   }

//   @override
//   void update(double dt) {
//     timer += dt;
//     if (timer > 0.3) {
//       timer = 0;
//       if (emojis.isEmpty) return;
//       final emoji = emojis[random.nextInt(emojis.length)];
//       final x = random.nextDouble() * gameRef.size.x;
//       final size = random.nextDouble() * 30 + 20;
//       final speed = random.nextDouble() * 100 + 40;
//       gameRef.add(FallingEmoji(emoji, Vector2(x, -size), size, speed));
//     }
//   }
// }

// class FallingEmoji extends TextComponent with HasGameRef<SelectionModeGame> {
//   final double speed;
//   FallingEmoji(String emoji, Vector2 position, double fontSize, this.speed)
//       : super(
//           text: emoji,
//           position: position,
//           textRenderer: TextPaint(
//             style: TextStyle(
//               fontSize: fontSize,
//               color: Colors.white.withOpacity(0.3),
//               shadows: [
//                 Shadow(blurRadius: 6, color: Colors.white.withOpacity(0.15)),
//               ],
//             ),
//           ),
//         );

//   @override
//   void update(double dt) {
//     y += speed * dt;
//     if (y > gameRef.size.y + 50) removeFromParent();
//   }
// }

// class SelectionMode extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   const SelectionMode({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<SelectionMode> createState() => _SelectionModeState();
// }

// class _SelectionModeState extends State<SelectionMode> {
//   late SelectionModeGame game;
//   int _currentPage = 0;
//   final PageController _pageController = PageController(viewportFraction: 0.75);

//   final List<Map<String, dynamic>> modes = [
//     {
//       'label': 'Easy',
//       'emoji': ["😄"],
//       'gradient': [const Color(0xFF0D1F1B), const Color(0xFF052D1F)],
//       'color': const Color(0xFF34D399),
//     },
//     {
//       'label': 'Medium',
//       'emoji': ["😐"],
//       'gradient': [const Color(0xFF1E1A04), const Color(0xFF332100)],
//       'color': const Color(0xFFFBBF24),
//     },
//     {
//       'label': 'Hard',
//       'emoji': ["😈"],
//       'gradient': [const Color(0xFF250505), const Color(0xFF3B0A0A)],
//       'color': const Color(0xFFDC2626),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     game = SelectionModeGame(modes[_currentPage]['emoji'], context);
//   }

//   void _onPageChanged(int index) {
//     setState(() => _currentPage = index);
//     game.updateEmojis(modes[index]['emoji']);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentMode = modes[_currentPage];
//     final screenHeight = MediaQuery.of(context).size.height;

//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => GameWidget(
//               game: StartMenuGame(
//                 navigateToScreen: widget.navigateToScreen,
//                 showError: widget.showError,
//               ),
//             ),
//           ),
//         );
//         return false;
//       },
//       child: GameWidget(
//         game: game,
//         overlayBuilderMap: {
//           'UI': (context, game) => Stack(
//                 children: [
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 600),
//                     curve: Curves.easeInOut,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors:
//                             (currentMode['gradient'] as List<Color>)
//                                 .map((c) => c.withOpacity(0.8))
//                                 .toList(),
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                   SafeArea(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const SizedBox(height: 100), // Compensate for the title's vertical space
//                         SizedBox(
//                           height: screenHeight * 0.45,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             onPageChanged: _onPageChanged,
//                             itemCount: modes.length,
//                             itemBuilder: (context, index) {
//                               final mode = modes[index];
//                               final isActive = index == _currentPage;
//                               final scale = isActive ? 1.0 : 0.85;

//                               return TweenAnimationBuilder<double>(
//                                 tween: Tween(begin: scale, end: scale),
//                                 duration: const Duration(milliseconds: 350),
//                                 builder: (context, value, child) {
//                                   return Transform.scale(
//                                     scale: value,
//                                     child: AnimatedOpacity(
//                                       duration: const Duration(
//                                         milliseconds: 300,
//                                       ),
//                                       opacity: isActive ? 1 : 0.6,
//                                       child: _ModeCard(
//                                         label: mode['label'],
//                                         color: mode['color'],
//                                         onPressed: () {
//                                           Difficulty difficulty;

//                                           switch (mode['label']) {
//                                             case 'Easy':
//                                               difficulty = Difficulty.easy;
//                                               break;
//                                             case 'Medium':
//                                               difficulty = Difficulty.medium;
//                                               break;
//                                             default:
//                                               difficulty = Difficulty.hard;
//                                           }

//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (_) => PlayerVsBot(difficulty: difficulty),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             modes.length,
//                             (index) => AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               margin: const EdgeInsets.symmetric(horizontal: 6),
//                               width: _currentPage == index ? 24 : 8,
//                               height: 8,
//                               decoration: BoxDecoration(
//                                 color: _currentPage == index
//                                     ? Colors.white
//                                     : Colors.white.withOpacity(0.4),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                   SafeArea(
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: GestureDetector(
//                           onTap: () async {
//                             final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
//                             Overlay.of(context).insert(overlay);

//                             await Future.delayed(const Duration(milliseconds: 300));

//                             overlay.remove();

//                             widget.navigateToScreen(
//                               GameWidget(
//                                 game: HomeGame(
//                                   navigateToScreen: widget.navigateToScreen,
//                                   showError: widget.showError,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.3),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.arrow_back,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//         },
//         initialActiveOverlays: const ['UI'],
//       ),
//     );
//   }
// }

// class _ModeCard extends StatelessWidget {
//   final String label;
//   final Color color;
//   final VoidCallback onPressed;

//   const _ModeCard({
//     required this.label,
//     required this.color,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: onPressed,
//         child: Container(
//           width: 240,
//           height: 140,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(28),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.4),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Material(
//               color: Colors.transparent,
//               child: Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 34,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/components/pebble_bounce.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/player_vs_bot/game_match/player_vs_bot.dart';
import 'package:sungka/screens/start_game_screen.dart';

enum Difficulty { easy, medium, hard }

class SelectionModeGame extends FlameGame with TapCallbacks {
  List<String> emojis;
  SelectionModeGame(this.emojis);

  late FallingEmojiManager _emojiManager;

  @override
  Future<void> onLoad() async {
    _emojiManager = FallingEmojiManager(emojis);
    add(_emojiManager);
  }

  void updateEmojis(List<String> newEmojis) {
    _emojiManager.updateEmojiList(newEmojis);
  }

  @override
  Color backgroundColor() => const Color(0xFF0A0E12);
}

class FallingEmojiManager extends Component with HasGameRef<SelectionModeGame> {
  List<String> emojis;
  final Random random = Random();
  double timer = 0;

  FallingEmojiManager(this.emojis);

  void updateEmojiList(List<String> newEmojis) {
    emojis = newEmojis;
  }

  @override
  void update(double dt) {
    timer += dt;
    if (timer > 0.3) {
      timer = 0;
      if (emojis.isEmpty) return;
      final emoji = emojis[random.nextInt(emojis.length)];
      final x = random.nextDouble() * gameRef.size.x;
      final size = random.nextDouble() * 30 + 20;
      final speed = random.nextDouble() * 100 + 40;
      gameRef.add(FallingEmoji(emoji, Vector2(x, -size), size, speed));
    }
  }
}

class FallingEmoji extends TextComponent with HasGameRef<SelectionModeGame> {
  final double speed;
  FallingEmoji(String emoji, Vector2 position, double fontSize, this.speed)
      : super(
          text: emoji,
          position: position,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white.withOpacity(0.3),
              shadows: [
                Shadow(blurRadius: 6, color: Colors.white.withOpacity(0.15)),
              ],
            ),
          ),
        );

  @override
  void update(double dt) {
    y += speed * dt;
    if (y > gameRef.size.y + 50) removeFromParent();
  }
}

class SelectionMode extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  const SelectionMode({
    super.key,
    required this.navigateToScreen,
    required this.showError,
  });

  @override
  State<SelectionMode> createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  late SelectionModeGame game;
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.75);

  final List<Map<String, dynamic>> modes = [
    {
      'label': 'Easy',
      'emoji': ["😄"],
      'gradient': [const Color(0xFF0D1F1B), const Color(0xFF052D1F)],
      'color': const Color(0xFF34D399),
    },
    {
      'label': 'Medium',
      'emoji': ["😐"],
      'gradient': [const Color(0xFF1E1A04), const Color(0xFF332100)],
      'color': const Color(0xFFFBBF24),
    },
    {
      'label': 'Hard',
      'emoji': ["😈"],
      'gradient': [const Color(0xFF250505), const Color(0xFF3B0A0A)],
      'color': const Color(0xFFDC2626),
    },
  ];

  @override
  void initState() {
    super.initState();
    game = SelectionModeGame(modes[_currentPage]['emoji']);
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    game.updateEmojis(modes[index]['emoji']);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = modes[_currentPage];
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameWidget(
              game: StartMenuGame(
                navigateToScreen: widget.navigateToScreen,
                showError: widget.showError,
              ),
            ),
          ),
        );
        return false;
      },
      child: GameWidget(
        game: game,
        overlayBuilderMap: {
          'UI': (context, game) => Stack(
                children: [
                  // Background Gradient
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (currentMode['gradient'] as List<Color>)
                            .map((c) => c.withOpacity(0.8))
                            .toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Title Image
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/assets/mode_selection.png',
                          width: 420,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // PageView and Dots
                  Center(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.45,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: modes.length,
                              itemBuilder: (context, index) {
                                final mode = modes[index];
                                final isActive = index == _currentPage;
                                final scale = isActive ? 1.0 : 0.85;
                    
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: scale, end: scale),
                                  duration: const Duration(milliseconds: 350),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        opacity: isActive ? 1 : 0.6,
                                        child: _ModeCard(
                                          label: mode['label'],
                                          color: mode['color'],
                                          onPressed: () {
                                            Difficulty difficulty;
                                            switch (mode['label']) {
                                              case 'Easy':
                                                difficulty = Difficulty.easy;
                                                break;
                                              case 'Medium':
                                                difficulty = Difficulty.medium;
                                                break;
                                              default:
                                                difficulty = Difficulty.hard;
                                            }
                    
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PlayerVsBot(
                                                        difficulty: difficulty),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(
                                    modes.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 6),
                                      width: _currentPage == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _currentPage == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Back Button
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () async {
                            final overlay = OverlayEntry(
                                builder: (_) => const PebbleBounce());
                            Overlay.of(context).insert(overlay);

                            await Future.delayed(
                                const Duration(milliseconds: 300));

                            overlay.remove();

                            widget.navigateToScreen(
                              GameWidget(
                                game: HomeGame(
                                  navigateToScreen: widget.navigateToScreen,
                                  showError: widget.showError,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        },
        initialActiveOverlays: const ['UI'],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ModeCard({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 240,
          height: 140,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
