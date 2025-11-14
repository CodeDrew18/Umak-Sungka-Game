// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sungka/core/services/bot_service.dart';
// import 'package:sungka/core/services/game_logic_service.dart';
// import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

// class SungkaBoardScreen extends StatefulWidget {
//   final Difficulty difficulty;
//   const SungkaBoardScreen({Key? key, required this.difficulty}) : super(key: key);

//   @override
//   State<SungkaBoardScreen> createState() => _SungkaBoardScreenState();
// }

// class _SungkaBoardScreenState extends State<SungkaBoardScreen> with TickerProviderStateMixin {
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
//     _botTimer?.cancel(); // Ensure timer is canceled
//     super.dispose();
//   }

//   void _resetBoard() {
//     board = [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0];
//     isPlayerTurn = true;
//     gameEnded = false;
//     winner = '';
//     animatingPit = null;
//     lastMove = null;
//     animatingPebbles = [];
//     setState(() {});
//   }

//   void _showGameOverDialog() {
//     // --- New: Game Over AlertDialog ---
//     String message;
//     if (winner == 'player') {
//       message = 'Congratulations! You Won!';
//     } else if (winner == 'bot') {
//       message = 'The Bot Won!';
//     } else {
//       message = "It's a Tie!";
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1C0435).withOpacity(0.95),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF8B5CF6))),
//           title: Text(
//             'Game Over! 🥳',
//             style: TextStyle(color: winner == 'player' ? Colors.greenAccent : Colors.white, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(message, style: const TextStyle(color: Colors.white70, fontSize: 16)),
//               const SizedBox(height: 10),
//               Text('Your Score: ${board[7]}', style: const TextStyle(color: Color(0xFFFF4D67), fontWeight: FontWeight.bold)),
//               Text('Bot Score: ${board[15]}', style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
//             ],
//           ),
//           actionsAlignment: MainAxisAlignment.center,
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _resetBoard();
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: const Color(0xFF7C3AED),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Play Again'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.black54,
//                 foregroundColor: Colors.white70,
//               ),
//               child: const Text('Home'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handlePitTap(int pit) async {
//     if (gameEnded || animatingPit != null) return; // Prevent new moves during animation
//     if (isPlayerTurn && (pit < 0 || pit > 6 || board[pit] == 0)) return;
//     if (!isPlayerTurn && (pit < 8 || pit > 14 || board[pit] == 0)) return;

//     setState(() {
//       animatingPit = pit;
//       lastMove = pit;
//     });

//     // ... (rest of the move and animation logic remains the same) ...
//     List<int> newBoard = List.from(board);
//     int stones = newBoard[pit];
//     newBoard[pit] = 0;
//     int index = pit;

//     for (int i = 0; i < stones; i++) {
//       int nextIndex = (index + 1) % newBoard.length;

//       if (isPlayerTurn && nextIndex == 15) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       } else if (!isPlayerTurn && nextIndex == 7) {
//         nextIndex = (nextIndex + 1) % newBoard.length;
//       }

//       setState(() {
//         animatingPebbles.add(AnimatingPebbleData(
//           fromPit: index,
//           toPit: nextIndex,
//           startTime: DateTime.now(),
//           duration: const Duration(milliseconds: 600),
//         ));
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

//     final resultBoard = GameLogic.makeMove(board, pit, isPlayerTurn);

//     setState(() {
//       board = List<int>.from(resultBoard);
//       animatingPit = null;
//       animatingPebbles = [];
//     });

//     final result = GameLogic.checkEndGame(resultBoard);
//     if (result['isEnded'] as bool) {
//       setState(() {
//         board = List<int>.from(result['finalBoard'] as List<int>);
//         gameEnded = true;
//         winner = GameLogic.getWinner(board);
//       });
//       // Trigger the new game over dialog
//       _showGameOverDialog();
//     } else {
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
//     double y = isTop ? (verticalPadding + pitSize / 2) : (verticalPadding * 2 + pitSize + pitSize / 2);

//     return Offset(x, y);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pitSize = screenWidth < 600 ? 48.0 : 66.0;

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



//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF0A0A1A), Color(0xFF1C0435), Color(0xFF2B0018)],
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
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                                 PlayerCards(
//                                 name: 'You',
//                                 score: board[7],
//                                 isActive: isPlayerTurn,
//                               ),
//                               SizedBox(width: 8),
//                                  Text(
//                             isPlayerTurn ? "Your Turn" : "Bot's Turn...",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
                          
//                           SizedBox(width: 8),

//                             PlayerCards(
//                                 name: 'Bot',
//                                 score: board[15],
//                                 isActive: !isPlayerTurn,
//                               ),
//                             ],
//                           )
                       
//                         ],
//                       )
//                     else
//                       Column(
//                         children: [
//                           Text(
//                             winner == 'player' ? 'You Win! 🎉' : (winner == 'bot' ? 'Bot Wins! 🤖' : "It's a Tie! 🤝"),
//                             style: const TextStyle(color: Colors.white, fontSize: 22),
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                       ),
//                     const SizedBox(height: 12),
//                     Stack(
//                       children: [
//                         Container(
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
//                                 label: 'Bot Store',
//                                 height: 210,
//                                 woodenTexture: _pitStoreTexture,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = 14 - i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: true,
//                                           enabled: !isPlayerTurn &&
//                                               !gameEnded &&
//                                               board[index] > 0,
//                                           animating: animatingPit == index,
//                                           lastMove: lastMove == index,
//                                           onTap: () => _handlePitTap(index),
//                                           woodenTexture: _pitStoreTexture,
                                          
//                                         );
//                                       }),
//                                     ),
//                                     Container(
//                                       height: 1.5,
//                                       margin: const EdgeInsets.symmetric(vertical: 8),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.transparent,
//                                             Colors.purple.withOpacity(0.45),
//                                             Colors.transparent,
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: List.generate(7, (i) {
//                                         final index = i;
//                                         return PitWidget(
//                                           count: board[index],
//                                           size: pitSize,
//                                           isTop: false,
//                                           enabled: isPlayerTurn &&
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
//                                 label: 'Your Store',
//                                 height: 210,
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
//                                   getPitPosition: (pit) => _getPitPosition(pit, pitSize, screenWidth - 24),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     // --- Updated Back Button to Icon Home ---
//                     IconButton(
//                       icon: const Icon(Icons.home, color: Colors.white70),
//                       iconSize: 30,
//                       onPressed: () => Navigator.of(context).pop(),
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.black54,
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

// // ===================================
// // New/Modified Helper Widgets
// // ===================================

// // New PlayerCard for the Card-style UI
// class PlayerCards extends StatelessWidget {
//   final String name;
//   final int score;
//   final bool isActive;

//   const PlayerCards({
//     Key? key,
//     required this.name,
//     required this.score,
//     required this.isActive,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final color = isActive ? const Color(0xFFFF4D67) : Colors.white70;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: isActive ? color.withOpacity(0.5) : Colors.white10,
//           width: isActive ? 2.0 : 1.0,
//         ),
//         boxShadow: isActive ? [
//           BoxShadow(
//             color: color.withOpacity(0.25),
//             blurRadius: 10,
//             spreadRadius: 1,
//           )
//         ] : null,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Name
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 8),
//           // Score
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: color.withOpacity(0.5)),
//             ),
//             child: Text(
//               score.toString(),
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ===================================
// // Existing Helper Widgets (Included for completeness)
// // ===================================

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

//       final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
//       final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

//       final arcHeight = 40.0;
//       final verticalArc = sin(progress * pi) * arcHeight;

//       final paint = Paint()
//         ..shader = RadialGradient(
//           colors: const [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
//           center: Alignment.topLeft,
//           radius: 0.8,
//         ).createShader(Rect.fromCircle(
//           center: Offset(currentX, currentY - verticalArc),
//           radius: 6,
//         ))
//         ..style = PaintingStyle.fill;

//       canvas.drawCircle(
//         Offset(currentX + 1, currentY - verticalArc + 1),
//         6,
//         Paint()
//           ..color = Colors.black.withOpacity(0.3)
//           ..style = PaintingStyle.fill,
//       );

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
//   final int count;
//   final String label;
//   final double height;
//   final DecorationImage? woodenTexture;

//   const StoreWidget({
//     Key? key,
//     required this.count,
//     required this.label,
//     this.height = 260,
//     this.woodenTexture,
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
//           color: Colors.black.withOpacity(0.75),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.white10)),
//       child: Text(count.toString(),
//           style: const TextStyle(color: Colors.white, fontSize: 11)),
//     );
//   }
// }

// // PlayerLabel is no longer used in the main build method, replaced by PlayerCard,
// // but included for completeness if used elsewhere.
// class PlayerLabel extends StatelessWidget {
//   final String name;
//   final int score;
//   final bool isActive;
//   const PlayerLabel({Key? key, required this.name, required this.score, required this.isActive})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final color = isActive ? const Color(0xFFFF4D67) : Colors.white70;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(40),
//           gradient:
//               LinearGradient(colors: [color.withOpacity(0.12), color.withOpacity(0.06)])),
//       child: Row(children: [
//         Container(
//             width: 8,
//             height: 8,
//             decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient:
//                     LinearGradient(colors: [Color(0xFFFF4D67), Color(0xFF8B5CF6)]))),
//         const SizedBox(width: 6),
//         Text(name, style: const TextStyle(color: Colors.white70)),
//         const SizedBox(width: 6),
//         Text(score.toString(), style: TextStyle(color: color)),
//       ]),
//     );
//   }
// }




import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sungka/core/services/bot_service.dart';
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/screens/player_vs_bot/on_match/player_card.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';



class SungkaBoardScreen extends StatefulWidget {
  final Difficulty difficulty;
  const SungkaBoardScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<SungkaBoardScreen> createState() => _SungkaBoardScreenState();
}

class _SungkaBoardScreenState extends State<SungkaBoardScreen> with TickerProviderStateMixin {
  late List<int> board;
  bool isPlayerTurn = true;
  bool gameEnded = false;
  int? animatingPit;
  int? lastMove;
  Timer? _botTimer;
  String winner = '';
  List<AnimatingPebbleData> animatingPebbles = [];
  late AnimationController _masterController;

  static const String _woodenTexturePath = 'assets/images/assets/texture_test.jpg';

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
    _botTimer?.cancel(); 
    super.dispose();
  }

  void _resetBoard() {
    // Initial board state with 7 stones per pit
    board = [7, 7, 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 0];
    isPlayerTurn = true;
    gameEnded = false;
    winner = '';
    animatingPit = null;
    lastMove = null;
    animatingPebbles = [];
    setState(() {});
  }

  void _showGameOverDialog() {
    String title;
    String message;
    
    if (winner == 'player') {
      title = 'VICTORY!';
      message = 'Congratulations! You Won!';
    } else if (winner == 'bot') {
      title = 'DEFEAT!';
      message = 'The Bot Won! Better luck next time.';
    } else {
      title = 'TIE!';
      message = "It's a Tie! A true battle of equals.";
    }

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
            // 1. Dismiss the dialog
            Navigator.of(context).pop(); 
            // 2. Reset the game board
            _resetBoard(); 
          },
          onGoHome: () {
            // 1. Dismiss the dialog
            Navigator.of(context).pop(); 
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  void _handlePitTap(int pit) async {
    if (gameEnded || animatingPit != null) return; 
    // Player turn check (pits 0-6)
    if (isPlayerTurn && (pit < 0 || pit > 6 || board[pit] == 0)) return;
    // Bot turn check (pits 8-14)
    if (!isPlayerTurn && (pit < 8 || pit > 14 || board[pit] == 0)) return;

    setState(() {
      animatingPit = pit;
      lastMove = pit;
    });

    // --- Animation Logic (Simplified for Flutter state) ---
    List<int> newBoard = List.from(board);
    int stones = newBoard[pit];
    newBoard[pit] = 0;
    int index = pit;

    for (int i = 0; i < stones; i++) {
      int nextIndex = (index + 1) % newBoard.length;

      // Skip opponent's store
      if (isPlayerTurn && nextIndex == 15) {
        nextIndex = (nextIndex + 1) % newBoard.length;
      } else if (!isPlayerTurn && nextIndex == 7) {
        nextIndex = (nextIndex + 1) % newBoard.length;
      }

      setState(() {
        animatingPebbles.add(AnimatingPebbleData(
          fromPit: index,
          toPit: nextIndex,
          startTime: DateTime.now(),
          duration: const Duration(milliseconds: 600),
        ));
      });

      // Delay between pebble drops
      await Future.delayed(const Duration(milliseconds: 180));

      index = nextIndex;
      newBoard[index] += 1;

      setState(() {
        board = List.from(newBoard);
        animatingPit = index;
        animatingPebbles.removeWhere((p) => p.isComplete);
      });
    }

    // Delay after all stones are dropped, before capturing/end game logic
    await Future.delayed(const Duration(milliseconds: 300));

    // Full game logic application (captures, final landing)
    final resultBoard = GameLogic.makeMove(board, pit, isPlayerTurn);

    setState(() {
      board = List<int>.from(resultBoard);
      animatingPit = null;
      animatingPebbles = [];
    });

    final result = GameLogic.checkEndGame(resultBoard);
    if (result['isEnded'] as bool) {
      setState(() {
        board = List<int>.from(result['finalBoard'] as List<int>);
        gameEnded = true;
        winner = GameLogic.getWinner(board);
      });
      _showGameOverDialog();
    } else {
      setState(() {
        // Check for free turn (simplified check using the end of the loop 'index')
        // isPlayerTurn = GameLogic.isFreeTurn(board, finalLandingPit, isPlayerTurn) ? isPlayerTurn : !isPlayerTurn;
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
    double y = isTop ? (verticalPadding + pitSize / 2) : (verticalPadding * 2 + pitSize + pitSize / 2);

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded( // Use Expanded to ensure the content is confined and handles vertical space
            child: SingleChildScrollView( // Add SingleChildScrollView for screen size robustness
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A0A1A), Color(0xFF1C0435), Color(0xFF2B0018)],
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
                                    name: 'You',
                                    score: board[7],
                                    isActive: isPlayerTurn,
                                    avatarIcon: Icons.person,
                                  ),
                                  const SizedBox(width: 8),
                                     Text(
                                       isPlayerTurn ? "Your Turn" : "Bot's Turn...",
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontSize: 21,
                                         fontWeight: FontWeight.bold
                                       ),
                                     ),
                                  
                                  const SizedBox(width: 8),

                                     PlayerCards(
                                       name: 'Bot',
                                       score: board[15],
                                       isActive: !isPlayerTurn,
                                       avatarIcon: Icons.smart_toy,
                                     ),
                                ],
                              )
                            
                            ],
                          )
                        else
                          Column(
                            children: [
                              Text(
                                winner == 'player' ? 'You Win! 🎉' : (winner == 'bot' ? 'Bot Wins! 🤖' : "It's a Tie! 🤝"),
                                style: const TextStyle(color: Colors.white, fontSize: 22),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final effectiveBoardWidth = constraints.maxWidth;
                            return Stack(
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
                                        label: 'Bot Store',
                                        height: 210,
                                        woodenTexture: _pitStoreTexture,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      StoreWidget(
                                        count: board[7],
                                        label: 'Your Store',
                                        height: 210,
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
                                          getPitPosition: (pit) => _getPitPosition(pit, pitSize, effectiveBoardWidth),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                        ),
                        const SizedBox(height: 12),
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.white),
                          iconSize: 30,
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 20), // Extra space at bottom
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                  const SizedBox(height: 15),

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

      final currentX = fromPos.dx + (toPos.dx - fromPos.dx) * progress;
      final currentY = fromPos.dy + (toPos.dy - fromPos.dy) * progress;

      final arcHeight = 40.0;
      final verticalArc = sin(progress * pi) * arcHeight;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFF8F8F8), Color(0xFFCCC0AA)],
          center: Alignment.topLeft,
          radius: 0.8,
        ).createShader(Rect.fromCircle(
          center: Offset(currentX, currentY - verticalArc),
          radius: 6,
        ))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(currentX + 1, currentY - verticalArc + 1),
        6,
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );

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

// --- Pit Widget ---

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

// --- Store Widget ---

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
