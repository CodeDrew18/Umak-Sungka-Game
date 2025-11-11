import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/bot/player_vs_bot_screen.dart';
import 'package:sungka/screens/leaderboard_screen.dart';
import 'package:sungka/screens/online/online_game_screen.dart';
import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';

class BattleModeScreen extends StatefulWidget {
  const BattleModeScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
  });

  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  @override
  State<BattleModeScreen> createState() => _BattleModeScreenState();
}

class _BattleModeScreenState extends State<BattleModeScreen> {
  final firestoreService = FirebaseFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("Choose Your Battle Mode"),
            ElevatedButton(onPressed: online, child: Text("Player VS Player")),
            ElevatedButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PlayerVsBotScreen()),
                  ),
              child: Text("Player VS Bot"),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LeaderboardScreen()),
                  ),
              child: Text("Leaderboard"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuthService().logout();
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> online() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userDoc = await firestoreService.getUser(user: user!);

      if (!userDoc.exists) throw Exception("User not found.");

      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData["name"];
      final userRating = userData['rating'] ?? 800;
      final minRating = userRating - 100;
      final maxRating = userRating + 100;
      final findMatch = await firestoreService.findMatch(
        minRating: minRating,
        maxRating: maxRating,
      );

      if (findMatch.docs.isNotEmpty) {
        final match = findMatch.docs.first;

        await firestoreService.joinMatch(
          matchId: match.id,
          userId: user.uid,
          userName: userName,
          rating: userRating,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => OnlineGameScreen(
                  matchId: match.id,
                  navigateToScreen: widget.navigateToScreen,
                  showError: widget.showError,
                ),
          ),
        );
      } else {
        final newMatch = await firestoreService.newMatch(
          userId: user.uid,
          userName: userName,
          userRating: userRating,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WaitingForOpponentScreen(matchId: newMatch.id),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}
