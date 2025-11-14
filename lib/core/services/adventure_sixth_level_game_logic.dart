class AdventureSixthLevelGameLogic {
  static int? getForcedMove(List<int> board, bool isPlayerTurn) {
    final start = isPlayerTurn ? 0 : 8;
    final end = isPlayerTurn ? 6 : 14;

    int validPitCount = 0;
    int? lastValidPit;

    // Iterate over the current player's pits
    for (var i = start; i <= end; i++) {
      if (board[i] > 0) {
        // This is a pit with seeds, so it's a potential move
        validPitCount++;
        lastValidPit = i;
      }
    }

    // "Forced Move: If only one pit has seeds, you must play it."
    if (validPitCount == 1) {
      return lastValidPit;
    }

    // Otherwise, (if 0 or 2+ pits have seeds), no move is forced
    return null;
  }

  /// --- UPDATED makeMove ---
  ///
  /// Now includes the "Capture Rule" in addition to the "Extra Turn" rule.
  static Map<String, dynamic> makeMove(
      List<int> currentBoard, int pit, bool isPlayerTurn) {
    final board = List<int>.from(currentBoard);
    var stones = board[pit];
    board[pit] = 0;
    var index = pit;
    bool hasExtraTurn = false;

    final currentPlayerStore = isPlayerTurn ? 7 : 15;
    final opponentStore = isPlayerTurn ? 15 : 7;

    // --- Sowing Phase ---
    while (stones > 0) {
      index = (index + 1) % board.length;
      if (index == opponentStore) continue;
      board[index]++;
      stones--;
    }

    // --- Rule Checks (After Last Seed is Placed) ---

    // 1. Extra Turn Rule: Last seed in store = take another turn.
    if (index == currentPlayerStore) {
      hasExtraTurn = true;
    }

    // 2. Capture Rule: Last seed in your empty pit + opponent's pit across has seeds.
    
    // Determine the range of the current player's regular pits
    final currentPitsStart = isPlayerTurn ? 0 : 8;
    final currentPitsEnd = isPlayerTurn ? 6 : 14;

    // Check if the last seed landed in one of the current player's non-store pits
    // AND that pit was empty (i.e., it now has 1 stone)
    if (index >= currentPitsStart && index <= currentPitsEnd && board[index] == 1) {
      
      // Calculate the index of the opponent's pit across
      final oppositePitIndex = 14 - index;

      // Check if the opponent's pit across has seeds
      if (board[oppositePitIndex] > 0) {
        
        // Capture all stones from both pits
        final capturedStones = board[index] + board[oppositePitIndex];

        // Add captured stones to the current player's store
        board[currentPlayerStore] += capturedStones;

        // Empty the captured pits
        board[index] = 0;
        board[oppositePitIndex] = 0;
      }
    }

    return {
      'board': board,
      'hasExtraTurn': hasExtraTurn,
    };
  }

  // (The checkEndGame and getWinner methods remain unchanged)

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