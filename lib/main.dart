// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeRight,
//     DeviceOrientation.landscapeLeft,
//   ]);

//   runApp(const Main());
// }

// class Main extends StatelessWidget {
//   const Main({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E1E),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Title
//             Spacer(),
//             Spacer(),
//             Text(
//               "Sungka Master",
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFFE0E0E0),
//                 fontSize: 48,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),

//             Spacer(),

//             SizedBox(
//               height: 200,
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       height: 140,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF2A2A2A),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(120),
//                           topRight: Radius.circular(120),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // maliliit na pits
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF1F1F1F),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                         Gap(60),
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF1F1F1F),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                         Gap(60),
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF1F1F1F),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                         Gap(60),
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF1F1F1F),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // left side na malaking pit
//                   Padding(
//                     padding: const EdgeInsets.only(top: 18.0, left: 18),
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 90,
//                             height: 90,
//                             decoration: BoxDecoration(
//                               color: Color(0xFF1F1F1F),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // right side na malaking pit
//                   Padding(
//                     padding: const EdgeInsets.only(top: 18.0, right: 18),
//                     child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             width: 90,
//                             height: 90,
//                             decoration: BoxDecoration(
//                               color: Color(0xFF1F1F1F),
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20.0, left: 40),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                             Gap(6),
//                             Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Gap(6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                             Gap(6),
//                             Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 20,right: 40),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                               Gap(6),
//                               Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Gap(6),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                               Gap(6),
//                               Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                   Positioned(
//                     top: 30,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFE53935),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 45,
//                           vertical: 18,
//                         ),
//                         elevation: 8,
//                       ),
//                       child: Text(
//                         "Play",
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/game.dart';
import 'dart:math' as math;

import 'package:sungka/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SungkaGameWorld gameWorld;

  @override
  void initState() {
    super.initState();
    gameWorld = SungkaGameWorld();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Spacer(),
            TitleAnimationWidget(),
            Spacer(),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 140,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(120),
                          topRight: Radius.circular(120),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedPitWidget(delay: 0),
                        Gap(60),
                        AnimatedPitWidget(delay: 1),
                        Gap(60),
                        AnimatedPitWidget(delay: 2),
                        Gap(60),
                        AnimatedPitWidget(delay: 3),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 18),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [AnimatedLargePitWidget(isLeft: true)],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, right: 18),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [AnimatedLargePitWidget(isLeft: false)],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, left: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedGamePiece(delay: 0),
                            Gap(6),
                            AnimatedGamePiece(delay: 0.1),
                          ],
                        ),
                        Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedGamePiece(delay: 0.2),
                            Gap(6),
                            AnimatedGamePiece(delay: 0.3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedGamePiece(delay: 0.4),
                            Gap(6),
                            AnimatedGamePiece(delay: 0.5),
                          ],
                        ),
                        Gap(6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedGamePiece(delay: 0.6),
                            Gap(6),
                            AnimatedGamePiece(delay: 0.7),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(top: 30, child: AnimatedPlayButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleAnimationWidget extends StatefulWidget {
  const TitleAnimationWidget({super.key});

  @override
  State<TitleAnimationWidget> createState() => _TitleAnimationWidgetState();
}

class _TitleAnimationWidgetState extends State<TitleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Text(
          "Sungka Master",
          style: GoogleFonts.poppins(
            color: const Color(0xFFE0E0E0),
            fontSize: 48,
            fontWeight: FontWeight.w800,
            shadows: [
              Shadow(
                offset: const Offset(0, 4),
                blurRadius: 12,
                color: const Color(0xFFE53935).withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedPitWidget extends StatefulWidget {
  final int delay;

  const AnimatedPitWidget({super.key, required this.delay});

  @override
  State<AnimatedPitWidget> createState() => _AnimatedPitWidgetState();
}

class _AnimatedPitWidgetState extends State<AnimatedPitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(widget.delay * 0.1, 0.6, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.6, 1, curve: Curves.easeInOut),
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFE53935,
                  ).withOpacity(_glowAnimation.value * 0.6),
                  blurRadius: 15 * _glowAnimation.value,
                  spreadRadius: 2 * _glowAnimation.value,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// <CHANGE> Animated large pit with enhanced glow
class AnimatedLargePitWidget extends StatefulWidget {
  final bool isLeft;

  const AnimatedLargePitWidget({super.key, required this.isLeft});

  @override
  State<AnimatedLargePitWidget> createState() => _AnimatedLargePitWidgetState();
}

class _AnimatedLargePitWidgetState extends State<AnimatedLargePitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFE53935,
                ).withOpacity(_glowAnimation.value * 0.8),
                blurRadius: 25 * _glowAnimation.value,
                spreadRadius: 4 * _glowAnimation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

// <CHANGE> Animated game piece with floating and rotation effect
// class AnimatedGamePiece extends StatefulWidget {
//   final double delay;

//   const AnimatedGamePiece({super.key, required this.delay});

//   @override
//   State<AnimatedGamePiece> createState() => _AnimatedGamePieceState();
// }

// class _AnimatedGamePieceState extends State<AnimatedGamePiece>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _floatAnimation;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     final double start = widget.delay.clamp(0.0, 1.0);
//     final double end = (widget.delay + 0.5).clamp(0.0, 1.0);

//     _floatAnimation = Tween<Offset>(
//       begin: const Offset(0, 0),
//       end: const Offset(0, -8),
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(
//           start,
//           end,
//           curve: Curves.easeInOut,
//         ),
//       ),
//     );

//     _rotateAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//     _controller.repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _floatAnimation,
//       child: RotationTransition(
//         turns: _rotateAnimation,
//         child: Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(50),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.6),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AnimatedGamePiece extends StatefulWidget {
//   final double delay;

//   const AnimatedGamePiece({super.key, required this.delay});

//   @override
//   State<AnimatedGamePiece> createState() => _AnimatedGamePieceState();
// }

// class _AnimatedGamePieceState extends State<AnimatedGamePiece>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _floatAnimation;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     // <CHANGE> Updated to smoothly go up and down with reverse
//     _floatAnimation = Tween<Offset>(
//       begin: const Offset(0, 0),
//       end: const Offset(0, -8),
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );

//       // _rotateAnimation = Tween<double>(
//       //   begin: 0,
//       //   end: 2 * math.pi,
//       // ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

//       // // <CHANGE> Changed to repeat with reverse for smooth down motion
//       // _controller.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _floatAnimation,
//       child: RotationTransition(
//         turns: _rotateAnimation,
//         child: Container(
//           width: 20,
//           height: 20,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(50),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.6),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class AnimatedGamePiece extends StatefulWidget {
  final double delay;

  const AnimatedGamePiece({super.key, required this.delay});

  @override
  State<AnimatedGamePiece> createState() => _AnimatedGamePieceState();
}

class _AnimatedGamePieceState extends State<AnimatedGamePiece>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -8),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _floatAnimation,
      child: RotationTransition(
        turns: _rotateAnimation,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// <CHANGE> Animated play button with bounce and glow effect
class AnimatedPlayButton extends StatefulWidget {
  const AnimatedPlayButton({super.key});

  @override
  State<AnimatedPlayButton> createState() => _AnimatedPlayButtonState();
}

class _AnimatedPlayButtonState extends State<AnimatedPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    _glowAnimation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
              elevation: 12 * _glowAnimation.value,
              shadowColor: const Color(
                0xFFE53935,
              ).withOpacity(_glowAnimation.value),
            ),
            child: Text(
              "Play",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SungkaGameWorld extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}
