import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SungkaGame extends FlameGame with TapDetector, HasGameRef {
  static const int pitsPerSide = 6;
  static const int initialStones = 4;

  late List<int> player1Pits;
  late List<int> player2Pits;
  int player1Store = 0;
  int player2Store = 0;

  bool isPlayer1Turn = true;
  bool gameOver = false;
  String? winner;
  bool isAnimating = false;

  late TextPaint pitText;
  late TextPaint storeText;
  late TextPaint titleText;
  late TextPaint turnText;
  
  late double pitRadius;
  late double storeWidth;
  late double boardPadding;
  late double pitSpacing;
  
  late List<PebbleAnimation> activePebbles;
  HandAnimation? handAnimation;
  int? selectedPit;
  
  late Map<String, Offset> pitPositions;

  static const List<Color> stoneColors = [
    Color(0xFF1E90FF),
    Color(0xFF32CD32), 
    Color(0xFFFF8C00), 
    Color(0xFFFFD700), 
  ];

  @override
  Future<void> onLoad() async {
    player1Pits = List.filled(pitsPerSide, initialStones);
    player2Pits = List.filled(pitsPerSide, initialStones);
    activePebbles = [];
    pitPositions = {};

    pitText = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    storeText = TextPaint(
      style: const TextStyle(
        color: Color(0xFF8B4513),
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    titleText = TextPaint(
      style: const TextStyle(
        color: Color(0xFF8B4513),
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    turnText = TextPaint(
      style: const TextStyle(
        color: Color(0xFF8B4513),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    );


    pitRadius = 40;
    storeWidth = 100;
    boardPadding = 50;
    pitSpacing = 0;
  }

  @override
  void render(Canvas canvas) {
    final screenWidth = size.x;
    final screenHeight = size.y;
    final centerY = screenHeight / 2;
    final boardWidth = screenWidth - (2 * storeWidth) - (2 * boardPadding);
    pitSpacing = boardWidth / (pitsPerSide + 1);

    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF4A5568),
          const Color(0xFF2D3748),
        ],
      ).createShader(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    canvas.drawRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight), bgPaint);

    titleText.render(canvas, 'SUNGKA MASTER', Vector2(screenWidth / 2 - 80, 20));

    _drawInfoButton(canvas, screenWidth);

    _drawBoard(canvas, screenWidth, screenHeight, centerY);
    _drawPits(canvas, centerY);
    _drawStores(canvas, centerY);

    for (final pebble in activePebbles) {
      pebble.render(canvas);
    }

    final turnLabel = isPlayer1Turn ? 'Player 1 Turn' : 'Player 2 Turn';
    final turnColor = isPlayer1Turn ? const Color(0xFFFF8C00) : const Color(0xFF32CD32);
    final turnTextPaint = TextPaint(
      style: TextStyle(
        color: turnColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
      ),
    );
    turnTextPaint.render(canvas, turnLabel, Vector2(screenWidth / 2 - 80, screenHeight - 35));

    if (gameOver && winner != null) {
      _drawGameOverOverlay(canvas, screenWidth, screenHeight);
    }


    handAnimation?.render(canvas);
  }

  void _drawInfoButton(Canvas canvas, double screenWidth) {
    const buttonWidth = 60.0;
    const buttonHeight = 40.0;
    var buttonX = screenWidth - 80;
    const buttonY = 20.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(buttonX, buttonY, buttonWidth, buttonHeight),
        const Radius.circular(8),
      ),
      Paint()
        ..color = const Color(0xFF8B4513)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawInfoOverlay(Canvas canvas, double screenWidth, double screenHeight) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, screenWidth, screenHeight),
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    const boxWidth = 500.0;
    const boxHeight = 600.0;
    final boxLeft = (screenWidth - boxWidth) / 2;
    final boxTop = (screenHeight - boxHeight) / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFFFF8DC),
    );

    final titlePaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF8B4513),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );

    final contentPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 12,
        fontFamily: 'Poppins',
      ),
    );

    titlePaint.render(
      canvas,
      'How to Play',
      Vector2(boxLeft + 20, boxTop + 20),
    );

  }


  void _drawBoard(Canvas canvas, double screenWidth, double screenHeight, double centerY) {
    final boardLeft = storeWidth + boardPadding;
    final boardRight = screenWidth - storeWidth - boardPadding;
    final boardTop = centerY - 140;
    final boardBottom = centerY + 140;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(boardLeft - 8, boardTop - 8, boardRight + 8, boardBottom + 8),
        const Radius.circular(25),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    final boardPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFE8C9A0),
          const Color(0xFFD4A574),
        ],
      ).createShader(Rect.fromLTRB(boardLeft, boardTop, boardRight, boardBottom));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(boardLeft, boardTop, boardRight, boardBottom),
        const Radius.circular(20),
      ),
      boardPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(boardLeft, boardTop, boardRight, boardBottom),
        const Radius.circular(20),
      ),
      Paint()
        ..color = const Color(0xFF8B6F47)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  void _drawPits(Canvas canvas, double centerY) {
    final boardLeft = storeWidth + boardPadding;
    final boardWidth = size.x - (2 * storeWidth) - (2 * boardPadding);
    pitSpacing = boardWidth / (pitsPerSide + 1);

    for (int i = 0; i < pitsPerSide; i++) {
      final x = boardLeft + pitSpacing * (i + 1);
      final y = centerY + 75;
      pitPositions['p1_$i'] = Offset(x, y);
      _drawPit(canvas, x, y, player1Pits[i], i, true);
    }

    for (int i = 0; i < pitsPerSide; i++) {
      final x = boardLeft + pitSpacing * (i + 1);
      final y = centerY - 75;
      pitPositions['p2_$i'] = Offset(x, y);
      _drawPit(canvas, x, y, player2Pits[i], i, false);
    }
  }

  void _drawPit(Canvas canvas, double x, double y, int stoneCount, int index, bool isPlayer1) {
    canvas.drawCircle(
      Offset(x, y + 4),
      pitRadius + 3,
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final pitColor = isPlayer1 ? const Color(0xFFB8860B) : const Color(0xFF8B7355);
    final pitPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          pitColor.withOpacity(0.95),
          pitColor.withOpacity(0.75),
        ],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: pitRadius));

    canvas.drawCircle(Offset(x, y), pitRadius, pitPaint);

    canvas.drawCircle(
      Offset(x, y),
      pitRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    canvas.drawCircle(
      Offset(x - 3, y - 3),
      pitRadius - 4,
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    _drawStonesInPit(canvas, x, y, stoneCount);
  }

  void _drawStonesInPit(Canvas canvas, double x, double y, int count) {
    if (count == 0) return;

    final positions = _getStonePositions(count, pitRadius - 10);
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final stoneX = x + pos.dx;
      final stoneY = y + pos.dy;

      canvas.drawCircle(
        Offset(stoneX, stoneY + 2),
        6,
        Paint()
          ..color = Colors.black.withOpacity(0.25),
      );

      final stoneColor = stoneColors[i % stoneColors.length];
      final stonePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            stoneColor.withOpacity(0.95),
            stoneColor.withOpacity(0.75),
          ],
        ).createShader(Rect.fromCircle(center: Offset(stoneX, stoneY), radius: 6));

      canvas.drawCircle(Offset(stoneX, stoneY), 6, stonePaint);

      canvas.drawCircle(
        Offset(stoneX - 2, stoneY - 2),
        2.5,
        Paint()..color = Colors.white.withOpacity(0.5),
      );
    }
  }

  List<Offset> _getStonePositions(int count, double radius) {
    final positions = <Offset>[];
    if (count == 0) return positions;

    if (count == 1) {
      positions.add(Offset.zero);
    } else if (count == 2) {
      positions.add(Offset(-radius / 3, 0));
      positions.add(Offset(radius / 3, 0));
    } else if (count == 3) {
      positions.add(Offset(0, -radius / 3));
      positions.add(Offset(-radius / 3, radius / 3));
      positions.add(Offset(radius / 3, radius / 3));
    } else if (count == 4) {
      positions.add(Offset(-radius / 3, -radius / 3));
      positions.add(Offset(radius / 3, -radius / 3));
      positions.add(Offset(-radius / 3, radius / 3));
      positions.add(Offset(radius / 3, radius / 3));
    } else if (count == 5) {
      positions.add(Offset(0, -radius / 3));
      positions.add(Offset(-radius / 2.5, -radius / 5));
      positions.add(Offset(radius / 2.5, -radius / 5));
      positions.add(Offset(-radius / 3, radius / 3));
      positions.add(Offset(radius / 3, radius / 3));
    } else {
      for (int i = 0; i < count; i++) {
        final angle = (i / count) * 2 * math.pi;
        final x = radius * 0.65 * math.cos(angle);
        final y = radius * 0.65 * math.sin(angle);
        positions.add(Offset(x, y));
      }
    }
    return positions;
  }

  void _drawStores(Canvas canvas, double centerY) {
    final screenWidth = size.x;

    _drawStore(canvas, storeWidth / 2, centerY, player1Store, true);
    _drawStore(canvas, screenWidth - storeWidth / 2, centerY, player2Store, false);
  }

  void _drawStore(Canvas canvas, double x, double y, int stoneCount, bool isPlayer1) {
    const storeHeight = 160.0;
    const storeHalfWidth = 45.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: storeHalfWidth * 2 + 6,
          height: storeHeight + 6,
        ),
        const Radius.circular(12),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final storeColor = isPlayer1 ? const Color(0xFFCD853F) : const Color(0xFF8B4513);
    final storePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          storeColor.withOpacity(0.98),
          storeColor.withOpacity(0.85),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(x, y),
        width: storeHalfWidth * 2,
        height: storeHeight,
      ));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: storeHalfWidth * 2,
          height: storeHeight,
        ),
        const Radius.circular(10),
      ),
      storePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: storeHalfWidth * 2,
          height: storeHeight,
        ),
        const Radius.circular(10),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    _drawStoreStones(canvas, x, y, stoneCount);

    storeText.render(
      canvas,
      stoneCount.toString(),
      Vector2(x - 18, y + 10),
    );
  }

  void _drawStoreStones(Canvas canvas, double x, double y, int count) {
    if (count == 0) return;

    final rows = (count / 5).ceil();
    final cols = math.min(count, 5);
    final spacing = 14.0;

    int stoneIndex = 0;
    for (int row = 0; row < rows && stoneIndex < count; row++) {
      for (int col = 0; col < cols && stoneIndex < count; col++) {
        final stoneX = x - (cols - 1) * spacing / 2 + col * spacing;
        final stoneY = y - 40 + row * spacing;

        canvas.drawCircle(
          Offset(stoneX, stoneY + 1.5),
          5,
          Paint()..color = Colors.black.withOpacity(0.2),
        );

        final stoneColor = stoneColors[stoneIndex % stoneColors.length];
        final stonePaint = Paint()
          ..shader = RadialGradient(
            colors: [
              stoneColor.withOpacity(0.95),
              stoneColor.withOpacity(0.75),
            ],
          ).createShader(Rect.fromCircle(center: Offset(stoneX, stoneY), radius: 5));

        canvas.drawCircle(Offset(stoneX, stoneY), 5, stonePaint);

        canvas.drawCircle(
          Offset(stoneX - 1.5, stoneY - 1.5),
          1.8,
          Paint()..color = Colors.white.withOpacity(0.5),
        );

        stoneIndex++;
      }
    }
  }

  void _drawGameOverOverlay(Canvas canvas, double screenWidth, double screenHeight) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, screenWidth, screenHeight),
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    const boxWidth = 320.0;
    const boxHeight = 180.0;
    final boxLeft = (screenWidth - boxWidth) / 2;
    final boxTop = (screenHeight - boxHeight) / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFFFF8DC),
    );

    final winnerTextPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF8B4513),
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'Arial',
      ),
    );
    winnerTextPaint.render(
      canvas,
      winner ?? 'Game Over',
      Vector2(boxLeft + 40, boxTop + 50),
    );

    final restartTextPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF666666),
        fontSize: 16,
        fontFamily: 'Arial',
      ),
    );
    restartTextPaint.render(
      canvas,
      'Tap to restart',
      Vector2(boxLeft + 100, boxTop + 120),
    );
  }

  @override
  void onTapDown(TapDownInfo info) {
    final Vector2 pos = info.eventPosition.global;
    final screenWidth = size.x;

    if (gameOver) {
      _resetGame();
      return;
    }

    if (isAnimating) return;

    final screenHeight = size.y;
    final centerY = screenHeight / 2;
    final boardLeft = storeWidth + boardPadding;
    final boardWidth = screenWidth - (2 * storeWidth) - (2 * boardPadding);
    pitSpacing = boardWidth / (pitsPerSide + 1);

    for (int i = 0; i < pitsPerSide; i++) {
      final x = boardLeft + pitSpacing * (i + 1);
      final y = isPlayer1Turn ? centerY + 75 : centerY - 75;

      final pitCenter = Vector2(x, y);
      final distance = (pos - pitCenter).length;

      if (distance <= pitRadius + 10) {
        selectedPit = i;
        isAnimating = true;
        handAnimation = HandAnimation(
          startX: pos.x,
          startY: pos.y,
          targetX: x,
          targetY: y,
          onComplete: () => _startPebbleDistribution(i),
        );
        break;
      }
    }
  }

  void _startPebbleDistribution(int pitIndex) {
    List<int> currentPits = isPlayer1Turn ? player1Pits : player2Pits;
    List<int> opponentPits = isPlayer1Turn ? player2Pits : player1Pits;

    int stones = currentPits[pitIndex];
    if (stones == 0) {
      isAnimating = false;
      return;
    }

    currentPits[pitIndex] = 0;

    int idx = pitIndex;
    int stoneCount = 0;
    double delayPerStone = 0.1;
    int lastPitIndex = -2;
    int lastPitPlayer = isPlayer1Turn ? 1 : 2;

    final screenWidth = size.x;
    final centerY = size.y / 2;
    final boardLeft = storeWidth + boardPadding;
    final boardWidth = screenWidth - (2 * storeWidth) - (2 * boardPadding);
    pitSpacing = boardWidth / (pitsPerSide + 1);

    while (stones > 0) {
      idx++;

      Offset targetPos;
      bool isStore = false;

      if (isPlayer1Turn) {
        if (idx < pitsPerSide) {
          currentPits[idx]++;
          targetPos = Offset(boardLeft + pitSpacing * (idx + 1), centerY + 75);
          lastPitIndex = idx;
          lastPitPlayer = 1;
        } else if (idx == pitsPerSide) {

          player1Store++;
          isStore = true;
          targetPos = Offset(storeWidth / 2, centerY);
          lastPitIndex = -1;
          lastPitPlayer = 1;
        } else {
          int oppIdx = idx - (pitsPerSide + 1);
          if (oppIdx < pitsPerSide) {
            opponentPits[oppIdx]++;
            targetPos = Offset(boardLeft + pitSpacing * (oppIdx + 1), centerY - 75);
            lastPitIndex = oppIdx;
            lastPitPlayer = 2;
          } else {
            idx = -1;
            stones--;
            continue;
          }
        }
      } else {
        if (idx < pitsPerSide) {
          currentPits[pitsPerSide - 1 - idx]++;
          targetPos = Offset(boardLeft + pitSpacing * (pitsPerSide - idx), centerY - 75);
          lastPitIndex = pitsPerSide - 1 - idx;
          lastPitPlayer = 2;
        } else if (idx == pitsPerSide) {
          player2Store++;
          isStore = true;
          targetPos = Offset(screenWidth - storeWidth / 2, centerY);
          lastPitIndex = -1;
          lastPitPlayer = 2;
        } else {
          int oppIdx = idx - (pitsPerSide + 1);
          if (oppIdx < pitsPerSide) {
            opponentPits[pitsPerSide - 1 - oppIdx]++;
            targetPos = Offset(boardLeft + pitSpacing * (pitsPerSide - oppIdx), centerY + 75);
            lastPitIndex = pitsPerSide - 1 - oppIdx;
            lastPitPlayer = 1;
          } else {
            idx = -1; 
            stones--;
            continue;
          }
        }
      }

      final startPos = Offset(
        boardLeft + pitSpacing * (pitIndex + 1),
        centerY + (isPlayer1Turn ? 75 : -75),
      );

      activePebbles.add(
        PebbleAnimation(
          startPos: startPos,
          targetPos: targetPos,
          delay: stoneCount * delayPerStone,
          duration: 0.5,
          colorIndex: stoneCount,
        ),
      );

      stoneCount++;
      stones--;
    }

    final delayMs = ((stoneCount * delayPerStone * 1000) + 600).toInt();
    Future.delayed(Duration(milliseconds: delayMs), () {
      _finalizeMoveAfterAnimation(lastPitIndex, lastPitPlayer);
    });
  }

  void _finalizeMoveAfterAnimation(int lastPitIndex, int lastPitPlayer) {
    List<int> currentPits = isPlayer1Turn ? player1Pits : player2Pits;
    List<int> opponentPits = isPlayer1Turn ? player2Pits : player1Pits;

    bool turnAgain = false;

    if (lastPitIndex == -1) {
      turnAgain = true;
    }

    // Capture rule
    if (lastPitIndex >= 0) {
      if (isPlayer1Turn && lastPitPlayer == 1 && currentPits[lastPitIndex] == 1 && opponentPits[pitsPerSide - 1 - lastPitIndex] > 0) {
        player1Store += opponentPits[pitsPerSide - 1 - lastPitIndex] + 1;
        currentPits[lastPitIndex] = 0;
        opponentPits[pitsPerSide - 1 - lastPitIndex] = 0;
      } else if (!isPlayer1Turn && lastPitPlayer == 2 && currentPits[lastPitIndex] == 1 && opponentPits[pitsPerSide - 1 - lastPitIndex] > 0) {
        player2Store += opponentPits[pitsPerSide - 1 - lastPitIndex] + 1;
        currentPits[lastPitIndex] = 0;
        opponentPits[pitsPerSide - 1 - lastPitIndex] = 0;
      }
    }

    if (player1Pits.every((e) => e == 0) || player2Pits.every((e) => e == 0)) {
      player1Store += player1Pits.reduce((a, b) => a + b);
      player2Store += player2Pits.reduce((a, b) => a + b);
      player1Pits = List.filled(pitsPerSide, 0);
      player2Pits = List.filled(pitsPerSide, 0);
      gameOver = true;
      winner = player1Store > player2Store
          ? 'Player 1 Wins!'
          : player2Store > player1Store
              ? 'Player 2 Wins!'
              : 'Draw!';
    }

    if (!turnAgain) isPlayer1Turn = !isPlayer1Turn;

    selectedPit = null;
    isAnimating = false;
  }

  void _resetGame() {
    player1Pits = List.filled(pitsPerSide, initialStones);
    player2Pits = List.filled(pitsPerSide, initialStones);
    player1Store = 0;
    player2Store = 0;
    isPlayer1Turn = true;
    gameOver = false;
    winner = null;
    selectedPit = null;
    handAnimation = null;
    activePebbles.clear();
    isAnimating = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    handAnimation?.update(dt);
    if (handAnimation?.isComplete ?? false) {
      handAnimation = null;
    }

    activePebbles.removeWhere((pebble) {
      pebble.update(dt);
      return pebble.isComplete;
    });
  }
}

class PebbleAnimation {
  Offset startPos;
  Offset targetPos;
  double delay;
  double duration;
  double elapsed = 0;
  int colorIndex;

  PebbleAnimation({
    required this.startPos,
    required this.targetPos,
    required this.delay,
    required this.duration,
    required this.colorIndex,
  });

  bool get isComplete => elapsed >= delay + duration;
  bool get isActive => elapsed >= delay;

  void update(double dt) {
    elapsed += dt;
  }

  void render(Canvas canvas) {
    if (!isActive) return;

    final progress = ((elapsed - delay) / duration).clamp(0.0, 1.0);

    final currentX = startPos.dx + (targetPos.dx - startPos.dx) * progress;
    final currentY = startPos.dy + (targetPos.dy - startPos.dy) * _easeInOutCubic(progress);

    final heightOffset = math.sin(progress * math.pi) * 50;

    canvas.drawCircle(
      Offset(currentX, currentY - heightOffset + 2),
      7,
      Paint()
        ..color = Colors.black.withOpacity(0.2),
    );

    final stoneColor = SungkaGame.stoneColors[colorIndex % SungkaGame.stoneColors.length];
    final stonePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          stoneColor.withOpacity(0.98),
          stoneColor.withOpacity(0.85),
        ],
      ).createShader(Rect.fromCircle(center: Offset(currentX, currentY - heightOffset), radius: 7));

    canvas.drawCircle(Offset(currentX, currentY - heightOffset), 7, stonePaint);

    canvas.drawCircle(
      Offset(currentX - 2.5, currentY - heightOffset - 2.5),
      3,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
  }

  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - (math.pow(-2 * t + 2, 3) as double) / 2;
  }
}

class HandAnimation {
  double startX;
  double startY;
  double targetX;
  double targetY;
  double elapsed = 0;
  double duration = 0.5;
  VoidCallback onComplete;

  HandAnimation({
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
    required this.onComplete,
  });

  bool get isComplete => elapsed >= duration;

  void update(double dt) {
    elapsed += dt;
    if (isComplete) {
      onComplete();
    }
  }

  void render(Canvas canvas) {
    final progress = (elapsed / duration).clamp(0.0, 1.0);

    final currentX = startX + (targetX - startX) * progress;
    final currentY = startY + (targetY - startY) * progress;

    _drawHand(canvas, currentX, currentY, progress);
  }

  void _drawHand(Canvas canvas, double x, double y, double progress) {
    canvas.drawCircle(
      Offset(x, y),
      14,
      Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    canvas.drawCircle(
      Offset(x, y),
      13,
      Paint()
        ..color = const Color(0xFFD4A574)
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE8C9A0),
            const Color(0xFFD4A574),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 13)),
    );

    final fingerOffsets = [
      Offset(x - 9, y - 11),
      Offset(x - 3, y - 13),
      Offset(x + 3, y - 13),
      Offset(x + 9, y - 11),
    ];

    for (final offset in fingerOffsets) {
      canvas.drawCircle(
        offset,
        5,
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );

      canvas.drawCircle(
        offset,
        4.5,
        Paint()
          ..color = const Color(0xFFD4A574)
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFE8C9A0),
              const Color(0xFFD4A574),
            ],
          ).createShader(Rect.fromCircle(center: offset, radius: 4.5)),
      );
    }

    canvas.drawCircle(
      Offset(x - 4, y - 4),
      4,
      Paint()..color = Colors.white.withOpacity(0.4),
    );
  }
}
