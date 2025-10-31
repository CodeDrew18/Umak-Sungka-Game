// // // import 'package:flutter/material.dart';
// // // import 'package:gap/gap.dart';
// // // import 'package:google_fonts/google_fonts.dart';

// // // class SelectionMode extends StatelessWidget {
// // //   const SelectionMode({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(32.0),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           crossAxisAlignment: CrossAxisAlignment.stretch,
// // //           children: [
// // //             Center(
// // //               child: Text("Select your Mode", style: GoogleFonts.poppins(
// // //                 fontSize: 42,
              
// // //               ),),
// // //             ),
        
// // //             ElevatedButton(onPressed: () {}, child: Text("Easy"), style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.green,
// // //               fixedSize: Size.fromHeight(70)
// // //             ),),
// // //             Gap(15),
// // //             ElevatedButton(onPressed: () {}, child: Text("Medium"), style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.orange,
// // //               fixedSize: Size.fromHeight(70)
// // //             ),),
// // //             Gap(15),
// // //             ElevatedButton(onPressed: () {}, child: Text("Imposible"), style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.red,
// // //               fixedSize: Size.fromHeight(70)
// // //             ),),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }




// // import 'dart:ui';
// // import 'package:flame/camera.dart';
// // import 'package:flame/components.dart';
// // import 'package:flame/game.dart';
// // import 'package:flame/input.dart';
// // import 'package:flame/particles.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:gap/gap.dart';

// // class SelectionModeGame extends FlameGame {
// //   @override
// //   Future<void> onLoad() async {
// //     camera.viewport = FixedResolutionViewport(
// //       resolution: Vector2(1080, 1920),
// //     );

// //     add(
// //       ParticleSystemComponent(
// //         particle: Particle.generate(
// //           count: 20,
// //           lifespan: 6,
// //           generator: (i) => AcceleratedParticle(
// //             acceleration: Vector2(0, -10),
// //             speed: Vector2(
// //               (Vector2.random().x - 0.5) * 100,
// //               (Vector2.random().y - 0.5) * 100,
// //             ),
// //             position: Vector2(
// //               (Vector2.random().x) * size.x,
// //               (Vector2.random().y) * size.y,
// //             ),
// //             child: CircleParticle(
// //               radius: 3 + (i % 3).toDouble(),
// //               paint: Paint()
// //                 ..color = Colors.white.withOpacity(0.3)
// //                 ..style = PaintingStyle.fill,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Color backgroundColor() => const Color(0xFF101820);
// // }

// // class SelectionMode extends StatelessWidget {
// //   const SelectionMode({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final game = SelectionModeGame();

// //     return GameWidget(
// //       game: game,
// //       overlayBuilderMap: {
// //         'UI': (context, game) => const _SelectionOverlay(),
// //       },
// //       initialActiveOverlays: const ['UI'],
// //     );
// //   }
// // }

// // class _SelectionOverlay extends StatelessWidget {
// //   const _SelectionOverlay();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.transparent,
// //       body: Stack(
// //         children: [
// //           Container(
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Color(0xFF1E1F3B),
// //                   Color(0xFF11131F),
// //                 ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 32),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Center(
// //                   child: Text(
// //                     "Select your Mode",
// //                     style: GoogleFonts.poppins(
// //                       fontSize: 42,
// //                       fontWeight: FontWeight.w600,
// //                       color: Colors.white,
// //                       shadows: [
// //                         Shadow(
// //                           color: Colors.white54,
// //                           blurRadius: 10,
// //                         ),
// //                       ],
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 const Gap(60),
// //                 _ModeButton(
// //                   label: "Easy",
// //                   color: Colors.green,
// //                   onPressed: () {},
// //                 ),
// //                 const Gap(20),
// //                 _ModeButton(
// //                   label: "Medium",
// //                   color: Colors.orange,
// //                   onPressed: () {},
// //                 ),
// //                 const Gap(20),
// //                 _ModeButton(
// //                   label: "Impossible",
// //                   color: Colors.red,
// //                   onPressed: () {},
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _ModeButton extends StatefulWidget {
// //   final String label;
// //   final Color color;
// //   final VoidCallback onPressed;

// //   const _ModeButton({
// //     required this.label,
// //     required this.color,
// //     required this.onPressed,
// //   });

// //   @override
// //   State<_ModeButton> createState() => _ModeButtonState();
// // }

// // class _ModeButtonState extends State<_ModeButton> {
// //   bool _hovering = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return MouseRegion(
// //       onEnter: (_) => setState(() => _hovering = true),
// //       onExit: (_) => setState(() => _hovering = false),
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         decoration: BoxDecoration(
// //           boxShadow: _hovering
// //               ? [
// //                   BoxShadow(
// //                     color: widget.color.withOpacity(0.6),
// //                     blurRadius: 20,
// //                     spreadRadius: 2,
// //                   ),
// //                 ]
// //               : [],
// //         ),
// //         child: ElevatedButton(
// //           onPressed: widget.onPressed,
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: widget.color,
// //             foregroundColor: Colors.white,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(18),
// //             ),
// //             fixedSize: const Size.fromHeight(70),
// //             textStyle: GoogleFonts.poppins(
// //               fontSize: 24,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           child: Text(widget.label),
// //         ),
// //       ),
// //     );
// //   }
// // }




// import 'dart:ui';
// import 'package:flame/camera.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SelectionModeGame extends FlameGame {
//   @override
//   Future<void> onLoad() async {
//     camera.viewport = FixedResolutionViewport(
//       resolution: Vector2(1080, 1920),
//     );
//   }

//   @override
//   Color backgroundColor() => const Color(0xFF101820);
// }

// class SelectionMode extends StatelessWidget {
//   const SelectionMode({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final game = SelectionModeGame();

//     return GameWidget(
//       game: game,
//       overlayBuilderMap: {
//         'UI': (context, game) => const _SelectionOverlay(),
//       },
//       initialActiveOverlays: const ['UI'],
//     );
//   }
// }

// class _SelectionOverlay extends StatefulWidget {
//   const _SelectionOverlay();

//   @override
//   State<_SelectionOverlay> createState() => _SelectionOverlayState();
// }

// class _SelectionOverlayState extends State<_SelectionOverlay> {
//   final PageController _pageController = PageController(viewportFraction: 0.75);
//   int _currentPage = 0;

// final List<Map<String, dynamic>> modes = [
//   {
//     'label': 'Easy',
//     'color': const Color(0xFF34D399),
//     'gradient': [Color(0xFF0D1F1B), Color(0xFF052D1F)],
//   },
//   {
//     'label': 'Medium',
//     'color': const Color(0xFFFBBF24),
//     'gradient': [Color(0xFF1E1A04), Color(0xFF332100)],
//   },
//   {
//     'label': 'Impossible',
//     'color': const Color.fromARGB(255, 255, 0, 0),
//     'gradient': [Color(0xFF250505), Color(0xFF3B0A0A)],
//   },
// ];



//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int index) {
//     setState(() => _currentPage = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentMode = modes[_currentPage];
//     final screenHeight = MediaQuery.of(context).size.height;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeInOut,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: currentMode['gradient'],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 40.0),
//                     child: AnimatedDefaultTextStyle(
//                       duration: const Duration(milliseconds: 300),
//                       style: GoogleFonts.poppins(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             color: Colors.black.withOpacity(0.5),
//                             blurRadius: 10,
//                           ),
//                           Shadow(
//                             color: currentMode['color'].withOpacity(0.7),
//                             blurRadius: 30,
//                           ),
//                         ],
//                       ),
//                       child: const Text("Select your Mode"),
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.45,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       onPageChanged: _onPageChanged,
//                       itemCount: modes.length,
//                       itemBuilder: (context, index) {
//                         final mode = modes[index];
//                         final isActive = index == _currentPage;
//                         final scale = isActive ? 1.0 : 0.85;

//                         return TweenAnimationBuilder<double>(
//                           tween: Tween(begin: scale, end: scale),
//                           duration: const Duration(milliseconds: 350),
//                           builder: (context, value, child) {
//                             return Transform.scale(
//                               scale: value,
//                               child: AnimatedOpacity(
//                                 duration: const Duration(milliseconds: 300),
//                                 opacity: isActive ? 1 : 0.6,
//                                 child: _ModeCard(
//                                   label: mode['label'],
//                                   color: mode['color'],
//                                   onPressed: () {
//                                     debugPrint('Selected: ${mode['label']}');
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       modes.length,
//                       (index) => AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.symmetric(horizontal: 6),
//                         width: _currentPage == index ? 24 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: _currentPage == index
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               );
//             },
//           ),
//         ),
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
//           width: 280,
//           height: 160,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(32),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.5),
//                 blurRadius: 15,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   label,
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black.withOpacity(0.4),
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/start_game_screen.dart';

class SelectionModeGame extends FlameGame {
  final List<String> emojis;
  SelectionModeGame(this.emojis);

  late FallingEmojiManager _emojiManager;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1080, 1920));
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
                Shadow(
                  blurRadius: 6,
                  color: Colors.white.withOpacity(0.15),
                )
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
  const SelectionMode({super.key});

  @override
  State<SelectionMode> createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  late SelectionModeGame game;
  int _currentPage = 0;

  final List<Map<String, dynamic>> modes = [
    {
      'label': 'Easy',
      'emoji': ['🍃', '🌿', '🍀'],
      'gradient': [const Color(0xFF0D1F1B), const Color(0xFF052D1F)],
      'color': const Color(0xFF34D399),
    },
    {
      'label': 'Medium',
      'emoji': ['⚡', '🔥', '💥'],
      'gradient': [const Color(0xFF1E1A04), const Color(0xFF332100)],
      'color': const Color(0xFFFBBF24),
    },
    {
      'label': 'Impossible',
      'emoji': ['💀', '🔥'],
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
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'UI': (context, game) =>
            _SelectionOverlay(modes: modes, onPageChanged: _onPageChanged),
      },
      initialActiveOverlays: const ['UI'],
    );
  }
}

class _SelectionOverlay extends StatefulWidget {
  final List<Map<String, dynamic>> modes;
  final ValueChanged<int> onPageChanged;

  const _SelectionOverlay({
    required this.modes,
    required this.onPageChanged,
  });

  @override
  State<_SelectionOverlay> createState() => _SelectionOverlayState();
}

class _SelectionOverlayState extends State<_SelectionOverlay> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    widget.onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = widget.modes[_currentPage];
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
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
        Positioned(
          top: 40,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StartGameScreen()),
                );
              },
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: currentMode['color'].withOpacity(0.7),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Text("Select Your Mode"),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.45,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.modes.length,
                    itemBuilder: (context, index) {
                      final mode = widget.modes[index];
                      final isActive = index == _currentPage;
                      final scale = isActive ? 1.0 : 0.85;

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: scale, end: scale),
                        duration: const Duration(milliseconds: 350),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isActive ? 1 : 0.6,
                              child: _ModeCard(
                                label: mode['label'],
                                color: mode['color'],
                                onPressed: () {
                                  debugPrint('Selected: ${mode['label']}');
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.modes.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
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
          width: 280,
          height: 160,
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
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
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
