import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/home_screen.dart'; 
import 'package:sungka/screens/online/game_match/player_vs_opponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaitingForOpponentScreen extends StatefulWidget {
  const WaitingForOpponentScreen({super.key, required this.matchId});

  final String matchId;

  @override
  State<WaitingForOpponentScreen> createState() =>
      _WaitingForOpponentScreenState();
}

class _WaitingForOpponentScreenState extends State<WaitingForOpponentScreen>
    with TickerProviderStateMixin {
  final firestoreService = FirebaseFirestoreService();
  late AnimationController _glowController;
  late AnimationController _pulseController;

  Timer? botTimer;
  bool botJoined = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    botTimer = Timer(const Duration(seconds: 30), joinBotIfNoOpponent);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();

    botTimer?.cancel();
    super.dispose();
  }
  void _navigateToScreen(Widget screen) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

   Future<void> joinBotIfNoOpponent() async {
    if (botJoined) return;

    try {
      final matchSnapshot = await firestoreService.getMatchOnce(matchId: widget.matchId);
      if (!matchSnapshot.exists) return;

      final matchData = matchSnapshot.data() as Map<String, dynamic>;
      final player1Id = matchData['player1Id'];
      final player2Id = matchData['player2Id'];

      if (player2Id == null || player2Id.isEmpty) {
        botJoined = true;

        final player1Rating = matchData['player1Rating'] ?? 800;
        String difficulty;
        if (player1Rating <= 800) {
          difficulty = 'easy';
        } else if (player1Rating <= 1200) {
          difficulty = 'medium';
        } else {
          difficulty = 'hard';
        }

        await FirebaseFirestore.instance.collection('matches').doc(widget.matchId).update({
          'player2Id': 'bot_1',
          'player2Name': 'Bot1',
          'player2Rating': player1Rating,
          'difficulty': difficulty,
          'status': 'playing',
        });
      }
    } catch (e) {
      debugPrint('Error adding bot: $e');
    }
  }

  void _showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: firestoreService.getMatch(matchId: widget.matchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen("Connecting...");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildError("Match no longer available.");
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data!['status'] == 'playing') {
            Future.microtask(() {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerVsOpponent(
                    matchId: widget.matchId,
                    navigateToScreen: _navigateToScreen, 
                    showError: _showError, 
                  ),
                ),
              );
            });
          }

          return _buildLoadingScreen("Searching for opponent...");
        },
      ),
    );
  }

  Widget _buildLoadingScreen(String message) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade900,
                    Colors.purple.shade700,
                    Colors.deepOrange.shade800,
                    Colors.amber.shade600,
                  ],
                  stops: [
                    0,
                    0.5 + 0.1 * sin(_glowController.value * 2 * pi),
                    0.8,
                    1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1)
                    .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Icon(
                    Icons.sports_esports_rounded,
                    size: 100,
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      Shadow(
                        color: Colors.amberAccent.withOpacity(0.8),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Text(
                    message,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.amber.withOpacity(
                            0.6 + 0.3 * sin(_pulseController.value * 2 * pi),
                          ),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildLoadingDots(),
              const SizedBox(height: 80),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade400,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                onPressed: () async {

                  await firestoreService.cancelMatch(matchId: widget.matchId);

                  _navigateToScreen(
                    GameWidget(
                      game: HomeGame(
                        navigateToScreen: _navigateToScreen, 
                        showError: _showError, 
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Cancel Matchmaking",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final t = (_pulseController.value + (i * 0.3)) % 1;
            final opacity = (sin(t * 2 * pi) * 0.5 + 0.5);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amberAccent.withOpacity(opacity),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildError(String message) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.amberAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Go Back",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}