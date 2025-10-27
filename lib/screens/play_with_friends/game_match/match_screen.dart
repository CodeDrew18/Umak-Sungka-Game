import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/play_with_friends/game_match/player_card.dart';
import 'package:sungka/screens/play_with_friends/on_match/on_match_screen.dart';

class MatchScreen extends StatefulWidget {
  final String player1Name;
  final IconData player1Icon;
  final Color player1Color;

  final String player2Name;
  final IconData player2Icon;
  final Color player2Color;

  const MatchScreen({
    super.key,
    required this.player1Name,
    required this.player1Icon,
    required this.player1Color,
    required this.player2Name,
    required this.player2Icon,
    required this.player2Color,
  });

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _player1Slide;
  late Animation<Offset> _player2Slide;
  late Animation<double> _vsScale;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

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

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const OnMatchScreen(),
            transitionsBuilder:
                (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Gap(20),

              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOut),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Player 1
                      SlideTransition(
                        position: _player1Slide,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: PlayerCard(
                            name: widget.player1Name,
                            icon: widget.player1Icon,
                            color: widget.player1Color,
                          ),
                        ),
                      ),

                      // VS Text
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

                      // Player 2
                      SlideTransition(
                        position: _player2Slide,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: PlayerCard(
                            name: widget.player2Name,
                            icon: widget.player2Icon,
                            color: widget.player2Color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_fadeOut),
                    child: Image.asset(
                      "assets/empty_board.png",
                      width: 500,
                      height: 500,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      );
    },
  );
}

}
