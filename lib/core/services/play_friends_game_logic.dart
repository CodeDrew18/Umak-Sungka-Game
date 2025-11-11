class PlayFriendsGameLogic {

  static Map<String, dynamic> makeMove(List<int> currentBoard, int pit, bool isPlayerOneTurn) {
    final board = List<int>.from(currentBoard);
    var stones = board[pit];
    board[pit] = 0;
    var index = pit;
    bool hasExtraTurn = false;
    bool isCapture = false;

    final currentPlayerStore = isPlayerOneTurn ? 7 : 15;

    final opponentStore = isPlayerOneTurn ? 15 : 7;

    while (stones > 0) {
      index = (index + 1) % board.length;

      if (index == opponentStore) continue;
      
      board[index]++;
      stones--;
    }

    if (index == currentPlayerStore) {
      hasExtraTurn = true;
    }

    final isPlayerOnePit = index >= 0 && index <= 6;
    final isPlayerTwoPit = index >= 8 && index <= 14;

    if (board[index] == 1) {
      if (isPlayerOneTurn && isPlayerOnePit) {
        // Player 1 Capture
        final oppositePit = 14 - index;
        final capturedStones = board[oppositePit];
        
        if (capturedStones > 0) {
          board[currentPlayerStore] += capturedStones + 1;
          board[index] = 0;
          board[oppositePit] = 0;
          isCapture = true;
        }
      } else if (!isPlayerOneTurn && isPlayerTwoPit) {
        // Player 2 Capture
        final oppositePit = 14 - index;
        final capturedStones = board[oppositePit];
        
        if (capturedStones > 0) {
          board[currentPlayerStore] += capturedStones + 1;
          board[index] = 0;
          board[oppositePit] = 0;
          isCapture = true;
        }
      }
    }
    
    return {
      'board': board,
      'hasExtraTurn': hasExtraTurn,
      'isCapture': isCapture,
    };
  }

  // ----------------------------------------------------------------------

  static Map<String, dynamic> checkEndGame(List<int> board) {
    final newBoard = List<int>.from(board);
    var player1Empty = true;
    var player2Empty = true;

    // Check Player 1's side (pits 0-6)
    for (var i = 0; i <= 6; i++) {
      if (newBoard[i] != 0) {
        player1Empty = false;
        break;
      }
    }
    // Check Player 2's side (pits 8-14)
    for (var i = 8; i <= 14; i++) {
      if (newBoard[i] != 0) {
        player2Empty = false;
        break;
      }
    }

    // End Game Condition: One player's side is empty
    if (player1Empty || player2Empty) {
      var player1Remaining = 0;
      var player2Remaining = 0;
      
      // Sweep remaining stones into stores (Huwad rule)
      for (var i = 0; i <= 6; i++) player1Remaining += newBoard[i];
      for (var i = 8; i <= 14; i++) player2Remaining += newBoard[i];
      
      newBoard[7] += player1Remaining;
      newBoard[15] += player2Remaining;
      
      // Empty all pits
      for (var i = 0; i <= 6; i++) newBoard[i] = 0;
      for (var i = 8; i <= 14; i++) newBoard[i] = 0;
      
      return {'isEnded': true, 'finalBoard': newBoard};
    }

    return {'isEnded': false, 'finalBoard': newBoard};
  }

  // ----------------------------------------------------------------------

  static String getWinner(List<int> board) {
    final player1Score = board[7]; // Player 1 Store
    final player2Score = board[15]; // Player 2 Store
    
    if (player1Score > player2Score) return 'player1';
    if (player2Score > player1Score) return 'player2';
    return 'tie';
  }
}