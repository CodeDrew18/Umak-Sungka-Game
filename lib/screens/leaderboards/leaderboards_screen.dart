import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/components/pebble_bounce.dart';
import 'package:sungka/screens/home_screen.dart';

class Player {
  final int id;
  final String name;
  final int score;
  final int rank;

  Player({
    required this.id,
    required this.name,
    required this.score,
    required this.rank,
  });
}

class FilipinoPalette {
  static const Color darkBg = Color(0xFF1a1410);
  static const Color warmGold = Color(0xFFD4AF37);
  static const Color deepRed = Color(0xFFB22234);
  static const Color coconutBrown = Color(0xFF8B6F47);
  static const Color earthTone = Color(0xFF6B5B4D);
  static const Color creamAccent = Color(0xFFF5E6D3);
  static const Color accentCyan = Color(0xFF00CED1);
  static const Color goldGlow = Color(0xFFFFD700);
}

const Color goldCoinColor = Color(0xFFFFD700);
const double _kBottomBarHeight = 110.0;

class LeaderboardScreen extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;
  final musicLevel;

  LeaderboardScreen({
    required this.navigateToScreen,
    required this.showError,
    required this.bgmPlayer,
    required this.musicLevel
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> parts = name.split(' ');
    if (parts.length == 1) return name[0].toUpperCase();

    return (parts[0][0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
  }

  int _getPlayerActualRank(String currentUserName, List<Map<String, dynamic>> topPlayers) {

    for (int i = 0; i < topPlayers.length; i++) {

      if (topPlayers[i]['name'] == currentUserName) {
        return i + 1;
      }
    }
    return 0;
  }

  Widget _buildTop3Showcase({
    required List<Map<String, dynamic>> topPlayers,
  }) {
    // Ensure we only process the first 3 players
    final rank1 = topPlayers.length > 0 ? topPlayers[0] : null;
    final rank2 = topPlayers.length > 1 ? topPlayers[1] : null;
    final rank3 = topPlayers.length > 2 ? topPlayers[2] : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (rank2 != null)
              _buildTopPlayerPillar(
                player: rank2,
                rank: 2,
                heightFactor: 0.8,
                color: const Color(0xFFC0C0C0),
              ),

            const Gap(20),

            if (rank1 != null)
              _buildTopPlayerPillar(
                player: rank1,
                rank: 1,
                heightFactor: 1.0,
                color: FilipinoPalette.goldGlow,
              ),

            const Gap(20),

            if (rank3 != null)
              _buildTopPlayerPillar(
                player: rank3,
                rank: 3,
                heightFactor: 0.6,
                color: const Color(0xFFCD7F32),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopPlayerPillar({
    required Map<String, dynamic> player,
    required int rank,
    required double heightFactor,
    required Color color,
  }) {
    final String playerName = player['name'] ?? 'Unknown';
    final int score = player['rating'] ?? 0;
    final double baseHeight = 120.0;
    final double pillarHeight = baseHeight * heightFactor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Avatar and Score/Name
        Column(
          children: [
            // Rank Icon/Number
            Icon(
              rank == 1 ? Icons.star : rank == 2 ? Icons.looks_two : Icons.looks_3,
              color: color,
              size: rank == 1 ? 40 : 32,
            ),

            const Gap(4),

            // Avatar with Border
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: rank == 1 ? 3.0 : 2.0),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: FilipinoPalette.darkBg.withOpacity(0.8),
                child: Text(
                  getInitials(playerName),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: FilipinoPalette.creamAccent,
                  ),
                ),
              ),
            ),

            const Gap(8),

            // Score
            Text(
              '$score',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),

            // Name
            SizedBox(
              width: 80,
              child: Text(
                playerName.split(' ')[0], // Use just the first name for space
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),

            const Gap(10),
          ],
        ),

        // The Pillar Block
        Container(
          width: 60,
          height: pillarHeight,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          // Add the rank number inside the pillar base
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: firestoreService.getRankings(currentUser!.uid),
        builder: (context, snapshot) {
          // --- Data extraction ---
          final data = snapshot.data;
          final top100Players = data?['top100Players'] as List? ?? [];
          
          // Original rank from server, potentially inconsistent
          // final playerRank = data?['playerRank'] ?? 0; 
          
          final playerName = data?['playerName'] ?? 'You';
          final playerRating = data?['playerRating'] ?? 0;

          // **FIX IMPLEMENTED HERE**: Calculate the rank directly from the list.
          final playerRank = _getPlayerActualRank(playerName, top100Players.cast<Map<String, dynamic>>());


          final top3Players = top100Players.take(3).toList().cast<Map<String, dynamic>>();
          final remainingPlayers = top100Players.skip(3).toList().cast<Map<String, dynamic>>();

          const String bgImagePath = 'assets/images/assets/bg.png';
          const String titleImagePath = 'assets/images/assets/leaderboard_test.png';

          return Stack(
            children: [
              // 1. Background Image (fills the entire screen)
              Positioned.fill(
                child: Image.asset(
                  bgImagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                // Use safe area only here to push content below notch
                child: SafeArea(
                  bottom: false,
                  child: snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator(color: goldCoinColor, strokeWidth: 3))
                  : Column(
                      children: [
                        Gap(60),

                        // --- FIXED: Title Image ---
                        Image.asset(
                          titleImagePath,
                          fit: BoxFit.contain,
                        ),


                        // --- FIXED: Top 3 Showcase ---
                        _buildTop3Showcase(topPlayers: top3Players),


                        // --- SCROLLABLE: Remaining Player List (Ranks 4 onwards) ---
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FilipinoPalette.darkBg.withOpacity(0.7),
                                border: Border.all(color: FilipinoPalette.warmGold.withOpacity(0.2), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // List Title for ranks 4+
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Overall Rankings',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: FilipinoPalette.warmGold,
                                      ),
                                    ),
                                  ),
                                  // The Scrollable List (must be wrapped in Expanded)
                                  Expanded(
                                    child: ListView.builder(
                                      // Removed shrinkWrap and NeverScrollableScrollPhysics
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      itemCount: remainingPlayers.length,
                                      itemBuilder: (context, index) {
                                        final player = remainingPlayers[index];
                                        // Rank calculation remains correct for the sublist
                                        final rank = index + 4;
                                        return _buildListRow(player: player, rank: rank);
                                      },
                                    ),
                                  ),
                                  // Add padding at the bottom of the scrollable list
                                  // so the last item isn't covered by the fixed bottom bar.
                                  SizedBox(height: _kBottomBarHeight / 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ),

              // 3. Back Button (remains fixed on top)
              Positioned(
                top: 16,
                left: 16,
                child: SafeArea( // Use SafeArea here too to respect notch
                  top: true,
                  bottom: false,
                  child: GestureDetector(
                    onTap: () async {
                      final overlay = OverlayEntry(builder: (_) => const PebbleBounce());
                      Overlay.of(context).insert(overlay);
                      await Future.delayed(const Duration(milliseconds: 300));
                      overlay.remove();
                      widget.navigateToScreen(GameWidget(game: HomeGame(bgmPlayer: widget.bgmPlayer, navigateToScreen: widget.navigateToScreen, showError: widget.showError, musicLevel: widget.musicLevel)));
                    },
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: _buildCurrentPlayerBar(
                    // Now using the consistently calculated rank
                    rank: playerRank,
                    playerName: playerName,
                    rating: playerRating,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // **_buildListRow (Ranks 4+)**

  Widget _buildListRow({
    required Map<String, dynamic> player,
    required int rank,
  }) {
    final int score = player['rating'] ?? 0;
    final String playerName = player['name'] ?? 'Unknown';

    final Color rankBgColor = Colors.transparent;
    final Color rankTextColor = FilipinoPalette.creamAccent.withOpacity(0.8);
    final Color avatarBgColor = FilipinoPalette.earthTone.withOpacity(0.9);

    final bool isCurrentUser = currentUser != null && playerName == (currentUser!.displayName ?? 'Unknown');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          color: isCurrentUser ? FilipinoPalette.accentCyan.withOpacity(0.1) : rankBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Row(
        children: [
          const Gap(16),
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              '$rank',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: rankTextColor,
              ),
            ),
          ),
          const Gap(10),

          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBgColor,
            child: Text(
              getInitials(playerName),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FilipinoPalette.creamAccent,
              ),
            ),
          ),
          const Gap(16),

          // Name
          Expanded(
            child: Text(
              playerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          // Score
          Row(
            children: [
              Icon(Icons.military_tech, color: FilipinoPalette.warmGold, size: 18),
              const Gap(4),
              Text(
                '$score',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FilipinoPalette.warmGold,
                ),
              ),
            ],
          ),
          const Gap(16),
        ],
      ),
    );
  }

  // **_buildCurrentPlayerBar (Fixed Bottom Bar)**

  Widget _buildCurrentPlayerBar({
    required int rank,
    required String playerName,
    required int rating,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F3A93).withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1F3A93).withOpacity(0.3),
          width: 1.4,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF3A5FBF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                rank == 0 ? '—' : '$rank',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // CENTER: Player name + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rank == 0 ? 'Unranked' : 'Your Current Global Rank',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // RIGHT: Rating Box (Gold from title)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7C844),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$rating Pts',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

}