// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sungka/core/services/firebase_firestore_service.dart';
// import 'package:sungka/screens/widgets/player_tile.dart';

// class OnlineGameScreen extends StatefulWidget {
//   const OnlineGameScreen({super.key, required this.matchId});

//   final String matchId;

//   @override
//   State<OnlineGameScreen> createState() => _OnlineGameScreenState();
// }

// class _OnlineGameScreenState extends State<OnlineGameScreen> {
//   final firestoreService = FirebaseFirestoreService();

//   final currentUser = FirebaseAuth.instance.currentUser;

//   bool isResigning = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: firestoreService.getMatch(matchId: widget.matchId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("Match not found."));
//           }

//           final matchData = snapshot.data!.data() as Map<String, dynamic>?;

//           if (matchData == null) {
//             return const Center(child: Text("No match data."));
//           }

//           final player1Id = matchData['player1Id'];
//           final player1Name = matchData['player1Name'] ?? 'Player 1';
//           final player1Rating = matchData['player1Rating'] ?? 0;
//           final player1Score = matchData['player1Score'];

//           final player2Id = matchData['player2Id'];
//           final player2Name = matchData['player2Name'] ?? 'Player 2';
//           final player2Rating = matchData['player2Rating'] ?? 0;
//           final player2Score = matchData['player2Score'];

//           final winner = matchData['winner'];
//           final loser = matchData['loser'];

//           String player1Status = "";
//           String player2Status = "";

//           int player1ChangeRating = 0;
//           int player2ChangeRating = 0;

//           if (winner == player1Id) {
//             player1Status = "Winner";
//             player2Status = "Loser";

//             player1ChangeRating = matchData['winnerNewRating'] - player1Rating;
//             player2ChangeRating = matchData['loserNewRating'] - player2Rating;
//           }

//           if (winner == player2Id) {
//             player1Status = "Loser";
//             player2Status = "Winner";

//             player1ChangeRating = matchData['loserNewRating'] - player1Rating;
//             player2ChangeRating = matchData['winnerNewRating'] - player2Rating;
//           }

//           if (winner != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   PlayerTile(
//                     score: player1Score,
//                     name: player1Name,
//                     rating: player1Rating,
//                     changeRating: player1ChangeRating,
//                     playerStatus: player1Status,
//                   ),
//                   PlayerTile(
//                     score: player2Score,
//                     name: player2Name,
//                     rating: player2Rating,
//                     changeRating: player2ChangeRating,
//                     playerStatus: player2Status,
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Back to Menu"),
//                   ),
//                   ElevatedButton(onPressed: null, child: Text("Rematch")),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               PlayerTile(
//                 score: player1Score,
//                 name: player1Name,
//                 rating: player1Rating,
//               ),
//               PlayerTile(
//                 score: player2Score,
//                 name: player2Name,
//                 rating: player2Rating,
//               ),
//               ElevatedButton(
//                 onPressed:
//                     () => showResignDialog(
//                       player1Id,
//                       player1Name,
//                       player1Rating,
//                       player2Id,
//                       player2Name,
//                       player2Rating,
//                       player1Score,
//                       player2Score,
//                     ),
//                 child: Text("Resign"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void showResignDialog(
//     player1Id,
//     player1Name,
//     player1Rating,
//     player2Id,
//     player2Name,
//     player2Rating,
//     player1Score,
//     player2Score,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Resign Game"),
//           content: Column(children: [Text("Are you sure you want to resign?")]),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed:
//                   () => resign(
//                     player1Id,
//                     player1Name,
//                     player1Rating,
//                     player2Id,
//                     player2Name,
//                     player2Rating,
//                     player1Score,
//                     player2Score,
//                   ),
//               child: Text("Resign"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void resign(
//     player1Id,
//     player1Name,
//     player1Rating,
//     player2Id,
//     player2Name,
//     player2Rating,
//     player1Score,
//     player2Score,
//   ) async {
//     final loserId = currentUser?.uid;
//     final winnerId = loserId == player1Id ? player2Id : player1Id;

//     int winnerRating, loserRating;

//     if (winnerId == player1Id) {
//       winnerRating = player1Rating;
//       loserRating = player2Rating;
//       player1Score += 1;
//     } else {
//       winnerRating = player2Rating;
//       loserRating = player1Rating;
//       player2Score += 1;
//     }

//     int newWinnerRating = calculateNewRating(winnerRating, loserRating, 1);
//     int newLoserRating = calculateNewRating(loserRating, winnerRating, 0);

//     await firestoreService.updateMatchResult(
//       matchId: widget.matchId,
//       winnerId: winnerId,
//       loserId: loserId!,
//       winnerNewRating: newWinnerRating,
//       loserNewRating: newLoserRating,
//       player1Score: player1Score,
//       player2Score: player2Score,
//     );

//     await firestoreService.updateUserRating(
//       winnerId,
//       newWinnerRating,
//       winner: true,
//     );
//     await firestoreService.updateUserRating(loserId, newLoserRating);

//     Navigator.pop(context);
//   }

//   int calculateNewRating(int yourRating, int opponentRating, int actualScore) {
//     final K = 10;
//     final expectedScore =
//         1 / (1 + pow(10, (opponentRating - yourRating) / 400));

//     return (yourRating + K * (actualScore - expectedScore)).round();
//   }
// }

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/services/bot_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
import 'package:sungka/screens/widgets/player_tile.dart';
import 'package:sungka/screens/start_game_screen.dart';
import 'package:flame/game.dart';
import 'package:sungka/screens/widgets/sungka_board.dart';

class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({
    super.key,
    required this.matchId,
    required this.navigateToScreen,
    required this.showError,
  });

  final String matchId;
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  final firestoreService = FirebaseFirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isMakingMove = false;

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
          final player2Id = matchData['player2Id'];

          final player1Name = matchData['player1Name'] ?? 'Player 1';
          final player2Name = matchData['player2Name'] ?? 'Player 2';
          final player1Rating = matchData['player1Rating'] ?? 0;
          final player2Rating = matchData['player2Rating'] ?? 0;
          int player1Score = matchData['player1Score'] ?? 0;
          int player2Score = matchData['player2Score'] ?? 0;

          final winner = matchData['winner'];
          final isGameOver = matchData['isGameOver'] ?? false;
          final board = List<int>.from(matchData['board']);
          final turnId = matchData['turnId'];
          final isMyTurn = turnId == currentUser!.uid;

          final difficulty = matchData['difficulty'] ?? 'easy';
          if (player2Id == 'bot_1' && turnId == player2Id && !isMakingMove) {
            botPlay(
              board,
              player1Id,
              player2Id,
              player1Rating,
              player2Rating,
              player1Score,
              player2Score,
              difficulty,
            );
          }

          if (winner != null || isGameOver) {
            String player1Status = "";
            String player2Status = "";
            int player1ChangeRating = 0;
            int player2ChangeRating = 0;

            if (winner == "draw") {
              player1Status = "Draw";
              player2Status = "Draw";
              player1ChangeRating = 0;
              player2ChangeRating = 0;
            } else if (winner == player1Id) {
              player1Status = "Winner";
              player2Status = "Loser";
              player1ChangeRating =
                  (matchData['winnerNewRating'] ?? 0) - player1Rating;
              player2ChangeRating =
                  (matchData['loserNewRating'] ?? 0) - player2Rating;
            } else if (winner == player2Id) {
              player1Status = "Loser";
              player2Status = "Winner";
              player1ChangeRating =
                  (matchData['loserNewRating'] ?? 0) - player1Rating;
              player2ChangeRating =
                  (matchData['winnerNewRating'] ?? 0) - player2Rating;
            }

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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!mounted) return;
                      widget.navigateToScreen(
                        GameWidget(
                          game: StartMenuGame(
                            navigateToScreen: widget.navigateToScreen,
                            showError: widget.showError,
                          ),
                        ),
                      );
                    },
                    child: const Text("Back to Menu"),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerTile(
                  score: player2Score,
                  name: player2Name,
                  rating: player2Rating,
                  isCurrentTurn: turnId == player2Id,
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: SungkaBoard(
                    board: board,
                    isPlayerTurn: isMyTurn,
                    isGameOver: isGameOver,
                    topPlayerName: player2Name,
                    bottomPlayerName: player1Name,
                    onPitTap:
                        (pit) => handlePitTap(
                          pit,
                          board,
                          player1Id,
                          player2Id,
                          player1Rating,
                          player2Rating,
                          player1Score,
                          player2Score,
                        ),
                  ),
                ),

                const SizedBox(height: 10),
                PlayerTile(
                  score: player1Score,
                  name: player1Name,
                  rating: player1Rating,
                  isCurrentTurn: turnId == player1Id,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      () => showResignDialog(
                        player1Id,
                        player2Id,
                        player1Rating,
                        player2Rating,
                        player1Score,
                        player2Score,
                      ),
                  child: const Text("Resign"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> handlePitTap(
    int pit,
    List<int> board,
    String player1Id,
    String player2Id,
    int player1Rating,
    int player2Rating,
    int player1Score,
    int player2Score,
  ) async {
    if (isMakingMove) return;
    if (!mounted) return;
    setState(() => isMakingMove = true);

    try {
      final isPlayer1Turn = currentUser!.uid == player1Id;
      final newBoard = GameLogic.makeMove(board, pit, isPlayer1Turn);
      final result = GameLogic.checkEndGame(newBoard);

      if (result['isEnded']) {
        final finalBoard = result['finalBoard'];
        final outcome = GameLogic.getWinner(finalBoard);
        await handleGameOver(
          outcome,
          finalBoard,
          player1Id,
          player2Id,
          player1Rating,
          player2Rating,
          player1Score,
          player2Score,
        );
      } else {
        final nextTurnId = isPlayer1Turn ? player2Id : player1Id;
        await firestoreService.updateBoardAndTurn(
          matchId: widget.matchId,
          newBoard: newBoard,
          nextTurnId: nextTurnId,
        );
      }
    } catch (e) {
      widget.showError("Error during move: $e");
    } finally {
      if (mounted) {
        setState(() => isMakingMove = false);
      }
    }
  }

  Future<void> handleGameOver(
    String outcome,
    List<int> board,
    String player1Id,
    String player2Id,
    int player1Rating,
    int player2Rating,
    int player1Score,
    int player2Score,
  ) async {
    String? winnerId;
    String? loserId;
    int newWinnerRating = player1Rating;
    int newLoserRating = player2Rating;

    if (outcome == 'player') {
      winnerId = player1Id;
      loserId = player2Id;
      player1Score++;
      newWinnerRating = calculateNewRating(player1Rating, player2Rating, 1);
      newLoserRating = calculateNewRating(player2Rating, player1Rating, 0);
    } else if (outcome == 'bot') {
      winnerId = player2Id;
      loserId = player1Id;
      player2Score++;
      newWinnerRating = calculateNewRating(player2Rating, player1Rating, 1);
      newLoserRating = calculateNewRating(player1Rating, player2Rating, 0);
    } else {
      winnerId = "draw";
      newWinnerRating = calculateNewRating(player1Rating, player2Rating, 0.5);
      newLoserRating = calculateNewRating(player2Rating, player1Rating, 0.5);
      player1Score++;
      player2Score++;
    }

    await firestoreService.updateMatchResult(
      matchId: widget.matchId,
      winnerId: winnerId,
      loserId: loserId,
      winnerNewRating: newWinnerRating,
      loserNewRating: newLoserRating,
      player1Score: player1Score,
      player2Score: player2Score,
      board: board,
      isGameOver: true,
    );

    // Update user ratings only for real users
    if (winnerId != "draw" && winnerId != "bot_1") {
      await firestoreService.updateUserRating(
        winnerId,
        newWinnerRating,
        winner: true,
      );
    }
    if (loserId != null && loserId != "bot_1") {
      await firestoreService.updateUserRating(loserId, newLoserRating);
    }
  }

  void showResignDialog(
    player1Id,
    player2Id,
    player1Rating,
    player2Rating,
    player1Score,
    player2Score,
  ) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Resign Game"),
          content: const Text("Are you sure you want to resign?"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resign(
                  player1Id,
                  player2Id,
                  player1Rating,
                  player2Rating,
                  player1Score,
                  player2Score,
                );
              },
              child: const Text("Resign"),
            ),
          ],
        );
      },
    );
  }

  Future<void> resign(
    String player1Id,
    String player2Id,
    int player1Rating,
    int player2Rating,
    int player1Score,
    int player2Score,
  ) async {
    final loserId = currentUser!.uid;
    final winnerId = loserId == player1Id ? player2Id : player1Id;

    int winnerRating = winnerId == player1Id ? player1Rating : player2Rating;
    int loserRating = loserId == player1Id ? player1Rating : player2Rating;

    int newWinnerRating = calculateNewRating(winnerRating, loserRating, 1);
    int newLoserRating = calculateNewRating(loserRating, winnerRating, 0);

    if (winnerId == player1Id) {
      player1Score++;
    } else {
      player2Score++;
    }

    await firestoreService.updateMatchResult(
      matchId: widget.matchId,
      winnerId: winnerId,
      loserId: loserId,
      winnerNewRating: newWinnerRating,
      loserNewRating: newLoserRating,
      player1Score: player1Score,
      player2Score: player2Score,
      isGameOver: true,
    );

    // Update user ratings only for real users
    if (winnerId != "bot_1") {
      await firestoreService.updateUserRating(
        winnerId,
        newWinnerRating,
        winner: true,
      );
    }

    if (loserId != "bot_1") {
      await firestoreService.updateUserRating(loserId, newLoserRating);
    }
  }

  int calculateNewRating(
    int yourRating,
    int opponentRating,
    double actualScore,
  ) {
    const K = 10;
    final expectedScore =
        1 / (1 + pow(10, (opponentRating - yourRating) / 400));
    return (yourRating + K * (actualScore - expectedScore)).round();
  }

  void botPlay(
    List<int> board,
    String player1Id,
    String player2Id,
    int player1Rating,
    int player2Rating,
    int player1Score,
    int player2Score,
    String difficulty,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final validDifficulties = {
      'easy': Difficulty.easy,
      'medium': Difficulty.medium,
      'hard': Difficulty.hard,
    };

    final diff = validDifficulties[difficulty] ?? Difficulty.easy;

    final pit = BotService.getBotMove(board, diff);
    if (pit == -1) return;

    final newBoard = GameLogic.makeMove(board, pit, false);
    final result = GameLogic.checkEndGame(newBoard);

    if (result['isEnded']) {
      final finalBoard = result['finalBoard'];
      final outcome = GameLogic.getWinner(finalBoard);
      await handleGameOver(
        outcome,
        finalBoard,
        player1Id,
        player2Id,
        player1Rating,
        player2Rating,
        player1Score,
        player2Score,
      );
    } else {
      await firestoreService.updateBoardAndTurn(
        matchId: widget.matchId,
        newBoard: newBoard,
        nextTurnId: player1Id,
      );
    }
  }
}
