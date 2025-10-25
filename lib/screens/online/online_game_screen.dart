import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/widgets/player_tile.dart';

class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({super.key, required this.matchId});

  final String matchId;

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  final firestoreService = FirebaseFirestoreService();

  final currentUser = FirebaseAuth.instance.currentUser;

  bool isResigning = false;

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
            return const Center(child: Text("Match not found."));
          }

          final matchData = snapshot.data!.data() as Map<String, dynamic>?;

          if (matchData == null) {
            return const Center(child: Text("No match data."));
          }

          final player1Id = matchData['player1Id'];
          final player1Name = matchData['player1Name'] ?? 'Player 1';
          final player1Rating = matchData['player1Rating'] ?? 0;
          final player1Score = matchData['player1Score'];

          final player2Id = matchData['player2Id'];
          final player2Name = matchData['player2Name'] ?? 'WPlayer 2';
          final player2Rating = matchData['player2Rating'] ?? 0;
          final player2Score = matchData['player2Score'];

          final playerAskingRematch = matchData['playerAskingRematch'];

          final winner = matchData['winner'];

          String player1Status = "";
          String player2Status = "";

          int player1ChangeRating = 0;
          int player2ChangeRating = 0;

          if (winner == player1Id) {
            player1Status = "Winner";
            player2Status = "Loser";

            player1ChangeRating = matchData['winnerNewRating'] - player1Rating;
            player2ChangeRating = matchData['loserNewRating'] - player2Rating;
          }

          if (winner == player2Id) {
            player1Status = "Loser";
            player2Status = "Winner";

            player1ChangeRating = matchData['loserNewRating'] - player1Rating;
            player2ChangeRating = matchData['winnerNewRating'] - player2Rating;
          }

          if (winner != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayerTile(
                    score: player1Score,
                    name: player1Name,
                    rating: player1Rating,
                    changeRating: player1ChangeRating,
                    playerStatus: player1Status,
                  ),
                  PlayerTile(
                    score: player2Score,
                    name: player2Name,
                    rating: player2Rating,
                    changeRating: player2ChangeRating,
                    playerStatus: player2Status,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to Menu"),
                  ),
                  if (playerAskingRematch != null &&
                      playerAskingRematch != currentUser!.uid)
                    Column(
                      children: [
                        Text(
                          playerAskingRematch == player1Id
                              ? "$player1Name is asking for rematch..."
                              : "$player2Name is asking for rematch...",
                        ),
                        ElevatedButton(
                          onPressed: () => declineRematch(widget.matchId),
                          child: Text("Decline Rematch"),
                        ),
                        ElevatedButton(
                          onPressed: () => acceptRematch(widget.matchId),
                          child: Text("Accept Rematch"),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed:
                          () => showAskRematchDialog(
                            widget.matchId,
                            player1Rating + player1ChangeRating,
                            player2Rating + player2ChangeRating,
                          ),
                      child: Text("Rematch"),
                    ),
                ],
              ),
            );
          }

          return Column(
            children: [
              PlayerTile(
                score: player1Score,
                name: player1Name,
                rating: player1Rating,
              ),
              PlayerTile(
                score: player2Score,
                name: player2Name,
                rating: player2Rating,
              ),
              ElevatedButton(
                onPressed:
                    () => showResignDialog(
                      player1Id,
                      player1Name,
                      player1Rating,
                      player2Id,
                      player2Name,
                      player2Rating,
                      player1Score,
                      player2Score,
                    ),
                child: Text("Resign"),
              ),
            ],
          );
        },
      ),
    );
  }

  void showResignDialog(
    player1Id,
    player1Name,
    player1Rating,
    player2Id,
    player2Name,
    player2Rating,
    player1Score,
    player2Score,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resign Game"),
          content: Column(children: [Text("Are you sure you want to resign?")]),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed:
                  () => resign(
                    player1Id,
                    player1Name,
                    player1Rating,
                    player2Id,
                    player2Name,
                    player2Rating,
                    player1Score,
                    player2Score,
                  ),
              child: Text("Resign"),
            ),
          ],
        );
      },
    );
  }

  void resign(
    player1Id,
    player1Name,
    player1Rating,
    player2Id,
    player2Name,
    player2Rating,
    player1Score,
    player2Score,
  ) async {
    final loserId = currentUser?.uid;
    final winnerId = loserId == player1Id ? player2Id : player1Id;

    int winnerRating, loserRating;

    if (winnerId == player1Id) {
      winnerRating = player1Rating;
      loserRating = player2Rating;
      player1Score += 1;
    } else {
      winnerRating = player2Rating;
      loserRating = player1Rating;
      player2Score += 1;
    }

    int newWinnerRating = calculateNewRating(winnerRating, loserRating, 1);
    int newLoserRating = calculateNewRating(loserRating, winnerRating, 0);

    await firestoreService.updateMatchResult(
      matchId: widget.matchId,
      winnerId: winnerId,
      loserId: loserId!,
      winnerNewRating: newWinnerRating,
      loserNewRating: newLoserRating,
      player1Score: player1Score,
      player2Score: player2Score,
    );

    await firestoreService.updateUserRating(
      winnerId,
      newWinnerRating,
      winner: true,
    );
    await firestoreService.updateUserRating(loserId, newLoserRating);

    Navigator.pop(context);
  }

  int calculateNewRating(int yourRating, int opponentRating, int actualScore) {
    final K = 10;
    final expectedScore =
        1 / (1 + pow(10, (opponentRating - yourRating) / 400));

    return (yourRating + K * (actualScore - expectedScore)).round();
  }

  void showAskRematchDialog(
    String previousMatchId,
    int player1NewRating,
    int player2NewRating,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Rematch"),
          content: Text("Are you sure you want a rematch?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed:
                  () => askRematch(
                    previousMatchId,
                    player1NewRating,
                    player2NewRating,
                  ),
              child: Text("Rematch"),
            ),
          ],
        );
      },
    );
  }

  void askRematch(
    String previousMatchId,
    int player1NewRating,
    int player2NewRating,
  ) async {
    Navigator.of(context).pop();

    final user = FirebaseAuth.instance.currentUser;

    await firestoreService.askRematch(matchId: previousMatchId, uid: user!.uid);
    final rematch = await firestoreService.rematch(
      previousMatchId,
      player1NewRating,
      player2NewRating,
    );

    final rematchId = rematch.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StreamBuilder(
          stream: firestoreService.getMatch(matchId: rematchId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;

              if (data?['status'] == 'playing') {
                Future.microtask(() {
                  Navigator.of(context).pop();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OnlineGameScreen(matchId: rematchId),
                    ),
                  );
                });
              }
            }
            return AlertDialog(
              content: Column(
                children: const [
                  CircularProgressIndicator(),
                  Text("Waiting for opponent to accept..."),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    await firestoreService.askRematch(
                      matchId: previousMatchId,
                      uid: null,
                    );
                    await firestoreService.cancelMatch(matchId: rematchId);

                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void acceptRematch(String previousMatchId) async {
    final rematch = await firestoreService.findRematch(
      previousMatchId: previousMatchId,
    );

    if (rematch.docs.isNotEmpty) {
      final rematchId = rematch.docs.first.id;
      await firestoreService.acceptRematch(rematchId: rematchId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnlineGameScreen(matchId: rematchId)),
      );
    }
  }

  void declineRematch(String previousMatchId) async {
    await firestoreService.askRematch(matchId: previousMatchId, uid: null);

    final rematch = await firestoreService.findRematch(
      previousMatchId: previousMatchId,
    );

    if (rematch.docs.isNotEmpty) {
      final rematchId = rematch.docs.first.id;
      await firestoreService.cancelMatch(matchId: rematchId);
    }
  }
}
