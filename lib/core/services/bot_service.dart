import 'dart:math';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

class BotService {
  static int getBotMove(List<int> board, Difficulty difficulty) {
    final validPits = _getValidPits(board);
    if (validPits.isEmpty) return -1;

    switch (difficulty) {
      case Difficulty.easy:
        return _getRandomPit(validPits);
      case Difficulty.medium:
        final pickBest = Random().nextDouble() > 0.5;
        return pickBest ? _getBestPit(board, validPits) : _getRandomPit(validPits);
      case Difficulty.hard:
        return _getBestPit(board, validPits);
    }
  }

  static List<int> _getValidPits(List<int> board) {
    final pits = <int>[];
    for (var i = 8; i <= 14; i++) {
      if (board[i] > 0) pits.add(i);
    }
    return pits;
  }

  static int _getRandomPit(List<int> validPits) {
    final r = Random();
    return validPits[r.nextInt(validPits.length)];
  }

  static int _getBestPit(List<int> board, List<int> validPits) {
    var bestPit = validPits.first;
    var bestScore = -999999;

    for (final pit in validPits) {
      final score = _simulateMoveAndScore(board, pit);
      if (score > bestScore) {
        bestScore = score;
        bestPit = pit;
      }
    }
    return bestPit;
  }

  static int _simulateMoveAndScore(List<int> board, int pit) {
    final tempBoard = List<int>.from(board);
    var stones = tempBoard[pit];
    tempBoard[pit] = 0;
    var index = pit;

    while (stones > 0) {
      index = (index + 1) % tempBoard.length;
      if (index == 7) continue;
      tempBoard[index]++;
      stones--;
    }

    var score = 0;
    if (index == 15) score += 5;

    if (index >= 8 && index <= 14 && tempBoard[index] == 1) {
      final opposite = 14 - index;
      score += tempBoard[opposite];
    }

    score += (_countBotSideStones(tempBoard) ~/ 2);
    return score;
  }

  static int _countBotSideStones(List<int> tempBoard) {
    var total = 0;
    for (var i = 8; i <= 14; i++) total += tempBoard[i];
    return total;
  }
}
