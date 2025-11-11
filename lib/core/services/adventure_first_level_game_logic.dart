class AdventureFirstLevelGameLogic {
  static Map<String, dynamic> makeMove(
      List<int> currentBoard, int pit, bool isPlayerTurn) {
    final board = List<int>.from(currentBoard);
    var stones = board[pit];
    board[pit] = 0;
    var index = pit;
    bool hasExtraTurn = false;

    final currentPlayerStore = isPlayerTurn ? 7 : 15;
    final opponentStore = isPlayerTurn ? 15 : 7;

    while (stones > 0) {
      index = (index + 1) % board.length;
      if (index == opponentStore) continue;
      board[index]++;
      stones--;
    }

    if (index == currentPlayerStore) {
      hasExtraTurn = true;
    }

    return {
      'board': board,
      'hasExtraTurn': hasExtraTurn,
    };
  }

  static Map<String, dynamic> checkEndGame(List<int> board) {
    final newBoard = List<int>.from(board);
    var playerEmpty = true;
    var botEmpty = true;

    for (var i = 0; i <= 6; i++) {
      if (newBoard[i] != 0) {
        playerEmpty = false;
        break;
      }
    }
    for (var i = 8; i <= 14; i++) {
      if (newBoard[i] != 0) {
        botEmpty = false;
        break;
      }
    }

    if (playerEmpty || botEmpty) {
      var playerRemaining = 0;
      var botRemaining = 0;
      for (var i = 0; i <= 6; i++) playerRemaining += newBoard[i];
      for (var i = 8; i <= 14; i++) botRemaining += newBoard[i];

      newBoard[7] += playerRemaining;
      newBoard[15] += botRemaining;

      for (var i = 0; i <= 6; i++) newBoard[i] = 0;
      for (var i = 8; i <= 14; i++) newBoard[i] = 0;

      return {'isEnded': true, 'finalBoard': newBoard};
    }

    return {'isEnded': false, 'finalBoard': newBoard};
  }

  static String getWinner(List<int> board) {
    final playerScore = board[7];
    final botScore = board[15];

    if (playerScore > botScore) return 'player';
    if (botScore > playerScore) return 'bot';
    return 'tie';
  }
}
