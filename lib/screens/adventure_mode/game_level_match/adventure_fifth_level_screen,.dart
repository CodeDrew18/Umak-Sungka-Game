// import 'dart:async';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sungka/core/services/adventure_fifth_level_game_logic.dart';
// import 'package:sungka/core/services/bot_service.dart';
// import 'package:sungka/screens/adventure_mode/game_level_match/adventure_cards.dart';
// import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

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

//       // Shadow
//       canvas.drawCircle(
//         Offset(currentX + 1, currentY - verticalArc + 1),
//         6,
//         Paint()
//           ..color = Colors.black.withOpacity(0.3)
//           ..style = PaintingStyle.fill,
//       );

//       // Pebble
//       canvas.drawCircle(Offset(currentX, currentY - verticalArc), 6, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
// }



// class AdventureFifthLevelScreen extends StatefulWidget {
//   final Difficulty difficulty;
//   final dynamic level;
//   const AdventureFifthLevelScreen({
//     Key? key,
//     required this.difficulty,
//     required this.level,
//   });

//   @override
//   State<AdventureFifthLevelScreen> createState() =>
//       _AdventureFifthLevelScreenState();
// }

// class _AdventureFifthLevelScreenState extends State<AdventureFifthLevelScreen>
//     with TickerProviderStateMixin {
//   late List<int> board;
//   bool isPlayerTurn = true;
//   bool gameEnded = false;
//   int? animatingPit;
//   int? lastMove;
//   Timer? _botTimer;
//   String winner = '';
//   List<AnimatingPebbleData> animatingPebbles = [];
//   late AnimationController _masterController;

//   static const String _woodenTexturePath = 'assets/images/assets/texture_test.jpg';

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
//     _botTimer?.cancel();
//     super.dispose();
//   }

//   void _resetBoard() {
//     board = [7, 7, 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0];
//     isPlayerTurn = true;
//     gameEnded = false;
//     winner = '';
//     animatingPit = null;
//     lastMove = null;
//     animatingPebbles = [];
//     setState(() {});
//   }

//       final firestore = FirebaseFirestore.instance;
//   final auth = FirebaseAuth.instance;
//  Future<void> completeLevel(int levelNumber) async {
//     final user = auth.currentUser;
//     if (user == null) return;

//     final userDoc = firestore.collection('users').doc(user.uid);
//     await userDoc.set({
//       'completedLevels': FieldValue.arrayUnion([levelNumber]),
//     }, SetOptions(merge: true));
//   }

//   void _handlePitTap(int pit) async {
//     if (gameEnded) return;
//     if (isPlayerTurn && (pit < 0 || pit > 6 || board[pit] == 0)) return;
//     if (!isPlayerTurn && (pit < 8 || pit > 14 || board[pit] == 0)) return;

//     setState(() {
//       animatingPit = pit;
//       lastMove = pit;
//     });

//     final stones = board[pit];
//     var tempBoard = List<int>.from(board);
//     tempBoard[pit] = 0;
//     int index = pit;

//     for (int i = 0; i < stones; i++) {
//       int nextIndex = (index + 1) % tempBoard.length;

//       if (isPlayerTurn && nextIndex == 15) {
//         nextIndex = (nextIndex + 1) % tempBoard.length;
//       } else if (!isPlayerTurn && nextIndex == 7) {
//         nextIndex = (nextIndex + 1) % tempBoard.length;
//       }

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
//       tempBoard[index] += 1;

//       setState(() {
//         board = List<int>.from(tempBoard);
//         animatingPit = index;
//         animatingPebbles.removeWhere((p) => p.isComplete);
//       });
//     }

//     await Future.delayed(const Duration(milliseconds: 300));

//     final result = AdventureFifthLevelGameLogic.makeMove(
//       board,
//       pit,
//       isPlayerTurn,
//     );
//     final resultBoard = result['board'] as List<int>;
//     final hasExtraTurn = result['hasExtraTurn'] as bool;

//     setState(() {
//       board = List<int>.from(resultBoard);
//       animatingPit = null;
//       animatingPebbles = [];
//     });

//     final endResult = AdventureFifthLevelGameLogic.checkEndGame(resultBoard);
//     if (endResult['isEnded'] as bool) {
//       setState(() {
//         board = List<int>.from(endResult['finalBoard'] as List<int>);
//         gameEnded = true;
//         winner = AdventureFifthLevelGameLogic.getWinner(board);
//       });

//       if (winner == 'player') {

//         completeLevel(widget.level as int); 
//       }

//       return;
//     }

//     if (!hasExtraTurn) {
//       setState(() {
//         isPlayerTurn = !isPlayerTurn;
//       });
//       if (!isPlayerTurn) _scheduleBotMove();
//     }
//   }

//   void _scheduleBotMove() {
//     _botTimer?.cancel();
//     _botTimer = Timer(const Duration(milliseconds: 600), () {
//       if (gameEnded) return;
//       final botPit = BotService.getBotMove(board, widget.difficulty);
//       if (botPit != -1) _handlePitTap(botPit);
//     });
//   }

//   Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
//     const storeWidth = 58.0;
//     const sidePadding = 8.0;
//     const verticalPadding = 24.0;

//     bool isTop = pitIndex > 7;
//     int col = isTop ? 14 - pitIndex : pitIndex;

//     double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
//     double pitSpacing = gridWidth / 7;

//     double x = storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);
//     double y =
//         isTop
//             ? (verticalPadding + pitSize / 2)
//             : (verticalPadding * 2 + pitSize + pitSize / 2);

//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pitSize = screenWidth < 600 ? 48.0 : 66.0;

//     // *** Define the common DecorationImage with the new asset ***
//     const _boardTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//     );

//     // *** Define a slightly darker filter for the Pit/Store interiors (for depth) ***
//     const _pitStoreTexture = DecorationImage(
//       image: AssetImage(_woodenTexturePath),
//       fit: BoxFit.cover,
//       colorFilter: ColorFilter.mode(
//         Colors.black38,
//         BlendMode.darken,
//       ),
//     );

//     return Scaffold(
//       // Changed to dark color to complement wood theme
//       backgroundColor: const Color(0xFF1E0E0E), 
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),

//             decoration: const BoxDecoration(
//               color: Color(0xFF1E0E0E), 
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
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               AdventureCards(
//                                 name: 'You',
//                                 score: board[7],
//                                 isActive: isPlayerTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                               Text(
//                                 isPlayerTurn
//                                     ? "Your Turn"
//                                     : "Adventure ${widget.level}...",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 21,
//                                   fontWeight: FontWeight.bold
//                                 ),
//                               ),
//                               // --- Bot Card (Icon: computer) ---
//                               AdventureCards(
//                                 name: 'Adventure ${widget.level}',
//                                 score: board[15],
//                                 isActive: !isPlayerTurn,
//                                 avatarIcon: Icons.terrain,
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     else
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                                                            AdventureCards(
//                                 name: 'You',
//                                 score: board[7],
//                                 isActive: isPlayerTurn,
//                                 avatarIcon: Icons.person,
//                               ),
//                               Text(
//                                 winner == 'player'
//                                     ? ' You Win!'
//                                     : (winner == 'Adventure ${widget.level}'
//                                         ? 'Adventure ${widget.level}!'
//                                         : "It's a Tie!"),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 22,
//                                 ),
//                               ),
//                               // --- Bot Card (Icon: computer, Game Ended) ---
//                               AdventureCards(
//                                 name: 'Adventure ${widget.level}',
//                                 score: board[15],
//                                 isActive: !isPlayerTurn,
//                                 avatarIcon: Icons.terrain,
//                               ),
//                             ],
//                           ),
//                           // ElevatedButton(
//                           //   onPressed: _resetBoard,
//                           //   style: ElevatedButton.styleFrom(
//                           //     backgroundColor: const Color(0xFF7C3AED),
//                           //   ),
//                           //   child: const Text('Play Again'),
//                           // ),
//                         ],
//                       ),
//                     const SizedBox(height: 12),
//                     Stack(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             // Changed border color to wood tone
//                             border: Border.all(color: const Color(0xFF4B3219), width: 5),
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
//                                 label: 'Adventure ${widget.level}',
//                                 height: 210,
//                                 // Pass the texture to the StoreWidget
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
//                                               !isPlayerTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           onTap: () => _handlePitTap(index),
//                                           // Pass the texture to the PitWidget
//                                           woodenTexture: _pitStoreTexture, 
//                                         );
//                                       }),
//                                     ),
//                                     Container(
//                                       height: 3.0,
//                                       margin: const EdgeInsets.symmetric(
//                                         vertical: 8,
//                                       ),
//                                       // Changed separator color to wood tone
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xFF4B3219), 
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
//                                               isPlayerTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           onTap: () => _handlePitTap(index),
//                                           // Pass the texture to the PitWidget
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
//                                 label: 'Your Store',
//                                 height: 210,
//                                 // Pass the texture to the StoreWidget
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
//                                         pit,
//                                         pitSize,
//                                         screenWidth - 24,
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                       const SizedBox(height: 12),
//                     IconButton(
//                       icon: const Icon(Icons.home, color: Colors.white70),
//                       iconSize: 30,
//                       onPressed: () {
//                         final didPlayerWin = gameEnded && winner == 'player';
//                         Navigator.of(context).pop(didPlayerWin);
//                       },
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.black54,
//                         padding: const EdgeInsets.all(12),
//                       ),
//                     ),
//                     // const SizedBox(height: 12),

//                     // ElevatedButton(
//                     //   onPressed: () {
//                     //   final didPlayerWin = gameEnded && winner == 'player';
//                     //   Navigator.of(context).pop(didPlayerWin);
//                     //     },
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.black54,
//                     //   ),
//                     //   child: const Text('Back'),
//                     // ),
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

// // -------------------------------------------------------------------
// //                          WIDGETS (Updated for Texture)
// // -------------------------------------------------------------------

// class PitWidget extends StatefulWidget {
//   final int count;
//   final double size;
//   final bool isTop;
//   final bool enabled;
//   final bool animating;
//   final bool lastMove;
//   final VoidCallback onTap;
//   // New property for the wooden texture
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
//     this.woodenTexture, // Allow texture to be passed
//   }) : super(key: key);

//   @override
//   State<PitWidget> createState() => _PitWidgetState();
// }

// class _PitWidgetState extends State<PitWidget> {
//   // Store the list of pebbles in the state
//   List<Widget> _pebbles = [];
//   // Use a single Random instance for the widget's lifetime
//   final Random _random = Random();

//   @override
//   void initState() {
//     super.initState();
//     // Generate pebbles when the widget is first created
//     _pebbles = _generatePebbles(widget.count);
//   }

//   @override
//   void didUpdateWidget(PitWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // ONLY regenerate pebbles if the count has actually changed
//     if (widget.count != oldWidget.count) {
//       setState(() {
//         _pebbles = _generatePebbles(widget.count);
//       });
//     }
//   }

//   // This function now generates pebbles with a fixed size
//   List<Widget> _generatePebbles(int count) {
//     final List<Widget> pebbles = [];
//     // Clamp the visual count for performance
//     final maxPebbles = count.clamp(0, 10); 

//     for (int i = 0; i < maxPebbles; i++) {
//       final dx = _random.nextDouble() * 30 + 10;
//       final dy = _random.nextDouble() * 30 + 10;
      
//       // Fixed size of 6.0
//       final double pebbleSize = 6.0; 
      
//       final rotation = _random.nextDouble() * pi;

//       pebbles.add(
//         Positioned(
//           left: dx,
//           top: dy,
//           child: Transform.rotate(
//             angle: rotation,
//             child: Container(
//               // Apply fixed size
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
//     // Removed the gradient logic for the pit body/lip, replaced with wood color/texture
    
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
//                 // The outer pit ring/lip uses a solid wood color or the texture
//                 color: widget.woodenTexture == null ? const Color(0xFF966F33) : null, 
//                 image: widget.woodenTexture, 
//                 boxShadow: [
//                   BoxShadow(
//                     // Changed shadow color to a dark wood tone
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
//                               BoxShadow(
//                                 // Highlight color for last move (can be customized)
//                                 color: const Color(0xFFC69C6D).withOpacity(0.8),
//                                 blurRadius: 8,
//                               ),
//                             ]
//                           : null,
//                 ),
//                 // Use the stored pebble list
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
//   // New property for the wooden texture
//   final DecorationImage? woodenTexture; 

//   const StoreWidget({
//     Key? key,
//     required this.count,
//     required this.label,
//     this.height = 260,
//     this.woodenTexture, // Allow texture to be passed
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 58,
//           height: height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             // Store uses the passed wooden texture for the outer body
//             color: woodenTexture == null ? const Color(0xFF966F33) : null,
//             image: woodenTexture, 
//             boxShadow: [
//               BoxShadow(
//                 // Changed shadow color to wood tone
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
//                 // Inner count display is deep black for contrast
//                 color: Colors.black.withOpacity(0.85), 
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

// class PlayerLabel extends StatelessWidget {
//   final String name;
//   final int score;
//   final bool isActive;
//   const PlayerLabel({
//     Key? key,
//     required this.name,
//     required this.score,
//     required this.isActive,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final color = isActive ? const Color(0xFFFF4D67) : Colors.white70;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(40),
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.12), color.withOpacity(0.06)],
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFF4D67), Color(0xFF8B5CF6)],
//               ),
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(name, style: const TextStyle(color: Colors.white70)),
//           const SizedBox(width: 6),
//           Text(score.toString(), style: TextStyle(color: color)),
//         ],
//       ),
//     );
//   }
// }




import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sungka/core/services/adventure_fifth_level_game_logic.dart';
import 'package:sungka/core/services/adventure_fourth_level_game_logic.dart';
import 'package:sungka/core/services/bot_service.dart';
import 'package:sungka/screens/adventure_mode/game_level_match/adventure_cards.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

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

      // Shadow
      canvas.drawCircle(
        Offset(currentX + 1, currentY - verticalArc + 1),
        6,
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );

      // Pebble
      canvas.drawCircle(Offset(currentX, currentY - verticalArc), 6, paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedPebblesPainter oldDelegate) => true;
}

class AdventureFifthLevelScreen extends StatefulWidget {
  final Difficulty difficulty;
  final dynamic level;
  const AdventureFifthLevelScreen({
    Key? key,
    required this.difficulty,
    required this.level,
  }) : super(key: key);

  @override
  State<AdventureFifthLevelScreen> createState() =>
      _AdventureFifthLevelScreenState();
}

class _AdventureFifthLevelScreenState extends State<AdventureFifthLevelScreen>
    with TickerProviderStateMixin {
  late List<int> board;
  bool isPlayerTurn = true;
  bool gameEnded = false;
  int? animatingPit;
  int? lastMove;
  Timer? _botTimer;
  String winner = '';
  List<AnimatingPebbleData> animatingPebbles = [];
  late AnimationController _masterController;

  static const String _woodenTexturePath =
      'assets/images/assets/texture_test.jpg';

  @override
  void initState() {
    super.initState();
    // Ensure landscape orientation for the game board
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _resetBoard();
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Reset orientation preference on game end
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _masterController.dispose();
    _botTimer?.cancel();
    super.dispose();
  }

  void _resetBoard() {
        board = [7, 7, 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0];
    isPlayerTurn = true;
    gameEnded = false;
    winner = '';
    animatingPit = null;
    lastMove = null;
    animatingPebbles = [];
    setState(() {});
  }

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Future<void> completeLevel(int levelNumber) async {
    final user = auth.currentUser;
    if (user == null) return;

    final userDoc = firestore.collection('users').doc(user.uid);
    await userDoc.set({
      'completedLevels': FieldValue.arrayUnion([levelNumber]),
    }, SetOptions(merge: true));
  }

  void _handlePitTap(int pit) async {
    if (gameEnded) return;
    if (isPlayerTurn && (pit < 0 || pit > 6 || board[pit] == 0)) return;
    if (!isPlayerTurn && (pit < 8 || pit > 14 || board[pit] == 0)) return;

    setState(() {
      animatingPit = pit;
      lastMove = pit;
    });

    final stones = board[pit];
    var tempBoard = List<int>.from(board);
    tempBoard[pit] = 0;
    int index = pit;

    for (int i = 0; i < stones; i++) {
      int nextIndex = (index + 1) % tempBoard.length;

      if (isPlayerTurn && nextIndex == 15) {
        nextIndex = (nextIndex + 1) % tempBoard.length;
      } else if (!isPlayerTurn && nextIndex == 7) {
        nextIndex = (nextIndex + 1) % tempBoard.length;
      }

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
      tempBoard[index] += 1;

      setState(() {
        board = List<int>.from(tempBoard);
        animatingPit = index;
        animatingPebbles.removeWhere((p) => p.isComplete);
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // Note: Assuming AdventureFirstLevelGameLogic.makeMove updates 'board' correctly,
    // including capturing stones and giving extra turns based on the logic.
    final result = AdventureFifthLevelGameLogic.makeMove(
      board,
      pit,
      isPlayerTurn,
    );
    final resultBoard = result['board'] as List<int>;
    final hasExtraTurn = result['hasExtraTurn'] as bool;

    setState(() {
      board = List<int>.from(resultBoard);
      animatingPit = null;
      animatingPebbles = [];
    });

    final endResult = AdventureFifthLevelGameLogic.checkEndGame(resultBoard);
    if (endResult['isEnded'] as bool) {
      setState(() {
        board = List<int>.from(endResult['finalBoard'] as List<int>);
        gameEnded = true;
        winner = AdventureFifthLevelGameLogic.getWinner(board);
      });

      if (winner == 'player') {
        await completeLevel(widget.level as int);
      }
      
      _showGameOverDialog();
      return;
    }

    if (!hasExtraTurn) {
      setState(() {
        isPlayerTurn = !isPlayerTurn;
      });
      if (!isPlayerTurn) _scheduleBotMove();
    }
  }

  void _scheduleBotMove() {
    _botTimer?.cancel();
    _botTimer = Timer(const Duration(milliseconds: 600), () {
      if (gameEnded) return;
      final botPit = BotService.getBotMove(board, widget.difficulty);
      if (botPit != -1) _handlePitTap(botPit);
    });
  }

  Offset _getPitPosition(int pitIndex, double pitSize, double boardWidth) {
    const storeWidth = 58.0;
    const sidePadding = 8.0;
    const verticalPadding = 24.0;

    bool isTop = pitIndex > 7;
    int col = isTop ? 14 - pitIndex : pitIndex;

    double gridWidth = boardWidth - (storeWidth * 2) - (sidePadding * 2);
    double pitSpacing = gridWidth / 7;

    double x = storeWidth + sidePadding + (col * pitSpacing) + (pitSpacing / 2);
    double y =
        isTop
            ? (verticalPadding + pitSize / 2)
            : (verticalPadding * 2 + pitSize + pitSize / 2);

    // Special case for Store positions (indices 7 and 15)
    if (pitIndex == 7) {
      // Player's store (right)
      x = boardWidth - storeWidth / 2 - sidePadding;
      y = (verticalPadding * 1.5 + pitSize);
    } else if (pitIndex == 15) {
      // Bot's store (left)
      x = storeWidth / 2 + sidePadding;
      y = (verticalPadding * 1.5 + pitSize);
    }

    return Offset(x, y);
  }
  
  void _showGameOverDialog() {
    final title = winner == 'player' 
        ? 'VICTORY!' 
        : (winner.isNotEmpty ? 'DEFEAT' : 'STALEMATE');
    final message = winner == 'player' 
        ? 'You conquered Adventure ${widget.level}!'
        : (winner.isNotEmpty ? 'The Adventure ${widget.level} proved too strong.' : "It's a draw, neither player wins!");

    showDialog(
      context: context,
      barrierDismissible: false, // Must select an option
      builder: (BuildContext context) {
        return GameOverDialog(
          title: title,
          message: message,
          playerScore: board[7],
          botScore: board[15],
          onPlayAgain: () {
            Navigator.of(context).pop(); // Close dialog
            _resetBoard(); // Start new game
          },
          onGoHome: () {
            Navigator.of(context).pop(); // Close dialog
            // Return 'true' if player won, otherwise 'false'
            Navigator.of(context).pop(winner == 'player'); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Force landscape mode inside the build method
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final screenWidth = MediaQuery.of(context).size.width;
    final pitSize = screenWidth < 600 ? 48.0 : 66.0;

    const _boardTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
    );

    const _pitStoreTexture = DecorationImage(
      image: AssetImage(_woodenTexturePath),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black38, // Subtle dark overlay for depth
        BlendMode.darken,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E0E0E),
      body: SafeArea(
        child: SingleChildScrollView( // Add SingleChildScrollView to prevent overflow on very small screens
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E0E0E),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- Game Status Cards ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Player Card
                            AdventureCards(
                              name: 'You',
                              score: board[7],
                              isActive: isPlayerTurn && !gameEnded,
                              avatarIcon: Icons.person,
                            ),
                            // Turn Indicator / Game End Text
                            Text(
                              gameEnded
                                  ? (winner == 'player'
                                      ? '🏆 You Win!'
                                      : (winner.isNotEmpty
                                          ? 'Defeated'
                                          : "Tie"))
                                  : (isPlayerTurn ? "Your Turn" : "Adventure ${widget.level}'s Turn"),
                              style: TextStyle(
                                color: gameEnded
                                    ? (winner == 'player'
                                        ? const Color(0xFFFACC15) // Gold for Win
                                        : Colors.redAccent) // Red for Loss/Tie
                                    : Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Bot Card
                            AdventureCards(
                              name: 'Adventure ${widget.level}',
                              score: board[15],
                              isActive: !isPlayerTurn && !gameEnded,
                              avatarIcon: Icons.terrain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // --- Sungka Board ---
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
                                  // Bot Store (Left)
                                  StoreWidget(
                                    count: board[15],
                                    label: 'Adventure ${widget.level}',
                                    height: 210,
                                    woodenTexture: _pitStoreTexture,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // Top Pits (Bot's Side)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(7, (i) {
                                            final index = 14 - i;
                                            return PitWidget(
                                              count: board[index],
                                              size: pitSize,
                                              isTop: true,
                                              enabled: !isPlayerTurn &&
                                                  !gameEnded &&
                                                  board[index] > 0,
                                              animating: animatingPit == index,
                                              lastMove: lastMove == index,
                                              onTap: () => _handlePitTap(index),
                                              woodenTexture: _pitStoreTexture,
                                            );
                                          }),
                                        ),
                                        // Separator
                                        Container(
                                          height: 3.0,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF4B3219),
                                          ),
                                        ),
                                        // Bottom Pits (Player's Side)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(7, (i) {
                                            final index = i;
                                            return PitWidget(
                                              count: board[index],
                                              size: pitSize,
                                              isTop: false,
                                              enabled: isPlayerTurn &&
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
                                  // Player Store (Right)
                                  StoreWidget(
                                    count: board[7],
                                    label: 'Your Store',
                                    height: 210,
                                    woodenTexture: _pitStoreTexture,
                                  ),
                                ],
                              ),
                            ),
                            // Animated Pebbles Overlay
                            if (animatingPebbles.isNotEmpty)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: CustomPaint(
                                    painter: AnimatedPebblesPainter(
                                      pebbles: animatingPebbles,
                                      getPitPosition: (pit) => _getPitPosition(
                                        pit,
                                        pitSize,
                                        screenWidth - 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Home Button (Only visible if the game is NOT over)
                        if (!gameEnded)
                          IconButton(
                            icon: const Icon(Icons.home, color: Colors.white),
                            iconSize: 30,
                            onPressed: () async {
                              bool? exitGame = await showGeneralDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: 'Exit Game',
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                // The pageBuilder is simplified as the content is in transitionBuilder
                                pageBuilder: (context, anim1, anim2) {
                                  return const SizedBox.shrink();
                                },
                                transitionBuilder: (
                                  context,
                                  anim1,
                                  anim2,
                                  child,
                                ) {
                                  return Transform.scale(
                                    // Use an interpolated scale for a smoother, more 'poppy' effect
                                    scale: 0.8 + (anim1.value * 0.2),
                                    child: Opacity(
                                      opacity: anim1.value,
                                      child: Center(
                                        child: Container(
                                          width:
                                              320, // Slightly wider for better presentation
                                          padding: const EdgeInsets.all(
                                            24,
                                          ), // Increased padding
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ), // More rounded corners
                                            // Use a deeper, more sophisticated dark gradient
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF1E1E1E),
                                                Color(0xFF0F0F0F),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            // Enhanced box shadow for depth
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.8,
                                                ),
                                                offset: const Offset(0, 10),
                                                blurRadius: 20,
                                              ),
                                            ],
                                            // Use a subtle, vibrant border color
                                            border: Border.all(
                                              color: const Color(0xFF4A4A4A),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Larger, more dramatic warning icon
                                              const Icon(
                                                Icons
                                                    .exit_to_app, // A more relevant icon for "Exit"
                                                color: Color(
                                                  0xFFFFA726,
                                                ), // Orange/Amber for warning but more contrast
                                                size: 60,
                                              ),
                                              const SizedBox(height: 15),
                                              const Text(
                                                "EXIT GAME?",
                                                style: TextStyle(
                                                  color: Color(
                                                    0xFFFFA726,
                                                  ), // Matching the icon color
                                                  fontSize:
                                                      26, // Larger heading
                                                  fontWeight:
                                                      FontWeight
                                                          .w900, // Extra bold
                                                  letterSpacing:
                                                      1.5, // Spacing for a more aggressive look
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Unsaved progress will be lost. Are you sure you want to return to the Selection Mode?",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize:
                                                      14, // Slightly smaller body text for hierarchy
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 30),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  // --- Cancel Button (Secondary/Passive) ---
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                          ),
                                                      child: ElevatedButton(
                                                        onPressed:
                                                            () => Navigator.of(
                                                              context,
                                                            ).pop(false),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFF4A4A4A,
                                                              ), // Deep grey/neutral
                                                          elevation: 0,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "CANCEL",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                          ),
                                                      child: ElevatedButton(
                                                        onPressed:
                                                            () => Navigator.of(
                                                              context,
                                                            ).pop(true),
                                                        style: ElevatedButton.styleFrom(
                                                          // Use a more aggressive game red/orange
                                                          backgroundColor:
                                                              const Color(
                                                                0xFFC62828,
                                                              ),
                                                          elevation: 5,
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            side: const BorderSide(
                                                              color: Color(
                                                                0xFFFF5252,
                                                              ),
                                                              width: 1.5,
                                                            ), // Accent border
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          "EXIT",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            letterSpacing: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (exitGame == true) {
                                Navigator.of(context).pop(false);
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFC62828,
                              ), // Consistent primary color
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// Game Board Component Widgets
// -------------------------------------------------------------------

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
    // Cap the number of visually displayed pebbles for performance
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
                // The outer pit ring/lip uses the solid color or the texture
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
                  // The pit interior is a deep black/dark color for depth contrast
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

  const StoreWidget({
    Key? key,
    required this.count,
    required this.label,
    this.height = 260,
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
            // Store uses the passed wooden texture for the outer body
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
                // Inner count display is deep black for contrast
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

class PlayerLabel extends StatelessWidget {
  final String name;
  final int score;
  final bool isActive;
  const PlayerLabel({
    Key? key,
    required this.name,
    required this.score,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFFF4D67) : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.06)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF4D67), Color(0xFF8B5CF6)],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(name, style: const TextStyle(color: Colors.white70)),
          const SizedBox(width: 6),
          Text(score.toString(), style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

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
    // Determine the result color and icon
    final isWin = title == 'VICTORY!';
    final resultColor = isWin ? const Color(0xFFFACC15) : Colors.redAccent;
    final icon = isWin ? Icons.emoji_events : Icons.close_sharp;

    return Center(
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
                Icon(icon, size: 32, color: resultColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: resultColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 2)
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),

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
                Column(
                  children: [

                    _DialogButton(
                      text: 'Play Again',
                      color: const Color(0xFF6B8E23),
                      onPressed: onPlayAgain,
                    ),
                    const SizedBox(height: 10),
                    _DialogButton(
                      text: 'Return to Levels',
                      color: const Color(0xFFC93030),
                      onPressed: onGoHome,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for the Scoreboard in the dialog
class _ScoreItem extends StatelessWidget {
  final String label;
  final int score;
  final bool isWinner;

  const _ScoreItem({required this.label, required this.score, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          score.toString(),
          style: TextStyle(
            color: isWinner ? const Color(0xFFFACC15) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Helper widget for the buttons in the dialog
class _DialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _DialogButton({required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}