class GameLogicService {
  List<int> makeMove(List<int> currentBoard, int pit, bool isPlayerTurn) {
    List<int> board = List.from(currentBoard);
    int stones = board[pit];
    board[pit] = 0;
    int index = pit;

    while (stones > 0) {
      index = (index + 1) % board.length;

      if (isPlayerTurn && index == 15) {
        continue;
      }

      if (!isPlayerTurn && index == 7) {
        continue;
      }

      board[index]++;
      stones--;
    }

    if (isPlayerTurn && index >= 0 && index <= 6 && board[index] == 1) {
      int opposite = 14 - index;
      board[7] += board[opposite] + 1;
      board[index] = 0;
      board[opposite] = 0;
    } else if (!isPlayerTurn &&
        index >= 8 &&
        index <= 14 &&
        board[index] == 1) {
      int opposite = 14 - index;
      board[15] += board[opposite] + 1;
      board[index] = 0;
      board[opposite] = 0;
    }

    return board;
  }

  bool checkEndGame(List<int> board) {
    bool playerEmpty = true;
    bool botEmpty = true;

    for (int i = 0; i <= 6; i++) {
      if (board[i] != 0) {
        playerEmpty = false;
        break;
      }
    }

    for (int i = 8; i <= 14; i++) {
      if (board[i] != 0) {
        botEmpty = false;
        break;
      }
    }

    if (playerEmpty || botEmpty) {
      int playerRemaining = 0;
      int botRemaining = 0;

      for (int i = 0; i <= 6; i++) {
        playerRemaining += board[i];
      }

      for (int i = 8; i <= 14; i++) {
        botRemaining += board[i];
      }

      board[7] += playerRemaining;
      board[15] += botRemaining;

      for (int i = 0; i <= 6; i++) {
        board[i] = 0;
      }

      for (int i = 8; i <= 14; i++) {
        board[i] = 0;
      }

      return true;
    }

    return false;
  }
}
