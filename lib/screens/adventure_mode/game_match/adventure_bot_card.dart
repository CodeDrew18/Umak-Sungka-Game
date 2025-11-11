import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdventureBotCard extends StatelessWidget {
  final String name;

  const AdventureBotCard({
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
          backgroundColor: Colors.red.withOpacity(0.2),
          child: Icon(
            Icons.terrain,
            color: Colors.red,
            size: 70,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
