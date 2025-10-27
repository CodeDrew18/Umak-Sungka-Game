import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/online/online_game_screen.dart';
import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';
import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final firestoreService = FirebaseFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                FirebaseAuthService().logout();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    child: Icon(Icons.settings),
                    backgroundColor: AppColors.primary,
                  ),
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
        ],
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // para sa easy access features
          Gap(15),
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
          Gap(35),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(50),
                GestureDetector(
                  onTap: () => online(context),
                  child: Container(
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

  Future<void> online(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userDoc = await firestoreService.getUser(user: user!);

      if (!userDoc.exists) throw Exception("User not found.");

      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData["name"];
      final userRating = userData['rating'] ?? 800;
      final minRating = userRating - 100;
      final maxRating = userRating + 100;
      final findMatch = await firestoreService.findMatch(
        minRating: minRating,
        maxRating: maxRating,
      );

      if (findMatch.docs.isNotEmpty) {
        final match = findMatch.docs.first;

        await firestoreService.joinMatch(
          matchId: match.id,
          userId: user.uid,
          userName: userName,
          rating: userRating,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OnlineGameScreen(matchId: match.id),
          ),
        );
      } else {
        final newMatch = await firestoreService.newMatch(
          userId: user.uid,
          userName: userName,
          userRating: userRating,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WaitingForOpponentScreen(matchId: newMatch.id),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}
