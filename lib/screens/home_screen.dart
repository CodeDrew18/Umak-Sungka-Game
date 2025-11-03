import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // para sa easy access features
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    child: Icon(Icons.settings),
                    backgroundColor: AppColors.primary,
                  ),
                ),
                Gap(15),
                Container(
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
          Gap(25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(50),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: AppColors.gradient1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.language_outlined, size: 50),
                      Text(
                        "Player vs Player",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Divider(
                          height: 5,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "Challenge random",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "player online",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(15),

                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: AppColors.gradient3,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.terrain_rounded, size: 50),
                      Text(
                        "Adventure Mode",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Divider(
                          height: 5,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "Think, play, and",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "outsmart your rivals.",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(15),

                GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AvatarSelectionScreen(),
                        ),
                      ),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: AppColors.gradient2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 50),
                        Text(
                          "Player with friends",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Divider(
                            height: 5,
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "Play with your friends",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "locally",
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(15),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: AppColors.gradient3,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.smart_toy, size: 50),
                      Text(
                        "Player vs Bot",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Divider(
                          height: 5,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "Test Your Skills",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Offline",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}