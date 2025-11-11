import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/core/services/play_friends_game_logic.dart';
import 'package:sungka/screens/home_screen.dart';

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
  // Removed Timer? _botTimer;
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

      if (isPlayerOneTurn && nextIndex == 15) {
        nextIndex = (nextIndex + 1) % newBoard.length;
      } else if (!isPlayerOneTurn && nextIndex == 7) {
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

    final moveResult = PlayFriendsGameLogic.makeMove(
      board,
      pit,
      isPlayerOneTurn,
    );
    final resultBoard = moveResult['board'] as List<int>;
    final hasExtraTurn = moveResult['hasExtraTurn'] as bool;

    setState(() {
      board = List<int>.from(resultBoard);
      animatingPit = null;
      animatingPebbles = [];
    });

    // Check for end game state
    final result = GameLogic.checkEndGame(resultBoard);
    if (result['isEnded'] as bool) {
      setState(() {
        board = List<int>.from(result['finalBoard'] as List<int>);
        gameEnded = true;
        winner = GameLogic.getWinner(board);
      });
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

    if (pitIndex == 7) {
      x = boardWidth - storeWidth / 2 - sidePadding;
      y = verticalPadding + (210 / 2);
    } else if (pitIndex == 15) {
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

    String playerOneName = 'Player 1';
    String playerTwoName = 'Player 2';

    String currentTurnText =
        isPlayerOneTurn ? "$playerOneName's Turn" : "$playerTwoName's Turn";
    String winnerText;

    if (winner == 'player1') {
      winnerText = '$playerOneName Wins!';
    } else if (winner == 'player2') {
      winnerText = '$playerTwoName Wins!';
    } else {
      winnerText = "It's a Tie!";
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
                          Text(
                            currentTurnText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlayerLabel(
                                name: playerOneName,
                                score: board[7],
                                isActive: isPlayerOneTurn,
                              ),
                              const SizedBox(width: 12),
                              PlayerLabel(
                                name: playerTwoName,
                                score: board[15],
                                isActive: !isPlayerOneTurn,
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Text(
                            winnerText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlayerLabel(
                                name: playerOneName,
                                score: board[7],
                                isActive: winner == 'player1',
                              ),
                              const SizedBox(width: 12),
                              PlayerLabel(
                                name: playerTwoName,
                                score: board[15],
                                isActive: winner == 'player2',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _resetBoard,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                            ),
                            child: const Text('Play Again'),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StoreWidget(
                                count: board[15],
                                label: '$playerTwoName Store',
                                height: 210,
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
                                          onTap: () => _handlePitTap(index),
                                        );
                                      }),
                                    ),
                                    Container(
                                      height: 1.5,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(7, (i) {
                                        final index = i; // 0, 1, ..., 6
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

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (context) => GameWidget(
                                  game: HomeGame(
                                    navigateToScreen: widget.navigateToScreen,
                                    showError: widget.showError,
                                  ),
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      child: const Text('Back'),
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

class PitWidget extends StatelessWidget {
  final int count;
  final double size;
  final bool isTop;
  final bool enabled;
  final bool animating;
  final bool lastMove;
  final VoidCallback onTap;

  const PitWidget({
    Key? key,
    required this.count,
    required this.size,
    required this.isTop,
    required this.enabled,
    required this.animating,
    required this.lastMove,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors:
          isTop
              ? [const Color(0xFF8B5CF6), const Color(0xFFFF4D67)]
              : [const Color(0xFFFF4D67), const Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Column(
      children: [
        if (isTop) CountBadge(count: count),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: AnimatedScale(
            scale: animating ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 240),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
                boxShadow: [
                  BoxShadow(
                    color: (isTop
                            ? const Color(0xFFFF4D67)
                            : const Color(0xFF8B5CF6))
                        .withOpacity(0.35),
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
                      lastMove
                          ? [
                            BoxShadow(
                              color: (isTop
                                      ? const Color(0xFF8B5CF6)
                                      : const Color(0xFFFF4D67))
                                  .withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ]
                          : null,
                ),
                child: ClipOval(child: Stack(children: _buildPebbles())),
              ),
            ),
          ),
        ),
        if (!isTop) CountBadge(count: count),
      ],
    );
  }

  List<Widget> _buildPebbles() {
    final random = Random();
    final List<Widget> pebbles = [];
    final maxPebbles = count.clamp(0, 10);

    for (int i = 0; i < maxPebbles; i++) {
      final dx = random.nextDouble() * 30 + 10;
      final dy = random.nextDouble() * 30 + 10;
      final size = random.nextDouble() * 6 + 4;
      final rotation = random.nextDouble() * pi;

      pebbles.add(
        Positioned(
          left: dx,
          top: dy,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: size,
              height: size,
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
}

class StoreWidget extends StatelessWidget {
  final int count;
  final String label;
  final double height;
  const StoreWidget({
    Key? key,
    required this.count,
    required this.label,
    this.height = 260,
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
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFFF4D67)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4D67).withOpacity(0.25),
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
