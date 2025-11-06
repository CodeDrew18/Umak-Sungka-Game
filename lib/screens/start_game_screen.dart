import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/widgets/name_input_dialog.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final authService = FirebaseAuthService();
  final firestoreService = FirebaseFirestoreService();
  final nameCtlr = TextEditingController();

  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _initMusic();
  }

  Future<void> _initMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/sunngka_music.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const AuthScreen();
        }

        final user = snapshot.data!;

        return FutureBuilder(
          future: firestoreService.getUser(user: user),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const AuthScreen();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'];

            if (userName == null || userName.toString().trim().isEmpty) {
              return Scaffold(
                body: NameInputDialog(
                  controller: nameCtlr,
                  cancel: cancel,
                  save: () => saveUsername(user: user),
                ),
              );
            }

            return _buildGameScreenContent();
          },
        );
      },
    );
  }

  void saveUsername({required User user}) {
    final name = nameCtlr.text.trim();
    if (name.isNotEmpty) {
      firestoreService.saveUser(user.uid, name);
      setState(() {});
    }
  }

  void cancel() {
    authService.logout();
    setState(() {});
  }

  Widget _buildGameScreenContent() {
    return Scaffold(

      backgroundColor: const Color(0xFF2D1B1B),
      body: Stack(
        children: [

          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE67E22).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE67E22).withOpacity(0.03),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const TitleAnimationWidget(),
                const Gap(20),
                
                Text(
                  "TRADITIONAL FILIPINO STRATEGY GAME",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFD4AF37).withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Container(
                      //     height: 160,
                      //     decoration: const BoxDecoration(
                      //       color: Color(0xFF3D2626),
                      //       borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(120),
                      //         topRight: Radius.circular(120),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 16.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: const [
                      //       AnimatedPitWidget(delay: 0),
                      //       Gap(60),
                      //       AnimatedPitWidget(delay: 1),
                      //       Gap(60),
                      //       AnimatedPitWidget(delay: 2),
                      //       Gap(60),
                      //       AnimatedPitWidget(delay: 3),
                      //     ],
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: 18.0, left: 18),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Row(
                      //       children: [AnimatedLargePitWidget(isLeft: true)],
                      //     ),
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: 18.0, right: 18),
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [AnimatedLargePitWidget(isLeft: false)],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 20.0, left: 40),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: const [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           AnimatedGamePiece(delay: 0),
                      //           Gap(6),
                      //           AnimatedGamePiece(delay: 0.1),
                      //         ],
                      //       ),
                      //       Gap(6),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           AnimatedGamePiece(delay: 0.2),
                      //           Gap(6),
                      //           AnimatedGamePiece(delay: 0.3),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 20, right: 40),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: const [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           AnimatedGamePiece(delay: 0.4),
                      //           Gap(6),
                      //           AnimatedGamePiece(delay: 0.5),
                      //         ],
                      //       ),
                      //       Gap(6),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           AnimatedGamePiece(delay: 0.6),
                      //           Gap(6),
                      //           AnimatedGamePiece(delay: 0.7),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const Positioned(top: 30, child: AnimatedPlayButton()),
                    ],
                  ),
                ),
                const Spacer(),
                                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
                                const Spacer(),
                Spacer(),
                const Spacer(),
                Spacer(),
              ],
            ),
          ),
        ],
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

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

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
          textAlign: TextAlign.center
          ,
          "Sungka Master",
          style: GoogleFonts.poppins(
            color: const Color(0xFFFFD700),
            fontSize: 65,
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
        curve: const Interval(0.6, 1, curve: Curves.easeInOut),
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
              color: const Color(0xFFB0B0B0),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withOpacity(
                    _glowAnimation.value * 0.5,
                  ),
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

    _glowAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {

        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFB0B0B0),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withOpacity(
                  _glowAnimation.value * 0.7,
                ),
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
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
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

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
      
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GameWidget(game: HomeGame(context)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 18),
              elevation: 12 * _glowAnimation.value,
              shadowColor: const Color(0xFFE53935).withOpacity(
                _glowAnimation.value,
              ),
            ),
            child: Text(
              "PLAY",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          );
        },
      ),
    );
  }
}