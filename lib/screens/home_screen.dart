import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // para sa easy access features
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      child: Icon(Icons.settings),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      child: Icon(Icons.games_rounded),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              "Choose Your Battle Mode",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColors.titleColor,
                shadows: [
                  Shadow(
                    color: AppColors.titleColor.withOpacity(0.4),
                    blurRadius: 14,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
            ),

            //All List Features
            SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50),
                  _buildGameModeCard(
                    cardWidth: 220,
                    cardHeight: 220,
                    icon: Icons.language_outlined,
                    title: "Player vs Player",
                    description1: "Challenge random",
                    description2: "player online",
                    gradient: AppColors.gradient1,
                  ),
                  SizedBox(width: 15),
                  _buildGameModeCard(
                    cardWidth: 220,
                    cardHeight: 220,
                    icon: Icons.terrain_rounded,
                    title: "Adventure Mode",
                    description1: "Think, play, and",
                    description2: "outsmart your rivals.",
                    gradient: AppColors.gradient3,
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AvatarSelectionScreen(),
                          ),
                        ),
                    child: _buildGameModeCard(
                      cardWidth: 220,
                      cardHeight: 220,
                      icon: Icons.people,
                      title: "Player with friends",
                      description1: "Play with your friends",
                      description2: "locally",
                      gradient: AppColors.gradient2,
                    ),
                  ),
                  SizedBox(width: 15),
                  _buildGameModeCard(
                    cardWidth: 220,
                    cardHeight: 220,
                    icon: Icons.smart_toy,
                    title: "Player vs Bot",
                    description1: "Test Your Skills",
                    description2: "Offline",
                    gradient: AppColors.gradient3,
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeCard({
    required double cardWidth,
    required double cardHeight,
    required IconData icon,
    required String title,
    required String description1,
    required String description2,
    required Gradient gradient,
  }) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description1,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
          Text(
            description2,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
