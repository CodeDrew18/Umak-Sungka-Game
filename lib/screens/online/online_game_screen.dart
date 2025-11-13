

// //Runnable but need to fix

// import 'dart:async';
// import 'dart:math';
// import 'dart:ui'; // Added for CustomPaint
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:sungka/core/services/bot_service.dart';
// import 'package:sungka/core/services/firebase_firestore_service.dart';
// import 'package:sungka/core/services/game_logic_service.dart';
// import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';
// import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
// import 'package:sungka/screens/start_game_screen.dart';

// // Assuming Difficulty, PlayerCards, GameWidget, StartMenuGame are imported or defined externally.
// // PitWidget, StoreWidget, GameOverDialog, calculateNewRating, AnimatingPebbleData, and AnimatedPebblesPainter
// // are defined below or provided as placeholders to ensure the file is complete.

// class OnlineGameScreen extends StatefulWidget {
//   const OnlineGameScreen({
//     super.key,
//     required this.matchId,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   final String matchId;
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   @override
//   State<OnlineGameScreen> createState() => _OnlineGameScreenState();
// }

// class _OnlineGameScreenState extends State<OnlineGameScreen>
//     with TickerProviderStateMixin {
//   final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
//   final currentUser = FirebaseAuth.instance.currentUser;

//   // Cached match data from Firestore stream
//   Map<String, dynamic>? matchData;
//   StreamSubscription? _matchSub;

//   // Local state flags
//   bool isMakingMove = false;
//   bool botThinking = false;

//   // Animation State (NEW)
//   int? animatingPit;
//   int? lastMove;
//   List<AnimatingPebbleData> animatingPebbles = [];

//   // UI constants
//   static const String _woodenTexturePath =
//       'assets/images/assets/texture_test.jpg';

//   final GlobalKey _boardKey = GlobalKey();
//   String? _lastTurnId;

//   @override
//   void initState() {
//     super.initState();
//     _startMatchSubscription();
//   }

//   void _startMatchSubscription() {
//     _matchSub = firestoreService.getMatch(matchId: widget.matchId).listen(
//       (snapshot) {
//         if (!snapshot.exists) return;
//         final data = snapshot.data() as Map<String, dynamic>?;
//         if (data == null) return;

//         final prevData = matchData;
//         matchData = data;

//         final turnId = data['turnId'];
//         final player2Id = data['player2Id'];
//         final difficulty = data['difficulty'] ?? 'easy';
//         final board = List<int>.from(data['board']);

//         // ✅ detect change of turnId
//         final turnChanged = turnId != _lastTurnId;
//         _lastTurnId = turnId;

//         // ✅ only trigger bot when turn actually changes to bot_1
//         if (player2Id == 'bot_1' && turnChanged && turnId == 'bot_1') {
//           if (!botThinking) {
//             // We only need to check botThinking here. isMakingMove is handled by _handlePitTap
//             Future.delayed(const Duration(milliseconds: 900), () {
//               if (!mounted) return;
//               _botPlay(board, data, difficulty);
//             });
//           }
//         }

//         // Only call setState if data actually changed OR if we are currently animating,
//         // as the animation loop might update matchData locally.
//         if (mounted && (!mapEquals(prevData, matchData) || animatingPebbles.isNotEmpty)) {
//           setState(() {});
//         }
//       },
//       onError: (e) {
//         widget.showError("Match stream error: $e");
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _matchSub?.cancel();
//     super.dispose();
//   }

//   // NEW: Geometry calculation for animation
//   Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
//     // These constants are estimated based on typical Sungka board layout
//     const storeWidth = 58.0;
//     const sidePadding = 8.0; 
//     const verticalPadding = 24.0; 

//     bool isTop = pitIndex > 7;
//     // Map pit index (0-6 for player bottom, 8-14 for player top/opponent bottom) to column index (0-6)
//     int col = isTop ? 14 - pitIndex : pitIndex;

//     // Calculate grid width (total width minus stores and side margins)
//     double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
//     double pitSpacing = gridWidth / 7;

//     // Calculate X position
//     const boardContainerPadding = 12.0;

//     double x = boardContainerPadding + storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);

//     // Calculate Y position 
//     double y = isTop
//         ? (boardContainerPadding + verticalPadding + pitSize / 2)
//         : (boardContainerPadding + verticalPadding * 2 + pitSize + pitSize / 2);

//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // UI textures
//     const _boardTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//     );
//     const _pitStoreTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//       colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
//     );

//     // If match data hasn't arrived yet show loader
//     if (matchData == null) {
//       return const Scaffold(
//         backgroundColor: Color(0xFF1E0E0E),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     // Extract the current match snapshot (cached locally)
//     final data = matchData!;
//     final player1Id = data['player1Id'];
//     final player2Id = data['player2Id'];
//     final player1Name = data['player1Name'] ?? 'Player 1';
//     final player2Name = data['player2Name'] ?? 'Player 2';
//     final player1Rating = data['player1Rating'] ?? 0;
//     final player2Rating = data['player2Rating'] ?? 0;
//     int player1Score = data['player1Score'] ?? 0;
//     int player2Score = data['player2Score'] ?? 0;

//     final winner = data['winner'];
//     final isGameOver = data['isGameOver'] ?? false;
//     final board = List<int>.from(data['board']);
//     final turnId = data['turnId'];
//     final isMyTurn = turnId == currentUser!.uid;
//     final isPlayer1 = currentUser!.uid == player1Id;
//     final difficulty = data['difficulty'] ?? 'easy';

//     // Game over screen
//     if (winner != null || isGameOver) {
//       return _buildGameOverScreen(
//         data,
//         player1Id,
//         player2Id,
//         player1Name,
//         player2Name,
//         player1Rating,
//         player2Rating,
//         winner,
//       );
//     }

//     // Responsive pit size
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pitSize = screenWidth < 600 ? 48.0 : 66.0;

//     return Scaffold(
//       backgroundColor: const Color(0xFF1E0E0E),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Player Cards
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Opponent Card (Top)
//                 PlayerCards(
//                   name: isPlayer1 ? player2Name : player1Name,
//                   score: isPlayer1 ? board[15] : board[7],
//                   isActive: isPlayer1 ? turnId == player2Id : turnId == player1Id,
//                   avatarIcon:
//                       (isPlayer1 && player2Id == 'bot_1') || !isPlayer1 ? Icons.smart_toy : Icons.person,
//                 ),
//                 // Player Card (Bottom)
//                 PlayerCards(
//                   name: isPlayer1 ? player1Name : player2Name,
//                   score: isPlayer1 ? board[7] : board[15],
//                   isActive: isPlayer1 ? turnId == player1Id : turnId == player2Id,
//                   avatarIcon: Icons.person,
//                 ),
//               ],
//             ),

//             // Board with stores and pits (Wrapped in LayoutBuilder/Stack for animation)
//             Expanded(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 900),
//                   child: LayoutBuilder( // NEW: LayoutBuilder to get board width
//                     builder: (context, constraints) {
//                       final effectiveBoardWidth = constraints.maxWidth;
//                       return Stack( // NEW: Stack for pebble animation overlay
//                         children: [
//                           Container(
//                             key: _boardKey,
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               border: Border.all(color: const Color(0xFF4B3219), width: 5),
//                               boxShadow: const [
//                                 BoxShadow(color: Colors.black45, blurRadius: 10.0, offset: Offset(0, 5)),
//                               ],
//                               image: _boardTexture,
//                             ),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 // Opponent Store (left)
//                                 StoreWidget(
//                                   count: isPlayer1 ? board[15] : board[7],
//                                   label: '${isPlayer1 ? player2Name : player1Name}\'s Store',
//                                   height: 210,
//                                   woodenTexture: _pitStoreTexture,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 // Pits grid
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       // Top row (opponent's side)
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: List.generate(7, (i) {
//                                           final index = isPlayer1 ? 14 - i : 6 - i;
//                                           return PitWidget(
//                                             count: board[index],
//                                             size: pitSize,
//                                             isTop: true,
//                                             enabled: !isPlayer1 && isMyTurn && !isMakingMove && board[index] > 0,
//                                             animating: animatingPit == index, // UPDATED
//                                             lastMove: lastMove == index, // UPDATED
//                                             onTap: () => _handlePitTap(
//                                               index,
//                                               board,
//                                               player1Id,
//                                               player2Id,
//                                               player1Rating,
//                                               player2Rating,
//                                               player1Score,
//                                               player2Score,
//                                             ),
//                                             woodenTexture: _pitStoreTexture,
//                                           );
//                                         }),
//                                       ),
//                                       // Divider
//                                       Container(
//                                         height: 1.5,
//                                         margin: const EdgeInsets.symmetric(vertical: 8),
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               Colors.transparent,
//                                               Colors.purple.withOpacity(0.45),
//                                               Colors.transparent,
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       // Bottom row (player's side)
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: List.generate(7, (i) {
//                                           final index = isPlayer1 ? i : 8 + i;
//                                           return PitWidget(
//                                             count: board[index],
//                                             size: pitSize,
//                                             isTop: false,
//                                             enabled: isPlayer1 && isMyTurn && !isMakingMove && board[index] > 0,
//                                             animating: animatingPit == index, // UPDATED
//                                             lastMove: lastMove == index, // UPDATED
//                                             onTap: () => _handlePitTap(
//                                               index,
//                                               board,
//                                               player1Id,
//                                               player2Id,
//                                               player1Rating,
//                                               player2Rating,
//                                               player1Score,
//                                               player2Score,
//                                             ),
//                                             woodenTexture: _pitStoreTexture,
//                                           );
//                                         }),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 // Player Store (right)
//                                 StoreWidget(
//                                   count: isPlayer1 ? board[7] : board[15],
//                                   label: '${isPlayer1 ? player1Name : player2Name}\'s Store',
//                                   height: 210,
//                                   woodenTexture: _pitStoreTexture,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // NEW: Pebble Animation Overlay
//                           if (animatingPebbles.isNotEmpty)
//                             Positioned.fill(
//                               child: IgnorePointer(
//                                 child: CustomPaint(
//                                   painter: AnimatedPebblesPainter(
//                                     pebbles: animatingPebbles,
//                                     getPitPosition: (pit) =>
//                                         _getPitPosition(pit, pitSize, effectiveBoardWidth),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             // Resign button
//             ElevatedButton(
//               onPressed: () => showResignDialog(
//                 player1Id,
//                 player2Id,
//                 player1Rating,
//                 player2Rating,
//                 player1Score,
//                 player2Score,
//               ),
//               child: const Text("Resign"),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // ----------------------------- Game logic handlers -----------------------------

//   // MODIFIED: Integrates the pebble animation loop
//   Future<void> _handlePitTap(
//     int pit,
//     List<int> currentBoard,
//     String player1Id,
//     String player2Id,
//     int player1Rating,
//     int player2Rating,
//     int player1Score,
//     int player2Score,
//   ) async {
//     if (isMakingMove || animatingPit != null) return;

//     final isPlayer1Turn = currentUser!.uid == player1Id;

//     // Validations
//     if ((isPlayer1Turn && (pit < 0 || pit > 6)) ||
//         (!isPlayer1Turn && (pit < 8 || pit > 14)) ||
//         currentBoard[pit] == 0) {
//       return;
//     }

//     // --- Start Animation Logic ---
//     setState(() {
//       isMakingMove = true;
//       animatingPit = pit;
//       lastMove = pit;
//     });

//     try {
//       // Pre-compute the animation sequence
//       List<int> animatingBoard = List.from(currentBoard);
//       int stones = animatingBoard[pit];
//       animatingBoard[pit] = 0;
//       int index = pit;

//       for (int i = 0; i < stones; i++) {
//         int nextIndex = (index + 1) % animatingBoard.length;

//         // Skip opponent's store (15 for player1, 7 for player2)
//         if (isPlayer1Turn && nextIndex == 15) {
//           nextIndex = (nextIndex + 1) % animatingBoard.length;
//         } else if (!isPlayer1Turn && nextIndex == 7) {
//           nextIndex = (nextIndex + 1) % animatingBoard.length;
//         }

//         // Add pebble animation data
//         if (mounted) {
//           setState(() {
//             animatingPebbles.add(AnimatingPebbleData(
//               fromPit: index,
//               toPit: nextIndex,
//               startTime: DateTime.now(),
//               duration: const Duration(milliseconds: 600),
//             ));
//           });
//         }

//         // Delay between pebble drops
//         await Future.delayed(const Duration(milliseconds: 180));

//         index = nextIndex;
//         animatingBoard[index] += 1;

//         // Update local board state for UI and remove completed animations
//         if (mounted) {
//           setState(() {
//             // Temporarily update the local state to show stones landing
//             matchData!['board'] = List<int>.from(animatingBoard);
//             animatingPit = index;
//             animatingPebbles.removeWhere((p) => p.isComplete);
//           });
//         }
//       }

//       // Delay after all stones are dropped, before applying final game logic
//       await Future.delayed(const Duration(milliseconds: 300));

//       // --- Apply Full Game Logic and Update Firestore ---

//       final resultBoard = GameLogic.makeMove(currentBoard, pit, isPlayer1Turn);
//       final result = GameLogic.checkEndGame(resultBoard);

//       // Clear animation state and set final local board state for UI consistency
//       if (mounted) {
//         setState(() {
//           matchData!['board'] = List<int>.from(resultBoard);
//           animatingPit = null;
//           animatingPebbles = [];
//         });
//       }

//       if (result['isEnded']) { // Game Over logic
//         final finalBoard = result['finalBoard'];
//         final outcome = GameLogic.getWinner(finalBoard);
//         await _handleGameOver(
//           outcome,
//           finalBoard,
//           player1Id,
//           player2Id,
//           player1Rating,
//           player2Rating,
//           player1Score,
//           player2Score,
//         );
//       } else { // Normal turn change
//         final nextTurnId = isPlayer1Turn ? player2Id : player1Id;
//         await firestoreService.updateBoardAndTurn(
//           matchId: widget.matchId,
//           newBoard: resultBoard,
//           nextTurnId: nextTurnId,
//         );
//       }
//     } catch (e) {
//       widget.showError("Error during move: $e");
//     } finally {
//       // Ensure flags reset no matter what
//       if (mounted) {
//         setState(() {
//           isMakingMove = false;
//           animatingPit = null;
//           animatingPebbles = [];
//         });
//       }
//     }
//   }


//   // MODIFIED: Calls _handlePitTap instead of direct board update
//   Future<void> _botPlay(
//     List<int> board, Map<String, dynamic> data, String difficulty) async {
//     if (!mounted) return;
//     if (botThinking) return;

//     try {
//       botThinking = true;

//       final diff = {
//         'easy': Difficulty.easy,
//         'medium': Difficulty.medium,
//         'hard': Difficulty.hard,
//       }[difficulty] ?? Difficulty.easy;

//       // ✅ let bot think a bit
//       await Future.delayed(const Duration(milliseconds: 400));

//       final pit = BotService.getBotMove(board, diff);

//       if (pit == -1) {
//         botThinking = false;
//         return;
//       }

//       // Call _handlePitTap to perform the move with animation and handle state
//       await _handlePitTap(
//         pit,
//         board,
//         data['player1Id'],
//         data['player2Id'],
//         data['player1Rating'] ?? 0,
//         data['player2Rating'] ?? 0,
//         data['player1Score'] ?? 0,
//         data['player2Score'] ?? 0,
//       );

//     } catch (e) {
//       widget.showError("Bot move failed: $e");
//     } finally {
//       // ✅ ensure flags reset no matter what
//       botThinking = false;
//     }
//   }

//   // ----------------------------- Helper Methods and Classes -----------------------------
//   // (Reconstructed from snippets for completeness)

//   Future<void> _handleGameOver(
//     String outcome,
//     List<int> board,
//     String player1Id,
//     String player2Id,
//     int player1Rating,
//     int player2Rating,
//     int player1Score,
//     int player2Score,
//   ) async {
//     String? winnerId;
//     String? loserId;
//     int newWinnerRating = player1Rating;
//     int newLoserRating = player2Rating;

//     if (outcome == 'player1') {
//       winnerId = player1Id;
//       loserId = player2Id;
//       player1Score++;
//       newWinnerRating = calculateNewRating(player1Rating, player2Rating, 1);
//       newLoserRating = calculateNewRating(player2Rating, player1Rating, 0);
//     } else if (outcome == 'player2') {
//       winnerId = player2Id;
//       loserId = player1Id;
//       player2Score++;
//       newWinnerRating = calculateNewRating(player2Rating, player1Rating, 1);
//       newLoserRating = calculateNewRating(player1Rating, player2Rating, 0);
//     } else {
//       winnerId = "draw";
//       newWinnerRating = calculateNewRating(player1Rating, player2Rating, 0.5);
//       newLoserRating = calculateNewRating(player2Rating, player1Rating, 0.5);
//       player1Score += 1;
//       player2Score += 1;
//     }

//     await firestoreService.updateMatchResult(
//       matchId: widget.matchId,
//       winnerId: winnerId,
//       loserId: loserId,
//       winnerNewRating: newWinnerRating,
//       loserNewRating: newLoserRating,
//       player1Score: player1Score,
//       player2Score: player2Score,
//       board: board,
//       isGameOver: true,
//     );

//     if (winnerId != "draw" && loserId != null) {
//       if (winnerId != 'bot_1') {
//         await firestoreService.updateUserRating(
//           winnerId,
//           newWinnerRating,
//           winner: true,
//         );
//       }
//       if (loserId != 'bot_1') {
//         await firestoreService.updateUserRating(loserId, newLoserRating);
//       }
//     } else if (winnerId == 'draw') {
//       if (player1Id != 'bot_1') {
//         await firestoreService.updateUserRating(
//           player1Id,
//           newWinnerRating,
//           winner: false,
//         );
//       }
//       if (player2Id != 'bot_1') {
//         await firestoreService.updateUserRating(
//           player2Id,
//           newLoserRating,
//           winner: false,
//         );
//       }
//     }
//   }

//   Widget _buildGameOverScreen(
//     Map<String, dynamic> data,
//     String player1Id,
//     String player2Id,
//     String player1Name,
//     String player2Name,
//     int player1Rating,
//     int player2Rating,
//     String? winner,
//   ) {
//     final player1BoardScore = data['board'][7] as int;
//     final player2BoardScore = data['board'][15] as int;
//     String title;
//     String message;
//     String? localWinnerId;

//     if (winner == 'draw') {
//       title = "TIE!";
//       message = "It's a Tie! A true battle of equals.";
//       localWinnerId = "draw";
//     } else if (winner == currentUser!.uid) {
//       title = "VICTORY!";
//       message = "Congratulations! You Won!";
//       localWinnerId = currentUser!.uid;
//     } else {
//       title = "DEFEAT!";
//       message = "You lost! Better luck next time.";
//       localWinnerId = winner;
//     }

//     return Center(
//       child: GameOverDialog(
//         title: title,
//         message: message,
//         player1Name: player1Name,
//         player1Score: player1BoardScore,
//         player2Name: player2Name,
//         player2Score: player2BoardScore,
//         winnerId: localWinnerId,
//         player1Id: player1Id,
//         player2Id: player2Id,
//         onGoHome: () => widget.navigateToScreen(
//           GameWidget(
//             game: StartMenuGame(
//               navigateToScreen: widget.navigateToScreen,
//               showError: widget.showError,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void showResignDialog(
//     player1Id,
//     player2Id,
//     player1Rating,
//     player2Rating,
//     player1Score,
//     player2Score,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Resign Game"),
//           content: const Text("Are you sure you want to resign?"),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 resign(
//                   player1Id,
//                   player2Id,
//                   player1Rating,
//                   player2Rating,
//                   player1Score,
//                   player2Score,
//                 );
//               },
//               child: const Text("Resign"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> resign(
//     String player1Id,
//     String player2Id,
//     int player1Rating,
//     int player2Rating,
//     int player1Score,
//     int player2Score,
//   ) async {
//     final loserId = currentUser!.uid;
//     final winnerId = loserId == player1Id ? player2Id : player1Id;
//     int winnerRating = winnerId == player1Id ? player1Rating : player2Rating;
//     int loserRating = loserId == player1Id ? player1Rating : player2Rating;

//     int newWinnerRating = calculateNewRating(winnerRating, loserRating, 1);
//     int newLoserRating = calculateNewRating(loserRating, winnerRating, 0);

//     if (winnerId == player1Id) {
//       player1Score++;
//     } else {
//       player2Score++;
//     }

//     await firestoreService.updateMatchResult(
//       matchId: widget.matchId,
//       winnerId: winnerId,
//       loserId: loserId,
//       winnerNewRating: newWinnerRating,
//       loserNewRating: newLoserRating,
//       player1Score: player1Score,
//       player2Score: player2Score,
//       isGameOver: true,
//     );

//     if (winnerId != 'bot_1') {
//       await firestoreService.updateUserRating(
//         winnerId,
//         newWinnerRating,
//         winner: true,
//       );
//     }
//     if (loserId != 'bot_1') {
//       await firestoreService.updateUserRating(loserId, newLoserRating);
//     }
//   }
// }

// // ----------------------------- Animation Helper Classes (COPIED from SungkaBoardScreen) -----------------------------

// /// Data model for a single animating pebble.
// class AnimatingPebbleData {
//   final int fromPit;
//   final int toPit;
//   final DateTime startTime;
//   final Duration duration;

//   AnimatingPebbleData({
//     required this.fromPit,
//     required this.toPit,
//     required this.startTime,
//     required this.duration,
//   });

//   double get progress {
//     final elapsed = DateTime.now().difference(startTime);
//     return (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
//   }

//   bool get isComplete => progress >= 1.0;
// }

// /// Custom painter to draw the animating pebbles on the board.
// class AnimatedPebblesPainter extends CustomPainter {
//   final List<AnimatingPebbleData> pebbles;
//   final Offset Function(int) getPitPosition;

//   AnimatedPebblesPainter({
//     required this.pebbles,
//     required this.getPitPosition,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final pebble in pebbles) {
//       if (pebble.isComplete) continue;

//       final fromPos = getPitPosition(pebble.fromPit);
//       final toPos = getPitPosition(pebble.toPit);
//       final progress = pebble.progress;

//       // Linear interpolation for X and Y
//       final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
//       final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

//       // Add a simple arc to the movement for a bouncing effect
//       const arcHeight = 40.0;
//       final verticalArc = sin(progress * pi) * arcHeight;

//       final paint = Paint()
//         ..shader = const RadialGradient(
//           colors: [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//           center: Alignment.topLeft,
//           radius: 0.8,
//         ).createShader(Rect.fromCircle(
//           center: Offset(currentX, currentY - verticalArc),
//           radius: 6,
//         ))
//         ..style = PaintingStyle.fill;

//       // Draw shadow
//       canvas.drawCircle(
//         Offset(currentX + 1, currentY - verticalArc + 1),
//         6,
//         Paint()
//           ..color = Colors.black.withOpacity(0.3)
//           ..style = PaintingStyle.fill,
//       );

//       // Draw pebble
//       canvas.drawCircle(
//         Offset(currentX, currentY - verticalArc),
//         6,
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
// }

// // ----------------------------- Placeholder/Minimal UI Helper Classes -----------------------------
// // (Required for the OnlineGameScreen to compile)

// class PitWidget extends StatelessWidget {
//   final int count;
//   final double size;
//   final bool isTop;
//   final bool enabled;
//   final bool animating;
//   final bool lastMove;
//   final VoidCallback onTap;
//   final DecorationImage? woodenTexture;

//   const PitWidget({
//     super.key,
//     required this.count,
//     required this.size,
//     required this.isTop,
//     required this.enabled,
//     required this.animating,
//     required this.lastMove,
//     required this.onTap,
//     this.woodenTexture,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: AnimatedScale(
//         scale: animating ? 1.08 : 1.0,
//         duration: const Duration(milliseconds: 240),
//         child: Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: woodenTexture,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF4B3219).withOpacity(0.7),
//                 blurRadius: 12,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               count.toString(),
//               style: TextStyle(
//                 color: lastMove ? const Color(0xFFC69C6D) : Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StoreWidget extends StatelessWidget {
//   final int count;
//   final String label;
//   final double height;
//   final DecorationImage? woodenTexture;

//   const StoreWidget({
//     super.key,
//     required this.count,
//     required this.label,
//     required this.height,
//     this.woodenTexture,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 58.0,
//       height: height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(29.0),
//         image: woodenTexture,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         count.toString(),
//         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// // Minimal placeholder for the ELO rating function
// int calculateNewRating(int currentRating, int opponentRating, double result) {
//   // Logic here should perform ELO rating calculation
//   return currentRating;
// }

// class GameOverDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final String player1Name;
//   final int player1Score;
//   final String player2Name;
//   final int player2Score;
//   final String? winnerId;
//   final String player1Id;
//   final String player2Id;
//   final VoidCallback onGoHome;

//   const GameOverDialog({
//     super.key,
//     required this.title,
//     required this.message,
//     required this.player1Name,
//     required this.player1Score,
//     required this.player2Name,
//     required this.player2Score,
//     required this.winnerId,
//     required this.player1Id,
//     required this.player2Id,
//     required this.onGoHome,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isWin = title == 'VICTORY!';
//     final resultColor = isWin ? const Color(0xFFFACC15) : Colors.redAccent;
//     final icon = isWin ? Icons.emoji_events : Icons.close_sharp;

//     return Center(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 400),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E0E0E).withOpacity(0.95),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: resultColor, width: 3),
//             boxShadow: [
//               BoxShadow(
//                 color: resultColor.withOpacity(0.5),
//                 blurRadius: 20,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 34, color: resultColor),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: resultColor,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w900,
//                   shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white70, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.white10),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _ScoreItem(
//                       label: player1Name,
//                       score: player1Score,
//                       isWinner: winnerId == player1Id || winnerId == 'draw',
//                     ),
//                     Container(width: 1, height: 40, color: Colors.white10),
//                     _ScoreItem(
//                       label: player2Name,
//                       score: player2Score,
//                       isWinner: winnerId == player2Id || winnerId == 'draw',
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               _DialogButton(
//                 text: 'Back to Home',
//                 color: const Color(0xFFC93030), // Dark Red
//                 onPressed: onGoHome,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ScoreItem extends StatelessWidget {
//   final String label;
//   final int score;
//   final bool isWinner;

//   const _ScoreItem({
//     required this.label,
//     required this.score,
//     required this.isWinner,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final scoreColor = isWinner ? const Color(0xFFFACC15) : Colors.white70;
//     return Column(
//       children: [
//         Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
//         const SizedBox(height: 4),
//         Text(score.toString(),
//             style: TextStyle(color: scoreColor, fontSize: 24, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }

// class _DialogButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final VoidCallback onPressed;

//   const _DialogButton({
//     required this.text,
//     required this.color,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:math';
import 'dart:ui'; // Added for CustomPaint
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sungka/core/services/bot_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
import 'package:sungka/screens/start_game_screen.dart';

// Assuming Difficulty is imported or defined externally.
// PitWidget, StoreWidget, GameOverDialog, calculateNewRating, AnimatingPebbleData, and AnimatedPebblesPainter
// are defined below to ensure the file is complete.

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

class _OnlineGameScreenState extends State<OnlineGameScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  // Cached match data from Firestore stream
  Map<String, dynamic>? matchData;
  StreamSubscription? _matchSub;

  // Local state flags
  bool isMakingMove = false;
  bool botThinking = false;

  // Animation State (NEW)
  int? animatingPit;
  int? lastMove;
  List<AnimatingPebbleData> animatingPebbles = [];

  // UI constants
  static const String _woodenTexturePath =
      'assets/images/assets/texture_test.jpg';

  final GlobalKey _boardKey = GlobalKey();
  String? _lastTurnId;

  @override
  void initState() {
    super.initState();
    _startMatchSubscription();
  }

  void _startMatchSubscription() {
    _matchSub = firestoreService.getMatch(matchId: widget.matchId).listen(
      (snapshot) {
        if (!snapshot.exists) return;
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data == null) return;

        final prevData = matchData;
        matchData = data;

        final turnId = data['turnId'];
        final player2Id = data['player2Id'];
        final difficulty = data['difficulty'] ?? 'easy';
        final board = List<int>.from(data['board']);

        // ✅ detect change of turnId
        final turnChanged = turnId != _lastTurnId;
        _lastTurnId = turnId;

        // ✅ only trigger bot when turn actually changes to bot_1
        if (player2Id == 'bot_1' && turnChanged && turnId == 'bot_1') {
          if (!botThinking) {
            // We only need to check botThinking here. isMakingMove is handled by _handlePitTap
            Future.delayed(const Duration(milliseconds: 900), () {
              if (!mounted) return;
              _botPlay(board, data, difficulty);
            });
          }
        }

        // Only call setState if data actually changed OR if we are currently animating,
        // as the animation loop might update matchData locally.
        if (mounted && (!mapEquals(prevData, matchData) || animatingPebbles.isNotEmpty)) {
          setState(() {});
        }
      },
      onError: (e) {
        widget.showError("Match stream error: $e");
      },
    );
  }

  @override
  void dispose() {
    _matchSub?.cancel();
    super.dispose();
  }

  // NEW: Geometry calculation for animation
  Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
    // These constants are estimated based on typical Sungka board layout
    const storeWidth = 58.0;
    const sidePadding = 8.0; 
    const verticalPadding = 24.0; 

    bool isTop = pitIndex > 7;
    // Map pit index (0-6 for player bottom, 8-14 for player top/opponent bottom) to column index (0-6)
    int col = isTop ? 14 - pitIndex : pitIndex;

    // Calculate grid width (total width minus stores and side margins)
    double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
    double pitSpacing = gridWidth / 7;

    // Calculate X position
    const boardContainerPadding = 12.0;

    double x = boardContainerPadding + storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);

    // Calculate Y position 
    double y = isTop
        ? (boardContainerPadding + verticalPadding + pitSize / 2)
        : (boardContainerPadding + verticalPadding * 2 + pitSize + pitSize / 2);

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    // UI textures
    const _boardTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
    );
    const _pitStoreTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
    );

    // If match data hasn't arrived yet show loader
    if (matchData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E0E0E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract the current match snapshot (cached locally)
    final data = matchData!;
    final player1Id = data['player1Id'];
    final player2Id = data['player2Id'];
    final player1Name = data['player1Name'] ?? 'Player 1';
    final player2Name = data['player2Name'] ?? 'Player 2';
    final player1Rating = data['player1Rating'] ?? 0;
    final player2Rating = data['player2Rating'] ?? 0;
    int player1Score = data['player1Score'] ?? 0;
    int player2Score = data['player2Score'] ?? 0;

    final winner = data['winner'];
    final isGameOver = data['isGameOver'] ?? false;
    final board = List<int>.from(data['board']);
    final turnId = data['turnId'];
    final isMyTurn = turnId == currentUser!.uid;
    final isPlayer1 = currentUser!.uid == player1Id;
    final difficulty = data['difficulty'] ?? 'easy';

    // Game over screen
    if (winner != null || isGameOver) {
      return _buildGameOverScreen(
        data,
        player1Id,
        player2Id,
        player1Name,
        player2Name,
        player1Rating,
        player2Rating,
        winner,
      );
    }

    // Responsive pit size
    final screenWidth = MediaQuery.of(context).size.width;
    final pitSize = screenWidth < 600 ? 48.0 : 66.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1E0E0E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Player Cards
            Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Opponent Card (Top)
                PlayerCards(
                  name: isPlayer1 ? player2Name : player1Name,
                  score: isPlayer1 ? board[15] : board[7],
                  isActive: isPlayer1 ? turnId == player2Id : turnId == player1Id,
                  avatarIcon:
                      (isPlayer1 && player2Id == 'bot_1') || !isPlayer1 ? Icons.smart_toy : Icons.person,
                ),
                // Player Card (Bottom)
                PlayerCards(
                  name: isPlayer1 ? player1Name : player2Name,
                  score: isPlayer1 ? board[7] : board[15],
                  isActive: isPlayer1 ? turnId == player1Id : turnId == player2Id,
                  avatarIcon: Icons.person,
                ),
              ],
            ),
            Gap(10),
            // Board with stores and pits (Wrapped in LayoutBuilder/Stack for animation)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: LayoutBuilder( // NEW: LayoutBuilder to get board width
                    builder: (context, constraints) {
                      final effectiveBoardWidth = constraints.maxWidth;
                      return Stack( // NEW: Stack for pebble animation overlay
                        children: [
                          Container(
                            key: _boardKey,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFF4B3219), width: 5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black45, blurRadius: 10.0, offset: Offset(0, 5)),
                              ],
                              image: _boardTexture,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Opponent Store (left)
                                StoreWidget(
                                  count: isPlayer1 ? board[15] : board[7],
                                  label: '${isPlayer1 ? player2Name : player1Name}\'s Store',
                                  height: 210,
                                  woodenTexture: _pitStoreTexture,
                                ),
                                const SizedBox(width: 8),
                                // Pits grid
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Top row (opponent's side)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(7, (i) {
                                          final index = isPlayer1 ? 14 - i : 6 - i;
                                          return PitWidget(
                                            count: board[index],
                                            size: pitSize,
                                            isTop: true,
                                            enabled: !isPlayer1 && isMyTurn && !isMakingMove && board[index] > 0,
                                            animating: animatingPit == index, // UPDATED
                                            lastMove: lastMove == index, // UPDATED
                                            onTap: () => _handlePitTap(
                                              index,
                                              board,
                                              player1Id,
                                              player2Id,
                                              player1Rating,
                                              player2Rating,
                                              player1Score,
                                              player2Score,
                                            ),
                                            woodenTexture: _pitStoreTexture,
                                          );
                                        }),
                                      ),
                                      // Divider
                                      Container(
                                        height: 1.5,
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.purple.withOpacity(0.45),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Bottom row (player's side)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(7, (i) {
                                          final index = isPlayer1 ? i : 8 + i;
                                          return PitWidget(
                                            count: board[index],
                                            size: pitSize,
                                            isTop: false,
                                            enabled: isPlayer1 && isMyTurn && !isMakingMove && board[index] > 0,
                                            animating: animatingPit == index, // UPDATED
                                            lastMove: lastMove == index, // UPDATED
                                            onTap: () => _handlePitTap(
                                              index,
                                              board,
                                              player1Id,
                                              player2Id,
                                              player1Rating,
                                              player2Rating,
                                              player1Score,
                                              player2Score,
                                            ),
                                            woodenTexture: _pitStoreTexture,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Player Store (right)
                                StoreWidget(
                                  count: isPlayer1 ? board[7] : board[15],
                                  label: '${isPlayer1 ? player1Name : player2Name}\'s Store',
                                  height: 210,
                                  woodenTexture: _pitStoreTexture,
                                ),
                              ],
                            ),
                          ),
                          // NEW: Pebble Animation Overlay
                          if (animatingPebbles.isNotEmpty)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: AnimatedPebblesPainter(
                                    pebbles: animatingPebbles,
                                    getPitPosition: (pit) =>
                                        _getPitPosition(pit, pitSize, effectiveBoardWidth),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            // Resign button
            // ElevatedButton(
            //   onPressed: () => showResignDialog(
            //     player1Id,
            //     player2Id,
            //     player1Rating,
            //     player2Rating,
            //     player1Score,
            //     player2Score,
            //   ),
            //   child: const Text("Resign"),
            // ),
  
            GestureDetector(
  onTap: () => showResignDialog(
    player1Id,
    player2Id,
    player1Rating,
    player2Rating,
    player1Score,
    player2Score,
  ),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF4B5C), Color(0xFFDB2B39)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          offset: const Offset(4, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.15),
          offset: const Offset(-4, -4),
          blurRadius: 8,
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.flag, color: Colors.white, size: 20),
        SizedBox(width: 10),
        Text(
          "Resign",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  // ----------------------------- Game logic handlers -----------------------------

  // MODIFIED: Integrates the pebble animation loop
  Future<void> _handlePitTap(
    int pit,
    List<int> currentBoard,
    String player1Id,
    String player2Id,
    int player1Rating,
    int player2Rating,
    int player1Score,
    int player2Score,
  ) async {
    // isMakingMove is now set externally for the bot to ensure it starts.
    if (isMakingMove && matchData!['turnId'] != currentUser!.uid && matchData!['turnId'] != 'bot_1') return;

    final isPlayer1Turn = matchData!['turnId'] == player1Id;
    final isBotTurn = matchData!['turnId'] == 'bot_1';

    // Validations
    if ((isPlayer1Turn && !isBotTurn && (pit < 0 || pit > 6)) ||
        (!isPlayer1Turn && !isBotTurn && (pit < 8 || pit > 14)) ||
        (isBotTurn && (pit < 8 || pit > 14)) || // Bot always plays the top side (8-14)
        currentBoard[pit] == 0) {
      return;
    }

    // Ensure isMakingMove is set for the human player
    if (matchData!['turnId'] == currentUser!.uid) {
      setState(() => isMakingMove = true);
    }
    
    // --- Start Animation Logic ---
    setState(() {
      animatingPit = pit;
      lastMove = pit;
    });

    try {
      // Pre-compute the animation sequence
      List<int> animatingBoard = List.from(currentBoard);
      int stones = animatingBoard[pit];
      animatingBoard[pit] = 0;
      int index = pit;

      for (int i = 0; i < stones; i++) {
        int nextIndex = (index + 1) % animatingBoard.length;

        // Skip opponent's store (15 for player1/human, 7 for player2/bot)
        if (!isBotTurn && isPlayer1Turn && nextIndex == 15) { // Human player 1 turn, skip store 15
          nextIndex = (nextIndex + 1) % animatingBoard.length;
        } else if ((!isPlayer1Turn || isBotTurn) && nextIndex == 7) { // Player 2 or Bot turn, skip store 7
          nextIndex = (nextIndex + 1) % animatingBoard.length;
        }

        // Add pebble animation data
        if (mounted) {
          setState(() {
            animatingPebbles.add(AnimatingPebbleData(
              fromPit: index,
              toPit: nextIndex,
              startTime: DateTime.now(),
              duration: const Duration(milliseconds: 600),
            ));
          });
        }

        // Delay between pebble drops
        await Future.delayed(const Duration(milliseconds: 180));

        index = nextIndex;
        animatingBoard[index] += 1;

        // Update local board state for UI and remove completed animations
        if (mounted) {
          setState(() {
            // Temporarily update the local state to show stones landing
            matchData!['board'] = List<int>.from(animatingBoard);
            animatingPit = index;
            animatingPebbles.removeWhere((p) => p.isComplete);
          });
        }
      }

      // Delay after all stones are dropped, before applying final game logic
      await Future.delayed(const Duration(milliseconds: 300));

      // --- Apply Full Game Logic and Update Firestore ---
      
      // Determine if the move is from P1's side (0-6) or P2's side (8-14).
      final isPlayer1SideMove = pit >= 0 && pit <= 6; 
      
      // The game logic service expects "isPlayer1Turn" to be true if the move is from P1's side (0-6).
      final isLogicPlayer1Turn = isPlayer1SideMove;


      final resultBoard = GameLogic.makeMove(currentBoard, pit, isLogicPlayer1Turn);
      final result = GameLogic.checkEndGame(resultBoard);

      // Clear animation state and set final local board state for UI consistency
      if (mounted) {
        setState(() {
          matchData!['board'] = List<int>.from(resultBoard);
          animatingPit = null;
          animatingPebbles = [];
        });
      }

      if (result['isEnded']) { // Game Over logic
        final finalBoard = result['finalBoard'];
        final outcome = GameLogic.getWinner(finalBoard);
        await _handleGameOver(
          outcome,
          finalBoard,
          player1Id,
          player2Id,
          player1Rating,
          player2Rating,
          player1Score,
          player2Score,
        );
      } else { // Normal turn change
        final nextTurnId = isBotTurn ? player1Id : player2Id; // Simple switch (Bot -> P1, P1 -> P2/Bot)
        
        await firestoreService.updateBoardAndTurn(
          matchId: widget.matchId,
          newBoard: resultBoard,
          nextTurnId: nextTurnId,
        );
      }
    } catch (e) {
      widget.showError("Error during move: $e");
    } finally {
      // Ensure flags reset no matter what
      if (mounted) {
        setState(() {
          isMakingMove = false;
          animatingPit = null;
          animatingPebbles = [];
        });
      }
    }
  }


  // CORRECTED: Set isMakingMove and locally update turnId to 'bot_1' before starting the move
  Future<void> _botPlay(
    List<int> board, Map<String, dynamic> data, String difficulty) async {
    if (!mounted) return;
    if (botThinking) return;

    try {
      botThinking = true;
      // CRITICAL FIX: Set isMakingMove and locally update turnId
      setState(() {
        isMakingMove = true;
        matchData!['turnId'] = 'bot_1'; // Ensures the animation logic runs for the bot's pits (8-14)
      });
      
      final diff = {
        'easy': Difficulty.easy,
        'medium': Difficulty.medium,
        'hard': Difficulty.hard,
      }[difficulty] ?? Difficulty.easy;

      // ✅ let bot think a bit
      await Future.delayed(const Duration(milliseconds: 400));

      final pit = BotService.getBotMove(board, diff);

      if (pit == -1) {
        // If bot cannot move, handle it as game end or skip
        await Future.delayed(const Duration(milliseconds: 500));
        await firestoreService.updateBoardAndTurn(
          matchId: widget.matchId,
          newBoard: board,
          nextTurnId: data['player1Id'], // Pass turn to human
        );
        return;
      }

      // Call _handlePitTap to perform the move with animation and handle state
      await _handlePitTap(
        pit,
        board,
        data['player1Id'],
        data['player2Id'],
        data['player1Rating'] ?? 0,
        data['player2Rating'] ?? 0,
        data['player1Score'] ?? 0,
        data['player2Score'] ?? 0,
      );

    } catch (e) {
      widget.showError("Bot move failed: $e");
    } finally {
      // ✅ ensure flags reset no matter what
      botThinking = false;
      if (mounted) {
        setState(() {
          isMakingMove = false;
        });
      }
    }
  }

  // ----------------------------- Helper Methods (FIXED: Defined in class) -----------------------------

  Future<void> _handleGameOver(
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

    if (outcome == 'player1') {
      winnerId = player1Id;
      loserId = player2Id;
      player1Score++;
      newWinnerRating = calculateNewRating(player1Rating, player2Rating, 1);
      newLoserRating = calculateNewRating(player2Rating, player1Rating, 0);
    } else if (outcome == 'player2') {
      winnerId = player2Id;
      loserId = player1Id;
      player2Score++;
      newWinnerRating = calculateNewRating(player2Rating, player1Rating, 1);
      newLoserRating = calculateNewRating(player1Rating, player2Rating, 0);
    } else {
      winnerId = "draw";
      newWinnerRating = calculateNewRating(player1Rating, player2Rating, 0.5);
      newLoserRating = calculateNewRating(player2Rating, player1Rating, 0.5);
      player1Score += 1;
      player2Score += 1;
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

    if (winnerId != "draw" && loserId != null) {
      if (winnerId != 'bot_1') {
        await firestoreService.updateUserRating(
          winnerId,
          newWinnerRating,
          winner: true,
        );
      }
      if (loserId != 'bot_1') {
        await firestoreService.updateUserRating(loserId, newLoserRating);
      }
    } else if (winnerId == 'draw') {
      if (player1Id != 'bot_1') {
        await firestoreService.updateUserRating(
          player1Id,
          newWinnerRating,
          winner: false,
        );
      }
      if (player2Id != 'bot_1') {
        await firestoreService.updateUserRating(
          player2Id,
          newLoserRating,
          winner: false,
        );
      }
    }
  }

  Widget _buildGameOverScreen(
    Map<String, dynamic> data,
    String player1Id,
    String player2Id,
    String player1Name,
    String player2Name,
    int player1Rating,
    int player2Rating,
    String? winner,
  ) {
    final player1BoardScore = data['board'][7] as int;
    final player2BoardScore = data['board'][15] as int;
    String title;
    String message;
    String? localWinnerId;

    if (winner == 'draw') {
      title = "TIE!";
      message = "It's a Tie! A true battle of equals.";
      localWinnerId = "draw";
    } else if (winner == currentUser!.uid) {
      title = "VICTORY!";
      message = "Congratulations! You Won!";
      localWinnerId = currentUser!.uid;
    } else {
      title = "DEFEAT!";
      message = "You lost! Better luck next time.";
      localWinnerId = winner;
    }

    return Center(
      child: GameOverDialog(
        title: title,
        message: message,
        player1Name: player1Name,
        player1Score: player1BoardScore,
        player2Name: player2Name,
        player2Score: player2BoardScore,
        winnerId: localWinnerId,
        player1Id: player1Id,
        player2Id: player2Id,
        onGoHome: () => widget.navigateToScreen(
          GameWidget(
            game: StartMenuGame(
              navigateToScreen: widget.navigateToScreen,
              showError: widget.showError,
            ),
          ),
        ),
      ),
    );
  }

  void showResignDialog(
    player1Id,
    player2Id,
    player1Rating,
    player2Rating,
    player1Score,
    player2Score,
  ) {
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

    if (winnerId != 'bot_1') {
      await firestoreService.updateUserRating(
        winnerId,
        newWinnerRating,
        winner: true,
      );
    }
    if (loserId != 'bot_1') {
      await firestoreService.updateUserRating(loserId, newLoserRating);
    }
  }
}

// ----------------------------- Animation Helper Classes -----------------------------

/// Data model for a single animating pebble.
class AnimatingPebbleData {
  final int fromPit;
  final int toPit;
  final DateTime startTime;
  final Duration duration;

  AnimatingPebbleData({
    required this.fromPit,
    required this.toPit,
    required this.startTime,
    required this.duration,
  });

  double get progress {
    final elapsed = DateTime.now().difference(startTime);
    return (elapsed.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  bool get isComplete => progress >= 1.0;
}

/// Custom painter to draw the animating pebbles on the board.
class AnimatedPebblesPainter extends CustomPainter {
  final List<AnimatingPebbleData> pebbles;
  final Offset Function(int) getPitPosition;

  AnimatedPebblesPainter({
    required this.pebbles,
    required this.getPitPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final pebble in pebbles) {
      if (pebble.isComplete) continue;

      final fromPos = getPitPosition(pebble.fromPit);
      final toPos = getPitPosition(pebble.toPit);
      final progress = pebble.progress;

      // Linear interpolation for X and Y
      final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
      final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

      // Add a simple arc to the movement for a bouncing effect
      const arcHeight = 40.0;
      final verticalArc = sin(progress * pi) * arcHeight;

      final paint = Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
          center: Alignment.topLeft,
          radius: 0.8,
        ).createShader(Rect.fromCircle(
          center: Offset(currentX, currentY - verticalArc),
          radius: 6,
        ))
        ..style = PaintingStyle.fill;

      // Draw shadow
      canvas.drawCircle(
        Offset(currentX + 1, currentY - verticalArc + 1),
        6,
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );

      // Draw pebble
      canvas.drawCircle(
        Offset(currentX, currentY - verticalArc),
        6,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
}

// ----------------------------- Placeholder/Minimal UI Helper Classes -----------------------------

class PitWidget extends StatefulWidget {
  final int count;
  final double size;
  final bool isTop;
  final bool enabled;
  final bool animating;
  final bool lastMove;
  final VoidCallback onTap;
  final DecorationImage? woodenTexture;

  const PitWidget({
    Key? key,
    required this.count,
    required this.size,
    required this.isTop,
    required this.enabled,
    required this.animating,
    required this.lastMove,
    required this.onTap,
    this.woodenTexture,
  }) : super(key: key);

  @override
  State<PitWidget> createState() => _PitWidgetState();
}

class _PitWidgetState extends State<PitWidget> {
  List<Widget> _pebbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pebbles = _generatePebbles(widget.count);
  }

  @override
  void didUpdateWidget(PitWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      setState(() {
        _pebbles = _generatePebbles(widget.count);
      });
    }
  }

  List<Widget> _generatePebbles(int count) {
    final List<Widget> pebbles = [];
    final maxPebbles = count.clamp(0, 10);

    for (int i = 0; i < maxPebbles; i++) {
      final dx = _random.nextDouble() * 30 + 10;
      final dy = _random.nextDouble() * 30 + 10;
      final double pebbleSize = 6.0;
      final rotation = _random.nextDouble() * pi;

      pebbles.add(
        Positioned(
          left: dx,
          top: dy,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: pebbleSize,
              height: pebbleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.9),
                gradient: const RadialGradient(
                  colors: [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
                  center: Alignment.topLeft,
                  radius: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return pebbles;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isTop) CountBadge(count: widget.count),
        GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedScale(
            scale: widget.animating ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 240),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    widget.woodenTexture == null
                        ? const Color(0xFF966F33)
                        : null,
                image: widget.woodenTexture,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4B3219).withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.8),
                  boxShadow:
                      widget.lastMove
                          ? [
                              BoxShadow(
                                color: const Color(0xFFC69C6D).withOpacity(0.8),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                ),
                child: ClipOval(child: Stack(children: _pebbles)),
              ),
            ),
          ),
        ),
        if (!widget.isTop) CountBadge(count: widget.count),
      ],
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  const CountBadge({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 4, top: 4),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10)),
      child: Text(count.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

class StoreWidget extends StatelessWidget {
  final int count;
  final String label;
  final double height;
  final DecorationImage? woodenTexture;

  const StoreWidget({
    Key? key,
    required this.count,
    required this.label,
    this.height = 150,
    this.woodenTexture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: woodenTexture == null ? const Color(0xFF966F33) : null,
            image: woodenTexture,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4B3219).withOpacity(0.5),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.black.withOpacity(0.85),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

// Minimal placeholder for the ELO rating function
int calculateNewRating(int currentRating, int opponentRating, double result) {
  // Logic here should perform ELO rating calculation
  return currentRating;
}

class GameOverDialog extends StatelessWidget {
  final String title;
  final String message;
  final String player1Name;
  final int player1Score;
  final String player2Name;
  final int player2Score;
  final String? winnerId;
  final String player1Id;
  final String player2Id;
  final VoidCallback onGoHome;

  const GameOverDialog({
    super.key,
    required this.title,
    required this.message,
    required this.player1Name,
    required this.player1Score,
    required this.player2Name,
    required this.player2Score,
    required this.winnerId,
    required this.player1Id,
    required this.player2Id,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final isWin = title == 'VICTORY!';
    final resultColor = isWin ? const Color(0xFFFACC15) : Colors.redAccent;
    final icon = isWin ? Icons.emoji_events : Icons.close_sharp;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E0E0E).withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: resultColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: resultColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: resultColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: resultColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16, decoration: TextDecoration.none,),   
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ScoreItem(
                      label: player1Name,
                      score: player1Score,
                      isWinner: winnerId == player1Id || winnerId == 'draw',
                    ),
                    Container(width: 1, height: 40, color: Colors.white10),
                    _ScoreItem(
                      label: player2Name,
                      score: player2Score,
                      isWinner: winnerId == player2Id || winnerId == 'draw',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _DialogButton(
                text: 'Back to Home',
                color: const Color(0xFFC93030), // Dark Red
                onPressed: onGoHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final int score;
  final bool isWinner;

  const _ScoreItem({
    required this.label,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = isWinner ? const Color(0xFFFACC15) : Colors.white70;
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12, decoration: TextDecoration.none,)),
        const SizedBox(height: 4),
        Text(score.toString(),
            style: TextStyle(color: scoreColor, fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.none,)),
      ],
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}