import 'package:flutter/material.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/online/game_match/player_vs_opponent.dart';

class WaitingForOpponentScreen extends StatefulWidget {
  const WaitingForOpponentScreen({super.key, required this.matchId});

  final String matchId;

  @override
  State<WaitingForOpponentScreen> createState() =>
      _WaitingForOpponentScreenState();
}

class _WaitingForOpponentScreenState extends State<WaitingForOpponentScreen> {
  final firestoreService = FirebaseFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: firestoreService.getMatch(matchId: widget.matchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Match no longer available."),
                ],
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data!['status'] == 'playing') {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayerVsOpponent(matchId: widget.matchId),
                ),
              );
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Waiting for an opponent..."),
                ElevatedButton(
                  onPressed: () async {
                    await firestoreService.cancelMatch(matchId: widget.matchId);
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
