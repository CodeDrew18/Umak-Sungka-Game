import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';

class UsernameScreen extends StatelessWidget {
  UsernameScreen({super.key});

  final key = GlobalKey<FormFieldState>();
  final username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          Stack(
            children: [
              // Big title text
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Sungka Master",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 80,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          
              // 🪵 Board image pinned to bottom
          
            ],
          ),
            Column(
              children: [

                             Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        "assets/board1.png",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        fit: BoxFit.contain,
      ),
    ),
              ],
            )

        ],
      ),
    );
  }
}
