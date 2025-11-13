// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sungka/core/services/game_logic_service.dart';
// import 'package:sungka/core/services/play_friends_game_logic.dart';
// import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';

// const String _woodenTexturePath = 'assets/images/assets/texture_test.jpg';

// class SungkaGame extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   SungkaGame({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<SungkaGame> createState() => _SungkaGameState();
// }

// class _SungkaGameState extends State<SungkaGame> with TickerProviderStateMixin {
//   late List<int> board;
//   bool isPlayerOneTurn = true;
//   bool gameEnded = false;
//   int? animatingPit;
//   int? lastMove;
//   // Removed Timer? _botTimer;
//   String winner = '';
//   List<AnimatingPebbleData> animatingPebbles = [];
//   late AnimationController _masterController;





//   @override
//   void initState() {
//     super.initState();
//     _resetBoard();
//     _masterController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _masterController.dispose();
//     super.dispose();
//   }

//   void _resetBoard() {
//     board = [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0];
//     isPlayerOneTurn = true;
//     gameEnded = false;
//     winner = '';
//     animatingPit = null;
//     lastMove = null;
//     animatingPebbles = [];
//     setState(() {});
//   }

//   void _handlePitTap(int pit) async {
//     if (gameEnded) return;

//     final isPitOfPlayerOne = pit >= 0 && pit <= 6;
//     final isPitOfPlayerTwo = pit >= 8 && pit <= 14;

//     if (isPlayerOneTurn && (!isPitOfPlayerOne || board[pit] == 0)) return;
//     if (!isPlayerOneTurn && (!isPitOfPlayerTwo || board[pit] == 0)) return;

//     setState(() {
//       animatingPit = pit;
//       lastMove = pit;
//     });

//     List<int> newBoard = List.from(board);
//     int stones = newBoard[pit];
//     newBoard[pit] = 0;
//     int index = pit;

//     for (int i = 0; i < stones; i++) {
//       int nextIndex = (index + 1) % newBoard.length;

//       if (isPlayerOneTurn && nextIndex == 15) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       } else if (!isPlayerOneTurn && nextIndex == 7) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       }

//       nextIndex %= newBoard.length;

//       setState(() {
//         animatingPebbles.add(
//           AnimatingPebbleData(
//             fromPit: index,
//             toPit: nextIndex,
//             startTime: DateTime.now(),
//             duration: const Duration(milliseconds: 600),
//           ),
//         );
//       });

//       await Future.delayed(const Duration(milliseconds: 180));

//       index = nextIndex;
//       newBoard[index] += 1;

//       setState(() {
//         board = List.from(newBoard);
//         animatingPit = index;

//         animatingPebbles.removeWhere((p) => p.isComplete);
//       });
//     }

//     await Future.delayed(const Duration(milliseconds: 300));

//     final moveResult = PlayFriendsGameLogic.makeMove(
//       board,
//       pit,
//       isPlayerOneTurn,
//     );
//     final resultBoard = moveResult['board'] as List<int>;
//     final hasExtraTurn = moveResult['hasExtraTurn'] as bool;

//     setState(() {
//       board = List<int>.from(resultBoard);
//       animatingPit = null;
//       animatingPebbles = [];
//     });

//     // Check for end game state
//     final result = GameLogic.checkEndGame(resultBoard);
//     if (result['isEnded'] as bool) {
//       setState(() {
//         board = List<int>.from(result['finalBoard'] as List<int>);
//         gameEnded = true;
//         winner = GameLogic.getWinner(board);
//       });
//     } else {
//       setState(() {
//         if (!hasExtraTurn) {
//           isPlayerOneTurn = !isPlayerOneTurn;
//         }
//       });
//     }
//   }

//   Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
//     const storeWidth = 58.0;
//     const sidePadding = 8.0;
//     const verticalPadding = 24.0;

//     bool isTop = pitIndex >= 8 && pitIndex <= 14;
//     bool isStore = pitIndex == 7 || pitIndex == 15;

//     int col = 0;
//     if (isTop) {
//       col = 14 - pitIndex;
//     } else if (!isStore) {
//       col = pitIndex;
//     }

//     double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
//     double pitSpacing = gridWidth / 7;

//     double x;
//     double y;

//     if (pitIndex == 7) {
//       x = boardWidth - storeWidth / 2 - sidePadding;
//       y = verticalPadding + (210 / 2);
//     } else if (pitIndex == 15) {
//       x = storeWidth / 2 + sidePadding;
//       y = verticalPadding + (210 / 2);
//     } else {
//       x = storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);
//       y =
//           isTop
//               ? (verticalPadding + pitSize / 2)
//               : (verticalPadding * 2 + pitSize + pitSize / 2);
//     }

//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pitSize = screenWidth < 600 ? 48.0 : 66.0;
//     final boardWidth = screenWidth > 900 ? 900.0 : screenWidth;

//     const _boardTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//     );

//     const _pitStoreTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//       colorFilter: ColorFilter.mode(
//         Colors.black38, // Subtle dark overlay for depth
//         BlendMode.darken,
//       ),
//     );

//     String playerOneName = 'Player 1';
//     String playerTwoName = 'Player 2';

//     String currentTurnText =
//         isPlayerOneTurn ? "$playerOneName's Turn" : "$playerTwoName's Turn";
//     String winnerText;

//     if (winner == 'player1') {
//       winnerText = '$playerOneName Wins!';
//     } else if (winner == 'player2') {
//       winnerText = '$playerTwoName Wins!';
//     } else {
//       winnerText = "It's a Tie!";
//     }

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0A0A1A),
//                   Color(0xFF1C0435),
//                   Color(0xFF2B0018),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 900),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (!gameEnded)
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               PlayerCards(
//                                 name: playerOneName,
//                                 score: board[7],
//                                 isActive: isPlayerOneTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                                 Text(
//                             currentTurnText,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 21,
//                               fontWeight: FontWeight.bold
//                             ),
//                           ),
                          
//                               PlayerCards(
//                                 name: playerTwoName,
//                                 score: board[15],
//                                 isActive: !isPlayerOneTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     else
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               PlayerCards(
//                                 name: playerOneName,
//                                 score: board[7],
//                                 isActive: winner == 'player1',
//                                 avatarIcon: Icons.person,
//                               ),
//                               Text(
//                             winnerText,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                             ),
//                           ),
                            
//                               PlayerCards(
//                                 name: playerTwoName,
//                                 score: board[15],
//                                 isActive: winner == 'player2',
//                                 avatarIcon: Icons.person,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: _resetBoard,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF7C3AED),
//                             ),
//                             child: const Text('Play Again'),
//                           ),
//                         ],
//                       ),
//                     const SizedBox(height: 12),
//                     Stack(
//                       children: [
//                          Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             border: Border.all(
//                               color: const Color(0xFF4B3219),
//                               width: 5,
//                             ),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black45,
//                                 blurRadius: 10.0,
//                                 offset: Offset(0, 5),
//                               ),
//                             ],
//                             // *** APPLY MAIN TEXTURE HERE ***
//                             image: _boardTexture,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               StoreWidget(
//                                 count: board[15],
//                                 label: '$playerTwoName Store',
//                                 height: 210,
//                                 isPlayerTwoStore: true, // New prop for correct StoreWidget image
//                                 woodenTexture: _pitStoreTexture,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = 14 - i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: true,
//                                           enabled:
//                                               !isPlayerOneTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           woodenTexture: _pitStoreTexture,
//                                           onTap: () => _handlePitTap(index),
//                                         );
//                                       }),
//                                     ),
//                                     Container(
//                                       height: 3.0,
//                                       margin: const EdgeInsets.symmetric(
//                                         vertical: 8,
//                                       ),
//                                       decoration: const BoxDecoration(
//                                         color: Color(
//                                           0xFF4B3219,
//                                         ), // Darker separator to blend with wood
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: false,
//                                           enabled:
//                                               isPlayerOneTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           onTap: () => _handlePitTap(index),
//                                           woodenTexture: _pitStoreTexture,
//                                         );
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               StoreWidget(
//                                 count: board[7],
//                                 label: '$playerOneName Store',
//                                 height: 210,
//                                 isPlayerTwoStore: false,
//                                 woodenTexture: _pitStoreTexture,
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (animatingPebbles.isNotEmpty)
//                           Positioned.fill(
//                             child: IgnorePointer(
//                               child: CustomPaint(
//                                 painter: AnimatedPebblesPainter(
//                                   pebbles: animatingPebbles,
//                                   getPitPosition:
//                                       (pit) => _getPitPosition(
//                                           pit,
//                                           pitSize,
//                                           boardWidth - 24,
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),

//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //     Navigator.of(context).pushReplacement(
//                     //       MaterialPageRoute(
//                     //         builder:
//                     //             (context) => GameWidget(
//                     //                 game: HomeGame(
//                     //                   navigateToScreen: widget.navigateToScreen,
//                     //                   showError: widget.showError,
//                     //                 ),
//                     //               ),
//                     //       ),
//                     //     );
//                     //   },
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.black54,
//                     //   ),
//                     //   child: const Text('Back'),
//                     // ),
//                         IconButton(
//                           icon: const Icon(Icons.home, color: Colors.white),
//                           iconSize: 30,
//                           onPressed: () => Navigator.of(context).pop(),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             padding: const EdgeInsets.all(12),
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

// class AnimatedPebblesPainter extends CustomPainter {
//   final List<AnimatingPebbleData> pebbles;
//   final Offset Function(int) getPitPosition;

//   AnimatedPebblesPainter({required this.pebbles, required this.getPitPosition});

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final pebble in pebbles) {
//       if (pebble.isComplete) continue;

//       final fromPos = getPitPosition(pebble.fromPit);
//       final toPos = getPitPosition(pebble.toPit);
//       final progress = pebble.progress;

//       final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
//       final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

//       final arcHeight = 40.0;
//       final verticalArc = sin(progress * pi) * arcHeight;

//       final paint =
//           Paint()
//             ..shader = RadialGradient(
//               colors: const [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//               center: Alignment.topLeft,
//               radius: 0.8,
//             ).createShader(
//               Rect.fromCircle(
//                 center: Offset(currentX, currentY - verticalArc),
//                 radius: 6,
//               ),
//             )
//             ..style = PaintingStyle.fill;

//       canvas.drawCircle(
//         Offset(currentX + 1, currentY - verticalArc + 1),
//         6,
//         Paint()
//           ..color = Colors.black.withOpacity(0.3)
//           ..style = PaintingStyle.fill,
//       );

//       canvas.drawCircle(Offset(currentX, currentY - verticalArc), 6, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
// }

// class PitWidget extends StatefulWidget {
//   final int count;
//   final double size;
//   final bool isTop;
//   final bool enabled;
//   final bool animating;
//   final bool lastMove;
//   final VoidCallback onTap;
//   final DecorationImage? woodenTexture;

//   const PitWidget({
//     Key? key,
//     required this.count,
//     required this.size,
//     required this.isTop,
//     required this.enabled,
//     required this.animating,
//     required this.lastMove,
//     required this.onTap,
//     this.woodenTexture,
//   }) : super(key: key);

//   @override
//   State<PitWidget> createState() => _PitWidgetState();
// }

// class _PitWidgetState extends State<PitWidget> {
//   List<Widget> _pebbles = [];
//   final Random _random = Random();

//   @override
//   void initState() {
//     super.initState();
//     _pebbles = _generatePebbles(widget.count);
//   }

//   @override
//   void didUpdateWidget(PitWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.count != oldWidget.count) {
//       setState(() {
//         _pebbles = _generatePebbles(widget.count);
//       });
//     }
//   }

//   List<Widget> _generatePebbles(int count) {
//     final List<Widget> pebbles = [];
//     // Cap the number of visually displayed pebbles for performance
//     final maxPebbles = count.clamp(0, 10);

//     for (int i = 0; i < maxPebbles; i++) {
//       final dx = _random.nextDouble() * 30 + 10;
//       final dy = _random.nextDouble() * 30 + 10;
//       final double pebbleSize = 6.0;
//       final rotation = _random.nextDouble() * pi;

//       pebbles.add(
//         Positioned(
//           left: dx,
//           top: dy,
//           child: Transform.rotate(
//             angle: rotation,
//             child: Container(
//               width: pebbleSize,
//               height: pebbleSize,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.9),
//                 gradient: const RadialGradient(
//                   colors: [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//                   center: Alignment.topLeft,
//                   radius: 0.8,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 2,
//                     offset: const Offset(0.5, 0.5),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return pebbles;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (widget.isTop) CountBadge(count: widget.count),
//         GestureDetector(
//           onTap: widget.enabled ? widget.onTap : null,
//           child: AnimatedScale(
//             scale: widget.animating ? 1.08 : 1.0,
//             duration: const Duration(milliseconds: 240),
//             child: Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 // The outer pit ring/lip uses the solid color or the texture
//                 color:
//                     widget.woodenTexture == null
//                         ? const Color(0xFF966F33)
//                         : null,
//                 image: widget.woodenTexture,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF4B3219).withOpacity(0.7),
//                     blurRadius: 12,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Container(
//                 margin: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   // The pit interior is a deep black/dark color for depth contrast
//                   color: Colors.black.withOpacity(0.8),
//                   boxShadow:
//                       widget.lastMove
//                           ? [
//                             BoxShadow(
//                               color: const Color(0xFFC69C6D).withOpacity(0.8),
//                               blurRadius: 8,
//                             ),
//                           ]
//                           : null,
//                 ),
//                 child: ClipOval(child: Stack(children: _pebbles)),
//               ),
//             ),
//           ),
//         ),
//         if (!widget.isTop) CountBadge(count: widget.count),
//       ],
//     );
//   }
// }

// class StoreWidget extends StatelessWidget {
//  final int count;
//  final String label;
//  final double height;
//  final DecorationImage? woodenTexture;
//  // Retained this for potential future use or if it was removed in the previous context
//  final bool isPlayerTwoStore; 

//  const StoreWidget({
//   Key? key,
//   required this.count,
//   required this.label,
//   this.height = 260,
//   this.woodenTexture,
//   // Added this back to make the class complete based on the previous context
//   required this.isPlayerTwoStore, 
//  }) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//   // Determine the color for the subtle inner border if needed (reusing the logic from before)
//   final Color playerColor = isPlayerTwoStore 
//    ? const Color(0xFF8B5CF6) // Player Two's color
//    : const Color(0xFFFF4D67); // Player One's color

//   return Column(
//    children: [
//     Container(
//      width: 58,
//      height: height,
//      decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(22),
//       // --- MODIFICATION: Use the passed woodenTexture ---
//       color: woodenTexture == null 
//        ? const Color(0xFF966F33) // Fallback color if no texture is provided
//        : null,
//       image: woodenTexture, // Apply the wooden texture here
//       // --------------------------------------------------
//       boxShadow: [
//        BoxShadow(
//         color: const Color(0xFF4B3219).withOpacity(0.5),
//         blurRadius: 16,
//        ),
//       ],
//      ),
//      child: Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: Container(
//        decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         // Inner count display is deep black for contrast
//         color: Colors.black.withOpacity(0.85),
//         // Adding a border to maintain player color identity
//         border: Border.all(
//          color: playerColor.withOpacity(0.6),
//          width: 1.5
//         )
//        ),
//        child: Center(
//         child: Text(
//          count.toString(),
//          style: const TextStyle(fontSize: 22, color: Colors.white),
//         ),
//        ),
//       ),
//      ),
//     ),
//     const SizedBox(height: 6),
//     Text(
//      label,
//      style: const TextStyle(color: Colors.white70, fontSize: 11),
//     ),
//    ],
//   );
//  }
// }

// class CountBadge extends StatelessWidget {
//   final int count;
//   const CountBadge({Key? key, required this.count}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       margin: const EdgeInsets.only(bottom: 4, top: 4),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.75),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Text(
//         count.toString(),
//         style: const TextStyle(color: Colors.white, fontSize: 11),
//       ),
//     );
//   }
// }




// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // Assuming these imports lead to external logic you have
// import 'package:sungka/core/services/game_logic_service.dart';
// import 'package:sungka/core/services/play_friends_game_logic.dart';
// import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';

// const String _woodenTexturePath = 'assets/images/assets/texture_test.jpg';

// class SungkaGame extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   SungkaGame({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<SungkaGame> createState() => _SungkaGameState();
// }

// class _SungkaGameState extends State<SungkaGame> with TickerProviderStateMixin {
//   late List<int> board;
//   bool isPlayerOneTurn = true;
//   bool gameEnded = false;
//   int? animatingPit;
//   int? lastMove;
//   String winner = '';
//   List<AnimatingPebbleData> animatingPebbles = [];
//   late AnimationController _masterController;

//   @override
//   void initState() {
//     super.initState();
//     _resetBoard();
//     _masterController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _masterController.dispose();
//     super.dispose();
//   }

//   void _resetBoard() {
//     // Fixed initial board to 7 stones each, and 0 in stores (standard Sungka start)
//     board = [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0]; 
//     isPlayerOneTurn = true;
//     gameEnded = false;
//     winner = '';
//     animatingPit = null;
//     lastMove = null;
//     animatingPebbles = [];
//     setState(() {});
//   }

//   void _showGameOverDialog() {
//     String playerOneName = 'Player 1';
//     String playerTwoName = 'Player 2';
//     String finalWinner = GameLogic.getWinner(board);
//     String winnerText;

//     if (finalWinner == 'player1') {
//       winnerText = '$playerOneName Wins!';
//     } else if (finalWinner == 'player2') {
//       winnerText = '$playerTwoName Wins!';
//     } else {
//       winnerText = "It's a Tie!";
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return  GameOverDialog(
//           title: title,
//           message: message,
//           playerScore: board[7],
//           botScore: board[15],
//           onPlayAgain: () {
//             // 1. Dismiss the dialog
//             Navigator.of(context).pop(); 
//             // 2. Reset the game board
//             _resetBoard(); 
//           },
//           onGoHome: () {
//             // 1. Dismiss the dialog
//             Navigator.of(context).pop(); 
//             // 2. Navigate away from the game screen (pop twice: dialog, then game screen)
//             Navigator.of(context).pop(); 
//           },
//         );
//       },
//     );
//   }

//   void _handlePitTap(int pit) async {
//     if (gameEnded) return;

//     final isPitOfPlayerOne = pit >= 0 && pit <= 6;
//     final isPitOfPlayerTwo = pit >= 8 && pit <= 14;

//     if (isPlayerOneTurn && (!isPitOfPlayerOne || board[pit] == 0)) return;
//     if (!isPlayerOneTurn && (!isPitOfPlayerTwo || board[pit] == 0)) return;

//     setState(() {
//       animatingPit = pit;
//       lastMove = pit;
//     });

//     List<int> newBoard = List.from(board);
//     int stones = newBoard[pit];
//     newBoard[pit] = 0;
//     int index = pit;

//     for (int i = 0; i < stones; i++) {
//       int nextIndex = (index + 1) % newBoard.length;

//       // Skip opponent's store pit: Player 1 skips pit 15 (P2's store)
//       if (isPlayerOneTurn && nextIndex == 15) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       } 
//       // Skip opponent's store pit: Player 2 skips pit 7 (P1's store)
//       else if (!isPlayerOneTurn && nextIndex == 7) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       }

//       nextIndex %= newBoard.length;

//       setState(() {
//         animatingPebbles.add(
//           AnimatingPebbleData(
//             fromPit: index,
//             toPit: nextIndex,
//             startTime: DateTime.now(),
//             duration: const Duration(milliseconds: 600),
//           ),
//         );
//       });

//       await Future.delayed(const Duration(milliseconds: 180));

//       index = nextIndex;
//       newBoard[index] += 1;

//       setState(() {
//         board = List.from(newBoard);
//         animatingPit = index;

//         animatingPebbles.removeWhere((p) => p.isComplete);
//       });
//     }

//     await Future.delayed(const Duration(milliseconds: 300));

//     // Call external logic for captures and final move result
//     final moveResult = PlayFriendsGameLogic.makeMove(
//       board,
//       pit,
//       isPlayerOneTurn,
//     );
//     final resultBoard = moveResult['board'] as List<int>;
//     final hasExtraTurn = moveResult['hasExtraTurn'] as bool;
    
//     // The previous sowing loop only updated the board for animation.
//     // Now, we apply the *final* game rule result (captures, etc.)
//     // that should be calculated inside PlayFriendsGameLogic.makeMove.
//     setState(() {
//       board = List<int>.from(resultBoard);
//       animatingPit = null;
//       animatingPebbles = [];
//     });

//     // Check for end game state
//     final result = GameLogic.checkEndGame(resultBoard);
//     if (result['isEnded'] as bool) {
//       setState(() {
//         // Apply the final board state (with remaining stones moved to stores)
//         board = List<int>.from(result['finalBoard'] as List<int>);
//         gameEnded = true;
//         // The winner check is now based on the corrected GameLogic.getWinner
//         winner = GameLogic.getWinner(board); 
//       });
//       // Show dialog immediately after setting gameEnded state
//       _showGameOverDialog(); 

//     } else {
//       setState(() {
//         if (!hasExtraTurn) {
//           isPlayerOneTurn = !isPlayerOneTurn;
//         }
//       });
//     }
//   }

//   Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
//     const storeWidth = 58.0;
//     const sidePadding = 8.0;
//     const verticalPadding = 24.0;

//     bool isTop = pitIndex >= 8 && pitIndex <= 14;
//     bool isStore = pitIndex == 7 || pitIndex == 15;

//     int col = 0;
//     if (isTop) {
//       col = 14 - pitIndex;
//     } else if (!isStore) {
//       col = pitIndex;
//     }

//     double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
//     double pitSpacing = gridWidth / 7;

//     double x;
//     double y;

//     if (pitIndex == 7) { // Player 1 Store (Right)
//       x = boardWidth - storeWidth / 2 - sidePadding;
//       y = verticalPadding + (210 / 2);
//     } else if (pitIndex == 15) { // Player 2 Store (Left)
//       x = storeWidth / 2 + sidePadding;
//       y = verticalPadding + (210 / 2);
//     } else {
//       x = storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);
//       y =
//           isTop
//               ? (verticalPadding + pitSize / 2)
//               : (verticalPadding * 2 + pitSize + pitSize / 2);
//     }

//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pitSize = screenWidth < 600 ? 48.0 : 66.0;
//     final boardWidth = screenWidth > 900 ? 900.0 : screenWidth;

//     const _boardTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//     );

//     const _pitStoreTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//       colorFilter: ColorFilter.mode(
//         Colors.black38,
//         BlendMode.darken,
//       ),
//     );

//     String playerOneName = 'Player 1';
//     String playerTwoName = 'Player 2';

//     String currentTurnText =
//         isPlayerOneTurn ? "$playerOneName's Turn" : "$playerTwoName's Turn";
    
//     // The winnerText logic is only used for the UI below the board *if* not showing the dialog
//     String winnerText;
//     if (winner == 'player1') {
//       winnerText = '$playerOneName Wins!';
//     } else if (winner == 'player2') {
//       winnerText = '$playerTwoName Wins!';
//     } else {
//       winnerText = "It's a Tie!";
//     }

//     if (gameEnded && winner.isNotEmpty) {

//     }


//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0A0A1A),
//                   Color(0xFF1C0435),
//                   Color(0xFF2B0018),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 900),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (!gameEnded)
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               PlayerCards(
//                                 name: playerOneName,
//                                 score: board[7],
//                                 isActive: isPlayerOneTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                               Text(
//                                 currentTurnText,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold
//                                 ),
//                               ),
//                               PlayerCards(
//                                 name: playerTwoName,
//                                 score: board[15],
//                                 isActive: !isPlayerOneTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     else
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               PlayerCards(
//                                 name: playerOneName,
//                                 score: board[7],
//                                 isActive: winner == 'player1',
//                                 avatarIcon: Icons.person,
//                               ),
//                               Text(
//                                 winnerText,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                 ),
//                               ),
//                               PlayerCards(
//                                 name: playerTwoName,
//                                 score: board[15],
//                                 isActive: winner == 'player2',
//                                 avatarIcon: Icons.person,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           // The 'Play Again' button is now gone, we show the dialog instead.
//                         ],
//                       ),
//                     const SizedBox(height: 12),
//                     Stack(
//                       children: [
//                           Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             border: Border.all(
//                               color: const Color(0xFF4B3219),
//                               width: 5,
//                             ),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black45,
//                                 blurRadius: 10.0,
//                                 offset: Offset(0, 5),
//                               ),
//                             ],
//                             image: _boardTexture,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               StoreWidget(
//                                 count: board[15],
//                                 label: '$playerTwoName Store',
//                                 height: 210,
//                                 isPlayerTwoStore: true,
//                                 woodenTexture: _pitStoreTexture,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = 14 - i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: true,
//                                           enabled:
//                                               !isPlayerOneTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           woodenTexture: _pitStoreTexture,
//                                           onTap: () => _handlePitTap(index),
//                                         );
//                                       }),
//                                     ),
//                                     Container(
//                                       height: 3.0,
//                                       margin: const EdgeInsets.symmetric(
//                                         vertical: 8,
//                                       ),
//                                       decoration: const BoxDecoration(
//                                         color: Color(
//                                           0xFF4B3219,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: false,
//                                           enabled:
//                                               isPlayerOneTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           onTap: () => _handlePitTap(index),
//                                           woodenTexture: _pitStoreTexture,
//                                         );
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               StoreWidget(
//                                 count: board[7],
//                                 label: '$playerOneName Store',
//                                 height: 210,
//                                 isPlayerTwoStore: false,
//                                 woodenTexture: _pitStoreTexture,
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (animatingPebbles.isNotEmpty)
//                           Positioned.fill(
//                             child: IgnorePointer(
//                               child: CustomPaint(
//                                 painter: AnimatedPebblesPainter(
//                                   pebbles: animatingPebbles,
//                                   getPitPosition:
//                                       (pit) => _getPitPosition(
//                                           pit,
//                                           pitSize,
//                                           boardWidth - 24,
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     IconButton(
//                       icon: const Icon(Icons.home, color: Colors.white),
//                       iconSize: 30,
//                       onPressed: () => Navigator.of(context).pop(),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: const EdgeInsets.all(12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- NEW/MODIFIED WIDGETS ---

// // class GameOverDialog extends StatelessWidget {
// //   final String winnerText;
// //   final int playerOneScore;
// //   final int playerTwoScore;
// //   final VoidCallback onPlayAgain;
// //   final VoidCallback onGoHome;

// //   const GameOverDialog({
// //     super.key,
// //     required this.winnerText,
// //     required this.playerOneScore,
// //     required this.playerTwoScore,
// //     required this.onPlayAgain,
// //     required this.onGoHome,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       backgroundColor: const Color(0xFF1C0435).withOpacity(0.9),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       title: Center(
// //         child: Text(
// //           'Game Over!',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //             fontSize: 24,
// //           ),
// //         ),
// //       ),
// //       content: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: <Widget>[
// //           Text(
// //             winnerText,
// //             style: TextStyle(
// //               color: winnerText.contains('Tie') ? Colors.yellow : Colors.greenAccent,
// //               fontSize: 20,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Text(
// //             'Player 1 Score: $playerOneScore',
// //             style: const TextStyle(color: Colors.white70),
// //           ),
// //           Text(
// //             'Player 2 Score: $playerTwoScore',
// //             style: const TextStyle(color: Colors.white70),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: onPlayAgain,
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF7C3AED),
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //             ),
// //             child: const Text('Play Again', style: TextStyle(color: Colors.white)),
// //           ),
// //           const SizedBox(height: 10),
// //           TextButton(
// //             onPressed: onGoHome,
// //             child: const Text(
// //               'Go Home',
// //               style: TextStyle(color: Colors.white54),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// class GameOverDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final int playerScore;
//   final int botScore;
//   final VoidCallback onPlayAgain;
//   final VoidCallback onGoHome;

//   const GameOverDialog({
//     Key? key,
//     required this.title,
//     required this.message,
//     required this.playerScore,
//     required this.botScore,
//     required this.onPlayAgain,
//     required this.onGoHome,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isWin = title == 'VICTORY!';
//     final resultColor = isWin ? const Color(0xFFFACC15) : Colors.redAccent;
//     final icon = isWin ? Icons.emoji_events : Icons.close_sharp;

//     return Center(
//       // Ensure the dialog content is scrollable if needed
//       child: SingleChildScrollView( 
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 400),
//           child: Dialog(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E0E0E).withOpacity(0.95),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: resultColor, width: 3),
//                 boxShadow: [
//                   BoxShadow(
//                     color: resultColor.withOpacity(0.5),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(icon, size: 34, color: resultColor),
//                   const SizedBox(height: 10),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: resultColor,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w900,
//                       shadows: const [
//                         Shadow(color: Colors.black, blurRadius: 2)
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 15),

//                   // --- Message ---
//                   Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),

//                   // --- Scoreboard ---
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.white10),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _ScoreItem(label: 'Your Score', score: playerScore, isWinner: isWin), 
//                         Container(width: 1, height: 40, color: Colors.white10),
//                         _ScoreItem(label: 'Bot Score', score: botScore, isWinner: !isWin),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // --- Buttons ---
//                   Column(
//                     children: [
//                       // Play Again Button
//                       _DialogButton(
//                         text: 'Play Again',
//                         color: const Color(0xFF6B8E23), // Olive Green
//                         onPressed: onPlayAgain,
//                       ),
//                       const SizedBox(height: 10),
//                       // Go Home Button
//                       _DialogButton(
//                         text: 'Back to Home',
//                         color: const Color(0xFFC93030), // Dark Red
//                         onPressed: onGoHome,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
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
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white54, fontSize: 12),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           score.toString(),
//           style: TextStyle(
//             color: scoreColor,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
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
//         child: Text(
//           text,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// // --- ORIGINAL WIDGETS (Unmodified, but included for completeness) ---

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

// class AnimatedPebblesPainter extends CustomPainter {
//   final List<AnimatingPebbleData> pebbles;
//   final Offset Function(int) getPitPosition;

//   AnimatedPebblesPainter({required this.pebbles, required this.getPitPosition});

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final pebble in pebbles) {
//       if (pebble.isComplete) continue;

//       final fromPos = getPitPosition(pebble.fromPit);
//       final toPos = getPitPosition(pebble.toPit);
//       final progress = pebble.progress;

//       final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
//       final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

//       final arcHeight = 40.0;
//       final verticalArc = sin(progress * pi) * arcHeight;

//       final paint =
//           Paint()
//             ..shader = RadialGradient(
//               colors: const [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//               center: Alignment.topLeft,
//               radius: 0.8,
//             ).createShader(
//               Rect.fromCircle(
//                 center: Offset(currentX, currentY - verticalArc),
//                 radius: 6,
//               ),
//             )
//             ..style = PaintingStyle.fill;

//       canvas.drawCircle(
//         Offset(currentX + 1, currentY - verticalArc + 1),
//         6,
//         Paint()
//           ..color = Colors.black.withOpacity(0.3)
//           ..style = PaintingStyle.fill,
//       );

//       canvas.drawCircle(Offset(currentX, currentY - verticalArc), 6, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
// }

// class PitWidget extends StatefulWidget {
//   final int count;
//   final double size;
//   final bool isTop;
//   final bool enabled;
//   final bool animating;
//   final bool lastMove;
//   final VoidCallback onTap;
//   final DecorationImage? woodenTexture;

//   const PitWidget({
//     Key? key,
//     required this.count,
//     required this.size,
//     required this.isTop,
//     required this.enabled,
//     required this.animating,
//     required this.lastMove,
//     required this.onTap,
//     this.woodenTexture,
//   }) : super(key: key);

//   @override
//   State<PitWidget> createState() => _PitWidgetState();
// }

// class _PitWidgetState extends State<PitWidget> {
//   List<Widget> _pebbles = [];
//   final Random _random = Random();

//   @override
//   void initState() {
//     super.initState();
//     _pebbles = _generatePebbles(widget.count);
//   }

//   @override
//   void didUpdateWidget(PitWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.count != oldWidget.count) {
//       setState(() {
//         _pebbles = _generatePebbles(widget.count);
//       });
//     }
//   }

//   List<Widget> _generatePebbles(int count) {
//     final List<Widget> pebbles = [];
//     final maxPebbles = count.clamp(0, 10);

//     for (int i = 0; i < maxPebbles; i++) {
//       final dx = _random.nextDouble() * (widget.size * 0.5) + (widget.size * 0.1);
//       final dy = _random.nextDouble() * (widget.size * 0.5) + (widget.size * 0.1);
//       final double pebbleSize = 6.0;
//       final rotation = _random.nextDouble() * pi;

//       pebbles.add(
//         Positioned(
//           left: dx,
//           top: dy,
//           child: Transform.rotate(
//             angle: rotation,
//             child: Container(
//               width: pebbleSize,
//               height: pebbleSize,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.9),
//                 gradient: const RadialGradient(
//                   colors: [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//                   center: Alignment.topLeft,
//                   radius: 0.8,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 2,
//                     offset: const Offset(0.5, 0.5),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return pebbles;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (widget.isTop) CountBadge(count: widget.count),
//         GestureDetector(
//           onTap: widget.enabled ? widget.onTap : null,
//           child: AnimatedScale(
//             scale: widget.animating ? 1.08 : 1.0,
//             duration: const Duration(milliseconds: 240),
//             child: Container(
//               width: widget.size,
//               height: widget.size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color:
//                     widget.woodenTexture == null
//                         ? const Color(0xFF966F33)
//                         : null,
//                 image: widget.woodenTexture,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF4B3219).withOpacity(0.7),
//                     blurRadius: 12,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Container(
//                 margin: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.black.withOpacity(0.8),
//                   boxShadow:
//                       widget.lastMove
//                           ? [
//                               BoxShadow(
//                                 color: const Color(0xFFC69C6D).withOpacity(0.8),
//                                 blurRadius: 8,
//                               ),
//                             ]
//                           : null,
//                 ),
//                 child: ClipOval(child: Stack(children: _pebbles)),
//               ),
//             ),
//           ),
//         ),
//         if (!widget.isTop) CountBadge(count: widget.count),
//       ],
//     );
//   }
// }

// class StoreWidget extends StatelessWidget {
//   final int count;
//   final String label;
//   final double height;
//   final DecorationImage? woodenTexture;
//   final bool isPlayerTwoStore;

//   const StoreWidget({
//     Key? key,
//     required this.count,
//     required this.label,
//     this.height = 260,
//     this.woodenTexture,
//     required this.isPlayerTwoStore,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Color playerColor = isPlayerTwoStore
//         ? const Color(0xFF8B5CF6)
//         : const Color(0xFFFF4D67);

//     return Column(
//       children: [
//         Container(
//           width: 58,
//           height: height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             color: woodenTexture == null
//                 ? const Color(0xFF966F33)
//                 : null,
//             image: woodenTexture,
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF4B3219).withOpacity(0.5),
//                 blurRadius: 16,
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.black.withOpacity(0.85),
//                 border: Border.all(
//                   color: playerColor.withOpacity(0.6),
//                   width: 1.5
//                 )
//               ),
//               child: Center(
//                 child: Text(
//                   count.toString(),
//                   style: const TextStyle(fontSize: 22, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 11),
//         ),
//       ],
//     );
//   }
// }

// class CountBadge extends StatelessWidget {
//   final int count;
//   const CountBadge({Key? key, required this.count}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       margin: const EdgeInsets.only(bottom: 4, top: 4),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.75),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Text(
//         count.toString(),
//         style: const TextStyle(color: Colors.white, fontSize: 11),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Assuming these imports lead to external logic you have
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/core/services/play_friends_game_logic.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';

const String _woodenTexturePath = 'assets/images/assets/texture_test.jpg';

class SungkaGame extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  SungkaGame({
    super.key,
    required this.navigateToScreen,
    required this.showError,
  });

  @override
  State<SungkaGame> createState() => _SungkaGameState();
}

class _SungkaGameState extends State<SungkaGame> with TickerProviderStateMixin {
  late List<int> board;
  bool isPlayerOneTurn = true;
  bool gameEnded = false;
  int? animatingPit;
  int? lastMove;
  String winner = '';
  List<AnimatingPebbleData> animatingPebbles = [];
  late AnimationController _masterController;

  @override
  void initState() {
    super.initState();
    _resetBoard();
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _masterController.dispose();
    super.dispose();
  }

  void _resetBoard() {
    board = [7, 7, 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0];
    isPlayerOneTurn = true;
    gameEnded = false;
    winner = '';
    animatingPit = null;
    lastMove = null;
    animatingPebbles = [];
    setState(() {});
  }

  void _showGameOverDialog() {
    final String playerOneName = 'Player 1';
    final String playerTwoName = 'Player 2';

    final String finalWinner = PlayFriendsGameLogic.getWinner(board);
    String winnerLabel;
    if (finalWinner == 'player1') {
      winnerLabel = '$playerOneName Wins!';
    } else if (finalWinner == 'player2') {
      winnerLabel = '$playerTwoName Wins!';
    } else {
      winnerLabel = "It's a Tie!";
    }

    // Build title/message to pass into GameOverDialog
    final String title = winnerLabel;
    final String message =
        'Final Score';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameOverDialog(
          title: title,
          message: message,
          playerScore: board[7],
          botScore: board[15],
          onPlayAgain: () {
            // Dismiss the dialog and reset board
            Navigator.of(context).pop();
            _resetBoard();
          },
          onGoHome: () {
            // Dismiss dialog, then pop game screen
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _handlePitTap(int pit) async {
    if (gameEnded) return;

    final isPitOfPlayerOne = pit >= 0 && pit <= 6;
    final isPitOfPlayerTwo = pit >= 8 && pit <= 14;

    if (isPlayerOneTurn && (!isPitOfPlayerOne || board[pit] == 0)) return;
    if (!isPlayerOneTurn && (!isPitOfPlayerTwo || board[pit] == 0)) return;

    setState(() {
      animatingPit = pit;
      lastMove = pit;
    });

    List<int> newBoard = List.from(board);
    int stones = newBoard[pit];
    newBoard[pit] = 0;
    int index = pit;

    for (int i = 0; i < stones; i++) {
      int nextIndex = (index + 1) % newBoard.length;

      // Skip opponent's store pit: Player 1 skips pit 15 (P2's store)
      if (isPlayerOneTurn && nextIndex == 15) {
        nextIndex = (nextIndex + 1) % newBoard.length;
      } 
      // Skip opponent's store pit: Player 2 skips pit 7 (P1's store)
      else if (!isPlayerOneTurn && nextIndex == 7) {
        nextIndex = (nextIndex + 1) % newBoard.length;
      }

      nextIndex %= newBoard.length;

      setState(() {
        animatingPebbles.add(
          AnimatingPebbleData(
            fromPit: index,
            toPit: nextIndex,
            startTime: DateTime.now(),
            duration: const Duration(milliseconds: 600),
          ),
        );
      });

      await Future.delayed(const Duration(milliseconds: 180));

      index = nextIndex;
      newBoard[index] += 1;

      setState(() {
        board = List.from(newBoard);
        animatingPit = index;

        animatingPebbles.removeWhere((p) => p.isComplete);
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // Call external logic for captures and final move result
    final moveResult = PlayFriendsGameLogic.makeMove(
      board,
      pit,
      isPlayerOneTurn,
    );
    final resultBoard = moveResult['board'] as List<int>;
    final hasExtraTurn = moveResult['hasExtraTurn'] as bool;
    
    // Apply the final rule result (captures, etc.)
    setState(() {
      board = List<int>.from(resultBoard);
      animatingPit = null;
      animatingPebbles = [];
    });

    // Check for end game state
    final result = GameLogic.checkEndGame(resultBoard);
    if (result['isEnded'] as bool) {
      setState(() {
        // Apply the final board state (with remaining stones moved to stores)
        board = List<int>.from(result['finalBoard'] as List<int>);
        gameEnded = true;
        winner = GameLogic.getWinner(board); 
      });
      // Show dialog immediately after setting gameEnded state
      _showGameOverDialog(); 

    } else {
      setState(() {
        if (!hasExtraTurn) {
          isPlayerOneTurn = !isPlayerOneTurn;
        }
      });
    }
  }

  Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
    const storeWidth = 58.0;
    const sidePadding = 8.0;
    const verticalPadding = 24.0;

    bool isTop = pitIndex >= 8 && pitIndex <= 14;
    bool isStore = pitIndex == 7 || pitIndex == 15;

    int col = 0;
    if (isTop) {
      col = 14 - pitIndex;
    } else if (!isStore) {
      col = pitIndex;
    }

    double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
    double pitSpacing = gridWidth / 7;

    double x;
    double y;

    if (pitIndex == 7) { // Player 1 Store (Right)
      x = boardWidth - storeWidth / 2 - sidePadding;
      y = verticalPadding + (210 / 2);
    } else if (pitIndex == 15) { // Player 2 Store (Left)
      x = storeWidth / 2 + sidePadding;
      y = verticalPadding + (210 / 2);
    } else {
      x = storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);
      y =
          isTop
              ? (verticalPadding + pitSize / 2)
              : (verticalPadding * 2 + pitSize + pitSize / 2);
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pitSize = screenWidth < 600 ? 48.0 : 66.0;
    final boardWidth = screenWidth > 900 ? 900.0 : screenWidth;

    const _boardTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
    );

    const _pitStoreTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black38,
        BlendMode.darken,
      ),
    );

    String playerOneName = 'Player 1';
    String playerTwoName = 'Player 2';

    String currentTurnText =
        isPlayerOneTurn ? "$playerOneName's Turn" : "$playerTwoName's Turn";
    
    // The winnerText logic is only used for the UI below the board *if* not showing the dialog
    String winnerText;
    if (winner == 'player1') {
      winnerText = '$playerOneName Wins!';
    } else if (winner == 'player2') {
      winnerText = '$playerTwoName Wins!';
    } else {
      winnerText = "It's a Tie!";
    }

    if (gameEnded && winner.isNotEmpty) {

    }


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A0A1A),
                  Color(0xFF1C0435),
                  Color(0xFF2B0018),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!gameEnded)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PlayerCards(
                                name: playerOneName,
                                score: board[7],
                                isActive: isPlayerOneTurn,
                                avatarIcon: Icons.person,
                              ),
                              Text(
                                currentTurnText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              PlayerCards(
                                name: playerTwoName,
                                score: board[15],
                                isActive: !isPlayerOneTurn,
                                avatarIcon: Icons.person,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PlayerCards(
                                name: playerOneName,
                                score: board[7],
                                isActive: winner == 'player1',
                                avatarIcon: Icons.person,
                              ),
                              Text(
                                winnerText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              PlayerCards(
                                name: playerTwoName,
                                score: board[15],
                                isActive: winner == 'player2',
                                avatarIcon: Icons.person,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // The 'Play Again' button is now gone, we show the dialog instead.
                        ],
                      ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                          Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFF4B3219),
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                            image: _boardTexture,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StoreWidget(
                                count: board[15],
                                label: '$playerTwoName Store',
                                height: 210,
                                isPlayerTwoStore: true,
                                woodenTexture: _pitStoreTexture,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(7, (i) {
                                        final index = 14 - i;
                                        return PitWidget(
                                          count: board[index],
                                          size: pitSize,
                                          isTop: true,
                                          enabled:
                                              !isPlayerOneTurn &&
                                              !gameEnded &&
                                              board[index] > 0,
                                          animating: animatingPit == index,
                                          lastMove: lastMove == index,
                                          woodenTexture: _pitStoreTexture,
                                          onTap: () => _handlePitTap(index),
                                        );
                                      }),
                                    ),
                                    Container(
                                      height: 3.0,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(
                                          0xFF4B3219,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(7, (i) {
                                        final index = i;
                                        return PitWidget(
                                          count: board[index],
                                          size: pitSize,
                                          isTop: false,
                                          enabled:
                                              isPlayerOneTurn &&
                                              !gameEnded &&
                                              board[index] > 0,
                                          animating: animatingPit == index,
                                          lastMove: lastMove == index,
                                          onTap: () => _handlePitTap(index),
                                          woodenTexture: _pitStoreTexture,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              StoreWidget(
                                count: board[7],
                                label: '$playerOneName Store',
                                height: 210,
                                isPlayerTwoStore: false,
                                woodenTexture: _pitStoreTexture,
                              ),
                            ],
                          ),
                        ),
                        if (animatingPebbles.isNotEmpty)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: AnimatedPebblesPainter(
                                  pebbles: animatingPebbles,
                                  getPitPosition:
                                      (pit) => _getPitPosition(
                                          pit,
                                          pitSize,
                                          boardWidth - 24,
                                        ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.white),
                      iconSize: 30,
                      onPressed: () {
                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => GameWidget(
                                          game: HomeGame(
                                            navigateToScreen: widget.navigateToScreen,
                                            showError: widget.showError,
                                          ),
                                        ),
                                      ),
                                    );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- NEW/MODIFIED WIDGETS ---

class GameOverDialog extends StatelessWidget {
  final String title;
  final String message;
  final int playerScore;
  final int botScore;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const GameOverDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.playerScore,
    required this.botScore,
    required this.onPlayAgain,
    required this.onGoHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWin = title == 'VICTORY!';
    final resultColor = isWin ? const Color(0xFFFACC15) : Colors.redAccent;
    final icon = isWin ? Icons.emoji_events : Icons.close_sharp;

    return Center(
      // Ensure the dialog content is scrollable if needed
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 2)
                      ],
                    ),
                  ),
                  // --- Message ---
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // --- Scoreboard ---
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
                        _ScoreItem(label: 'Your Score', score: playerScore, isWinner: isWin),
                        Container(width: 1, height: 40, color: Colors.white10),
                        _ScoreItem(label: 'Bot Score', score: botScore, isWinner: !isWin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- Buttons ---
                  Column(
                    children: [
                      // Play Again Button
                      _DialogButton(
                        text: 'Play Again',
                        color: const Color(0xFF6B8E23), // Olive Green
                        onPressed: onPlayAgain,
                      ),
                      const SizedBox(height: 10),
                      // Go Home Button
                      _DialogButton(
                        text: 'Back to Home',
                        color: const Color(0xFFC93030), // Dark Red
                        onPressed: onGoHome,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: TextStyle(
            color: scoreColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// --- ORIGINAL WIDGETS (Unmodified, but included for completeness) ---

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

class AnimatedPebblesPainter extends CustomPainter {
  final List<AnimatingPebbleData> pebbles;
  final Offset Function(int) getPitPosition;

  AnimatedPebblesPainter({required this.pebbles, required this.getPitPosition});

  @override
  void paint(Canvas canvas, Size size) {
    for (final pebble in pebbles) {
      if (pebble.isComplete) continue;

      final fromPos = getPitPosition(pebble.fromPit);
      final toPos = getPitPosition(pebble.toPit);
      final progress = pebble.progress;

      final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
      final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

      final arcHeight = 40.0;
      final verticalArc = sin(progress * pi) * arcHeight;

      final paint =
          Paint()
            ..shader = RadialGradient(
              colors: const [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
              center: Alignment.topLeft,
              radius: 0.8,
            ).createShader(
              Rect.fromCircle(
                center: Offset(currentX, currentY - verticalArc),
                radius: 6,
              ),
            )
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(currentX + 1, currentY - verticalArc + 1),
        6,
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(Offset(currentX, currentY - verticalArc), 6, paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
}

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
      final dx = _random.nextDouble() * (widget.size * 0.5) + (widget.size * 0.1);
      final dy = _random.nextDouble() * (widget.size * 0.5) + (widget.size * 0.1);
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

class StoreWidget extends StatelessWidget {
  final int count;
  final String label;
  final double height;
  final DecorationImage? woodenTexture;
  final bool isPlayerTwoStore;

  const StoreWidget({
    Key? key,
    required this.count,
    required this.label,
    this.height = 260,
    this.woodenTexture,
    required this.isPlayerTwoStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color playerColor = isPlayerTwoStore
        ? const Color(0xFF8B5CF6)
        : const Color(0xFFFF4D67);

    return Column(
      children: [
        Container(
          width: 58,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: woodenTexture == null
                ? const Color(0xFF966F33)
                : null,
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
                border: Border.all(
                  color: playerColor.withOpacity(0.6),
                  width: 1.5
                )
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
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
