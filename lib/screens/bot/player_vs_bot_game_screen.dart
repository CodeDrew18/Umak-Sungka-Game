import 'package:flutter/material.dart';
import 'package:sungka/core/services/bot_service.dart';
import 'package:sungka/core/services/game_logic_service.dart';
import 'package:sungka/screens/widgets/sungka_board.dart';

class PlayerVsBotGameScreen extends StatefulWidget {
  const PlayerVsBotGameScreen({super.key, required this.gameMode});

  final String gameMode;

  @override
  State<PlayerVsBotGameScreen> createState() => _PlayerVsBotGameScreenState();
}

class _PlayerVsBotGameScreenState extends State<PlayerVsBotGameScreen> {
  final BotService bot = BotService();
  final GameLogicService gameLogicService = GameLogicService();

  List<int> board = [4, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 4, 0];

  bool isPlayerTurn = true;
  bool isBotThinking = false;
  bool isGameOver = false;

  void onPlayerMove(int pit) {
    if (!isPlayerTurn || isGameOver || board[pit] == 0) {
      return;
    }

    setState(() {
      board = gameLogicService.makeMove(board, pit, true);
      isPlayerTurn = false;
      isBotThinking = true;
    });

    if (gameLogicService.checkEndGame(board)) {
      endGame();

      return;
    }

    Future.delayed(const Duration(seconds: 1), botTurn);
  }

  void botTurn() {
    final pit = bot.getBotMove(board, widget.gameMode);
    if (pit == -1) {
      return;
    }

    setState(() {
      board = gameLogicService.makeMove(board, pit, false);
      isBotThinking = false;
      isPlayerTurn = true;
    });

    if (gameLogicService.checkEndGame(board)) {
      endGame();
    }
  }

  void showEndGameDialog() {
    String result;
    if (board[7] > board[15]) {
      result = "You Win!";
    } else if (board[15] > board[7]) {
      result = "Bot Wins!";
    } else {
      result = "Draw!";
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Game Over"),
            content: Text(result),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
    );
  }

  void endGame() {
    setState(() {
      isGameOver = true;
    });

    Future.delayed(const Duration(milliseconds: 500), showEndGameDialog);
  }

  void resetGame() {
    setState(() {
      board = [4, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 4, 0];
      isPlayerTurn = true;
      isBotThinking = false;
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            isGameOver
                ? "Game Over!"
                : isPlayerTurn
                ? "Your Turn"
                : "Bot Turn",
          ),
          SungkaBoard(
            board: board,
            isPlayerTurn: isPlayerTurn,
            isGameOver: isGameOver,
            onPitTap: onPlayerMove,
          ),
        ],
      ),
    );
  }
}
