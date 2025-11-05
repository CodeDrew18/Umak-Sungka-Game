// import 'dart:math';

// class BotService {
//   final Random random = Random();

//   int getBotMove(List<int> board, String difficulty) {
//     final validPits = getValidPits(board);

//     if (validPits.isEmpty) {
//       return -1;
//     }

//     switch (difficulty) {
//       case "easy":
//         return getRandomPit(validPits);
//       case "medium":
//         final pickBestMove = random.nextBool();

//         return pickBestMove
//             ? getBestPit(board, validPits)
//             : getRandomPit(validPits);
//       case "hard":
//         return getBestPit(board, validPits);
//     }

//     return -1;
//   }

//   List<int> getValidPits(List<int> board) {
//     List<int> pits = [];

//     for (int i = 8; i <= 14; i++) {
//       if (board[i] > 0) {
//         pits.add(i);
//       }
//     }

//     return pits;
//   }

//   int getRandomPit(List<int> validPits) {
//     return validPits[random.nextInt(validPits.length)];
//   }

//   int getBestPit(List<int> board, List<int> validPits) {
//     int bestPit = validPits[0];
//     int bestScore = 0;

//     for (var pit in validPits) {
//       int score = simulateMoveAndScore(board, pit);

//       if (score > bestScore) {
//         bestScore = score;
//         bestPit = pit;
//       }
//     }

//     return bestPit;
//   }

//   int simulateMoveAndScore(List<int> board, int pit) {
//     final List<int> tempBoard = List.from(board);
//     int stones = tempBoard[pit];
//     tempBoard[pit] = 0;

//     int index = pit;

//     while (stones > 0) {
//       index = (index + 1) % tempBoard.length;

//       if (index == 7) {
//         continue;
//       }

//       tempBoard[index]++;
//       stones--;
//     }

//     int score = 0;

//     if (index == 15) {
//       score += 5;
//     }

//     if (index >= 8 && index <= 14 && tempBoard[index] == 1) {
//       int opposite = 14 - index;

//       score += tempBoard[opposite];
//     }

//     score += (countBotSideStones(tempBoard) / 2).floor();

//     return score;
//   }

//   int countBotSideStones(List<int> tempBoard) {
//     int total = 0;

//     for (int i = 8; i <= 14; i++) {
//       total += tempBoard[i];
//     }

//     return total;
//   }
// }



import 'dart:math';
import 'package:sungka/screens/player_vs_bot/on_match/match_game_screen.dart';

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
