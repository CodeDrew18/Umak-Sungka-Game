import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.score,
    required this.name,
    required this.rating,
    this.changeRating = 0,
    this.playerStatus = "",
    this.isCurrentTurn = false,
  });

  final int score;
  final String name;
  final String playerStatus;
  final int changeRating;
  final int rating;
  final bool isCurrentTurn;

  @override
  Widget build(BuildContext context) {
    String text = "$name ($rating)";

    if (changeRating != 0 && changeRating > 0) {
      text = "$name (${rating + changeRating} +$changeRating)";
    } else if (changeRating != 0 && changeRating < 0) {
      text = "$name (${rating + changeRating} $changeRating)";
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text("$score")),
        title: Text(text),
        trailing:
            playerStatus.isNotEmpty ? Text("Status: $playerStatus") : null,
      ),
    );
  }
}
