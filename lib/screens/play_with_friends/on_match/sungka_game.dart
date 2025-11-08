import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class SungkaGame extends FlameGame with TapDetector {
  static const int pitsPerSide = 6;
  static const int initialStones = 4;

  late List<int> player1Pits;
  late List<int> player2Pits;
  int player1Store = 0;
  int player2Store = 0;

  late TextPaint storeText;
  late TextPaint titleText;

  late double pitRadius;
  late double storeWidth;
  late double boardPadding;
  late double pitSpacing;

  late Map<String, Offset> pitPositions;

  static const List<Color> stoneColors = [
    Color(0xFF1E90FF),
    Color(0xFF32CD32),
    Color(0xFFFF8C00),
    Color(0xFFFFD700),
  ];

  bool isPlayer1Turn = true;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
    player1Pits = List.filled(pitsPerSide, initialStones);
    player2Pits = List.filled(pitsPerSide, initialStones);

    pitPositions = {};

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

    pitRadius = 40;
    storeWidth = 100;
    boardPadding = 50;
    pitSpacing = 0;
  }

  @override
void onRemove() {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  super.onRemove();
}

  @override
  void render(Canvas canvas) {
    final screenWidth = size.x;
    final screenHeight = size.y;
    final centerY = screenHeight / 2;
    final boardWidth = screenWidth - (2 * storeWidth) - (2 * boardPadding);
    pitSpacing = boardWidth / (pitsPerSide + 1);

    final bgPaint = Paint()..color = Colors.grey[850]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight), bgPaint);

    titleText.render(canvas, 'SUNGKA MASTER', Vector2(screenWidth / 2 - 100, 20));

    _drawBoard(canvas, screenWidth, screenHeight, centerY);
    _drawPits(canvas, centerY);
    _drawStores(canvas, centerY);

    storeText.render(canvas, '$player1Store', Vector2(storeWidth / 2 - 10, centerY - 20));
    storeText.render(canvas, '$player2Store', Vector2(size.x - storeWidth / 2 - 10, centerY - 20));

    final turnText = isPlayer1Turn ? "Player 1's Turn" : "Player 2's Turn";
    titleText.render(canvas, turnText, Vector2(size.x / 2 - 80, size.y - 50));
  }

  void _drawBoard(Canvas canvas, double screenWidth, double screenHeight, double centerY) {
    final boardLeft = storeWidth + boardPadding;
    final boardRight = screenWidth - storeWidth - boardPadding;
    final boardTop = centerY - 140;
    final boardBottom = centerY + 140;

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
        ..color = Colors.brown.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  void _drawPits(Canvas canvas, double centerY) {
    final boardLeft = storeWidth + boardPadding;

    for (int i = 0; i < pitsPerSide; i++) {
      final x = boardLeft + pitSpacing * (i + 1);
      final y = centerY + 75;
      pitPositions['p1_$i'] = Offset(x, y);
      _drawPit(canvas, x, y, player1Pits[i], true);
    }

    // Player 2 (clockwise)
    for (int i = 0; i < pitsPerSide; i++) {
      final x = boardLeft + pitSpacing * (pitsPerSide - i);
      final y = centerY - 75;
      pitPositions['p2_$i'] = Offset(x, y);
      _drawPit(canvas, x, y, player2Pits[i], false);
    }
  }

  void _drawPit(Canvas canvas, double x, double y, int stoneCount, bool isPlayer1) {
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

    _drawStonesInPit(canvas, x, y, stoneCount);
  }

  void _drawStonesInPit(Canvas canvas, double x, double y, int count) {
    if (count == 0) return;

    final positions = <Offset>[];
    final radius = pitRadius - 10;

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * math.pi;
      positions.add(Offset(radius * 0.65 * math.cos(angle), radius * 0.65 * math.sin(angle)));
    }

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final stoneColor = stoneColors[i % stoneColors.length];

      canvas.drawCircle(
        Offset(x + pos.dx, y + pos.dy),
        6,
        Paint()..color = stoneColor,
      );
    }
  }

  void _drawStores(Canvas canvas, double centerY) {
    _drawStore(canvas, storeWidth / 2, centerY, true);
    _drawStore(canvas, size.x - storeWidth / 2, centerY, false);
  }

  void _drawStore(Canvas canvas, double x, double y, bool isPlayer1) {
    const storeHeight = 160.0;
    const storeHalfWidth = 45.0;
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
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPos = info.eventPosition.global;

    for (int i = 0; i < pitsPerSide; i++) {
      final pitKey = isPlayer1Turn ? 'p1_$i' : 'p2_$i';
      final pitCenter = pitPositions[pitKey]!;

      if ((tapPos.toOffset() - pitCenter).distance <= pitRadius) {
        _makeMove(i);
        break;
      }
    }
  }

void _makeMove(int pitIndex) {
  List<int> currentPits = isPlayer1Turn ? player1Pits : player2Pits;
  List<int> opponentPits = isPlayer1Turn ? player2Pits : player1Pits;
  int stones = currentPits[pitIndex];
  if (stones == 0) return;

  currentPits[pitIndex] = 0;
  int pos = pitIndex;
  bool extraTurn = false;

  while (stones > 0) {
    for (pos = pos + 1; pos < pitsPerSide && stones > 0; pos++) {
      currentPits[pos]++;
      stones--;

      if (stones == 0 && currentPits[pos] == 1 && opponentPits[pitsPerSide - 1 - pos] > 0) {
        int captured = opponentPits[pitsPerSide - 1 - pos];
        opponentPits[pitsPerSide - 1 - pos] = 0;
        if (isPlayer1Turn) {
          player1Store += captured + 1;
        } else {
          player2Store += captured + 1;
        }
        currentPits[pos] = 0;
      }
    }

    if (stones > 0) {
      if (isPlayer1Turn) {
        player1Store++;
      } else {
        player2Store++;
      }
      stones--;
      if (stones == 0) extraTurn = true;
    }

    if (stones > 0) {
      List<int> temp = currentPits;
      currentPits = opponentPits;
      opponentPits = temp;
      pos = -1;
    }
  }

  if (!extraTurn) isPlayer1Turn = !isPlayer1Turn;

  if (player1Pits.every((e) => e == 0) || player2Pits.every((e) => e == 0)) {
    player1Store += player1Pits.reduce((a, b) => a + b);
    player2Store += player2Pits.reduce((a, b) => a + b);
    player1Pits.fillRange(0, pitsPerSide, 0);
    player2Pits.fillRange(0, pitsPerSide, 0);
  }
}


}
