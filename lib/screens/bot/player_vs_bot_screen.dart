import 'package:flutter/material.dart';
import 'package:sungka/screens/bot/player_vs_bot_game_screen.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

class PlayerVsBotScreen extends StatefulWidget {
  const PlayerVsBotScreen({super.key});

  @override
  State<PlayerVsBotScreen> createState() => _PlayerVsBotScreenState();
}

class _PlayerVsBotScreenState extends State<PlayerVsBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => PlayerVsBotGameScreen(gameMode: Difficulty.easy),
                  ),
                ),
            child: Text("Easy"),
          ),
          ElevatedButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            PlayerVsBotGameScreen(gameMode: Difficulty.medium),
                  ),
                ),
            child: Text("Medium"),
          ),
          ElevatedButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => PlayerVsBotGameScreen(gameMode: Difficulty.hard),
                  ),
                ),
            child: Text("Hard"),
          ),
        ],
      ),
    );
  }
}
