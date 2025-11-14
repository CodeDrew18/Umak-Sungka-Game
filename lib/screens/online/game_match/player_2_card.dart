import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Player2Card extends StatefulWidget {
  final String name;

  const Player2Card({
    super.key,
    required this.name,
  });

  @override
  State<Player2Card> createState() => _Player2CardState();
}

class _Player2CardState extends State<Player2Card> {
  
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.amber.withOpacity(0.2),
          child: Icon(
            Icons.person,
            color: Colors.amber,
            size: 70,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.name,
          style: GoogleFonts.poppins(
            color: Colors.amber,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
