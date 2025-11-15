import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/player_vs_bot/game_match/bot_card.dart';
import 'package:sungka/screens/player_vs_bot/game_match/player_card.dart';
import 'package:sungka/screens/player_vs_bot/on_match/match_game_screen.dart';

class PlayerVsBot extends StatefulWidget {
  final dynamic difficulty;
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;
  final musicLevel;
  const PlayerVsBot({
    Key? key,
    required this.difficulty,
    required this.bgmPlayer,
    required this.navigateToScreen,
    required this.showError,
    required this.musicLevel
  }) : super(key: key);

  @override
  State<PlayerVsBot> createState() => _PlayerVsBotState();
}

class _PlayerVsBotState extends State<PlayerVsBot>
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
            pageBuilder:
                (_, __, ___) => SungkaBoardScreen(
                  difficulty: widget.difficulty,
                  bgmPlayer: widget.bgmPlayer,
                  navigateToScreen: widget.navigateToScreen,
                  showError: widget.showError,
                  musicLevel: widget.musicLevel,
                ),
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
                        child: PlayerCard(name: "Player 1"),
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
                        child: BotCard(name: "Bot"),
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
