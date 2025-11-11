import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerVsOpponentCard extends StatelessWidget {
  final String name;

  const PlayerVsOpponentCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.green.withOpacity(0.2),
          child: Icon(
            Icons.face,
            color: Colors.green,
            size: 70,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
