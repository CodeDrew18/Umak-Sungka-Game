import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/play_with_friends/on_match/sungka_game.dart';

class OnMatchScreen extends StatelessWidget {
  const OnMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: SungkaGame(),
      ),
    );
  }
}
