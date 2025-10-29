class GameState {
  late List<int> pits;
  late int currentPlayer;
  late bool gameOver;
  late int winner;

  GameState() {
    initializeGame();
  }

  List<int> get player1Pits => pits.sublist(0, 7);
  List<int> get player2Pits => pits.sublist(8, 15);
  int get player1Store => pits[7];
  int get player2Store => pits[15];
  bool get isPlayer1Turn => currentPlayer == 1;

  void initializeGame() {
    pits = List<int>.filled(16, 0);


    for (int i = 0; i < 7; i++) {
      pits[i] = 7;
    }
    pits[7] = 0;

    for (int i = 8; i < 15; i++) {
      pits[i] = 7;
    }
    pits[15] = 0;

    currentPlayer = 1;
    gameOver = false;
    winner = 0;
  }

  bool distributeStones(int pitIndex) {
    if (!isValidPitSelection(pitIndex)) return false;

    int stones = pits[pitIndex];
    pits[pitIndex] = 0;
    int currentIndex = pitIndex;

    while (stones > 0) {
      currentIndex = getNextPit(currentIndex);
      pits[currentIndex]++;
      stones--;
    }

    if (canCapture(currentIndex)) {
      captureStones(currentIndex);
    }

    if (isGameOver()) {
      endGame();
    } else {
      switchPlayer();
    }

    return true;
  }

  int getNextPit(int currentIndex) {

    return (currentIndex - 1 + 16) % 16;
  }

  int getPlayerStore(int player) => player == 1 ? 7 : 15;

  bool isValidPitSelection(int pitIndex) {
    if (gameOver) return false;

    if (currentPlayer == 1 && (pitIndex < 0 || pitIndex > 6)) return false;
    if (currentPlayer == 2 && (pitIndex < 8 || pitIndex > 14)) return false;

    return pits[pitIndex] > 0;
  }

  bool canCapture(int landingIndex) {
    if (pits[landingIndex] != 1) return false; 

    if (currentPlayer == 1 && landingIndex >= 0 && landingIndex <= 6) {
      int opposite = getOppositePit(landingIndex);
      return pits[opposite] > 0;
    } else if (currentPlayer == 2 && landingIndex >= 8 && landingIndex <= 14) {
      int opposite = getOppositePit(landingIndex);
      return pits[opposite] > 0;
    }

    return false;
  }

  int getOppositePit(int pitIndex) {
    if (pitIndex >= 0 && pitIndex <= 6) return 14 - pitIndex;
    if (pitIndex >= 8 && pitIndex <= 14) return 22 - pitIndex;
    return -1;
  }

  void captureStones(int pitIndex) {
    int opposite = getOppositePit(pitIndex);
    int store = getPlayerStore(currentPlayer);
    pits[store] += pits[pitIndex] + pits[opposite];
    pits[pitIndex] = 0;
    pits[opposite] = 0;
  }

  bool isGameOver() {
    return isPlayerSideEmpty(1) || isPlayerSideEmpty(2);
  }

  bool isPlayerSideEmpty(int player) {
    if (player == 1) return pits.sublist(0, 7).every((s) => s == 0);
    return pits.sublist(8, 15).every((s) => s == 0);
  }

  void endGame() {
    gameOver = true;
    for (int i = 0; i < 7; i++) {
      pits[7] += pits[i];
      pits[i] = 0;
    }
    for (int i = 8; i < 15; i++) {
      pits[15] += pits[i];
      pits[i] = 0;
    }

    int p1Score = pits[7];
    int p2Score = pits[15];

    if (p1Score > p2Score)
      winner = 1;
    else if (p2Score > p1Score)
      winner = 2;
    else
      winner = 0;
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }

  int getTotalStones() => pits.fold(0, (sum, s) => sum + s);

  int getPlayerScore(int player) => pits[player == 1 ? 7 : 15];

  int getPitStones(int pitIndex) => pits[pitIndex];

  void reset() => initializeGame();
}
