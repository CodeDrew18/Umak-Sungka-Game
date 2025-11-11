
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/online/game_match/player_vs_opponent_card.dart';
import 'package:sungka/screens/online/online_game_screen.dart';


class PlayerVsOpponent extends StatefulWidget {
 const PlayerVsOpponent({
  required this.matchId,
  required this.navigateToScreen,
  required this.showError,
  super.key,
 });

 final String matchId;
 final Function(Widget screen) navigateToScreen;
 final Function(String message) showError;

 @override
 State<PlayerVsOpponent> createState() => _PlayerVsOpponentState();
}

class _PlayerVsOpponentState extends State<PlayerVsOpponent>
  with TickerProviderStateMixin {
 late AnimationController _controller;
 late Animation<double> _fadeIn;
 late Animation<Offset> _player1Slide;
 late Animation<Offset> _player2Slide;
 late Animation<double> _vsScale;
 late Animation<double> _fadeOut;

 final firestoreService = FirebaseFirestoreService();

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
      pageBuilder: (_, __, ___) => OnlineGameScreen(
       matchId: widget.matchId,
       navigateToScreen: widget.navigateToScreen,
       showError: widget.showError,
      ),
      transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
     ),
    );
   }
  });
 }

 @override
 void dispose() {
  _controller.removeStatusListener((_) {});
  _controller.dispose();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return StreamBuilder(
   stream: firestoreService.getMatch(matchId: widget.matchId),
   builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
     return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
     );
    }

    if (!snapshot.hasData || !snapshot.data!.exists) {
     return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
       child: Text(
        "Match not found.",
        style: TextStyle(color: Colors.white),
       ),
      ),
     );
    }

    final matchData = snapshot.data!.data() as Map<String, dynamic>?;

    if (matchData == null) {
     return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
       child: Text("No match data.", style: TextStyle(color: Colors.white)),
      ),
     );
    }

    final player1Name = matchData['player1Name'] ?? 'Player 1';
    final player2Name = matchData['player2Name'] ?? 'Player 2';
    final player1Rating = matchData['player1Rating'] ?? 0;
    final player2Rating = matchData['player2Rating'] ?? 0;

return AnimatedBuilder(
 animation: _controller,
 builder: (context, child) {
  return Scaffold(
   backgroundColor: Colors.black,
   body: SafeArea(
    child: Center(
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
          child: PlayerVsOpponentCard(
           name: player1Name,
          ),
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
          child: PlayerVsOpponentCard(
           name: player2Name,
          ),
         ),
        ),
       ],
      ),
     ),
    ),
   ),
  );
 },
);

   },
  );
 }
}