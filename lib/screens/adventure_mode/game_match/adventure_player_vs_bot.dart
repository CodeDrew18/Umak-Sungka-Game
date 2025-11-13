import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_fifth_level_screen,.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_first_level_screen.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_fourth_level_screen.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_second_level_screen.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_sixth_level_screen,.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_third_level_screen.dart';
import 'package:sungka/screens/adventure_mode/game_match/adventure_bot_card.dart';
import 'package:sungka/screens/adventure_mode/game_match/adventure_player_card.dart';

class AdventurePlayerVsBot extends StatefulWidget {
  final dynamic difficulty;
  final dynamic level;
  const AdventurePlayerVsBot({
    Key? key,
    required this.difficulty,
    required this.level,
  }) : super(key: key);

  @override
  State<AdventurePlayerVsBot> createState() => _AdventurePlayerVsBotState();
}

class _AdventurePlayerVsBotState extends State<AdventurePlayerVsBot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _player1Slide;
  late Animation<Offset> _player2Slide;
  late Animation<double> _vsScale;
  late Animation<double> _fadeOut;

  late AnimationStatusListener _animationListener;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _player1Slide = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _player2Slide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _vsScale = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeOut = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    );

    _animationListener = (status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) {

              if (widget.level == 1) {
                return AdventureFirstLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );

              }
              if (widget.level == 2) {
                return AdventureSecondLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );
              }

              if (widget.level == 3) {
                return AdventureThirdLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );
              }

              if (widget.level == 4) {
                return AdventureFourthLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );
              }

              if (widget.level == 5) {
                return AdventureFifthLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );
              }

              if (widget.level == 6) {
                return AdventureSixthLevelScreen(
                  difficulty: widget.difficulty,
                  level: widget.level,
                );
              }

              return Text("");
            },

            transitionsBuilder:
                (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    };

    _controller.addStatusListener(_animationListener);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_animationListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOut),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _player1Slide,
                      child: FadeTransition(
                        opacity: _fadeIn,
                        child: AdventurePlayerCard(name: "Player 1"),
                      ),
                    ),
                    const SizedBox(width: 80),
                    ScaleTransition(
                      scale: _vsScale,
                      child: Text(
                        "VS",
                        style: GoogleFonts.bebasNeue(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    SlideTransition(
                      position: _player2Slide,
                      child: FadeTransition(
                        opacity: _fadeIn,
                        child: AdventureBotCard(
                          name: "Adventure ${widget.level}",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
