import 'package:flutter/material.dart';

class SungkaBoard extends StatefulWidget {
  const SungkaBoard({
    super.key,
    required this.board,
    required this.isPlayerTurn,
    required this.isGameOver,
    required this.onPitTap,
  });

  final List<int> board;
  final bool isPlayerTurn;
  final bool isGameOver;
  final Function(int pit) onPitTap;

  @override
  State<SungkaBoard> createState() => _SungkaBoardState();
}

class _SungkaBoardState extends State<SungkaBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            buildStore(widget.board[15], "Bot Store"),
            Row(
              children: List.generate(7, (index) {
                int pitIndex = 14 - index;

                return buildPit(pitIndex, false);
              }),
            ),

            buildStore(widget.board[7], "Player Store"),
          ],
        ),

        Row(
          children: List.generate(7, (index) {
            return buildPit(index, true);
          }),
        ),
      ],
    );
  }

  Widget buildPit(int index, bool isPlayerSide) {
    return GestureDetector(
      onTap:
          widget.isPlayerTurn &&
                  !widget.isGameOver &&
                  isPlayerSide &&
                  widget.board[index] > 0
              ? () => widget.onPitTap(index)
              : null,
      child: Text("${widget.board[index]}"),
    );
  }

  Widget buildStore(int stones, String label) {
    return Column(children: [Text("$stones"), Text(label)]);
  }
}
