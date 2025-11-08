import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';

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

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  String getTopPlayerSubtitle(int rank) {
    switch (rank) {
      case 1:
        return "Sungka Master";
      case 2:
        return "Sungka Champion";
      case 3:
        return "Sungka Hero";
      default:
        return "";
    }
  }

  Color getTopPlayerColor(int rank) {
    switch (rank) {
      case 1:
        return FilipinoPalette.warmGold;
      case 2:
        return FilipinoPalette.coconutBrown;
      case 3:
        return FilipinoPalette.deepRed;
      default:
        return FilipinoPalette.earthTone;
    }
  }

  Color getAvatarColor(int id) {
    final colors = [
      FilipinoPalette.warmGold,
      FilipinoPalette.deepRed,
      FilipinoPalette.accentCyan,
      FilipinoPalette.coconutBrown,
      FilipinoPalette.creamAccent,
    ];
    return colors[id % colors.length];
  }

  String getInitials(String name) {
    return name.split(' ').map((n) => n[0]).join();
  }

  Icon? getRankIcon(int rank) {
    if (rank == 1) return const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 24);
    if (rank == 2) return const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 24);
    if (rank == 3) return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 24);
    return null;
  }

  Icon getRankChange(int current, int previous) {
    int change = previous - current;
    if (change > 0) return const Icon(Icons.trending_up, color: Color(0xFF4CAF50), size: 16);
    if (change < 0) return const Icon(Icons.trending_down, color: Color(0xFFE53935), size: 16);
    return const Icon(Icons.remove, color: Color(0xFF9E9E9E), size: 16);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: FilipinoPalette.darkBg,
    appBar: AppBar(
      backgroundColor: FilipinoPalette.darkBg,
    ),
    body: FutureBuilder(
      future: firestoreService.getRankings(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: FilipinoPalette.warmGold,
              strokeWidth: 3,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              'No leaderboard data available',
              style: TextStyle(
                color: FilipinoPalette.creamAccent.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final top100Players = data['top100Players'] as List;
        final playerRank = data['playerRank'];
        final playerName = data['playerName'];
        final playerRating = data['playerRating'];

        final top3 = top100Players.take(3).toList();
        final rest = top100Players.skip(3).toList();

        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "LEADERBOARDS",
                        style: GoogleFonts.poppins(
                          color: FilipinoPalette.warmGold,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                              color: const Color(0xFFE67E22).withOpacity(0.6),
                            ),
                            Shadow(
                              offset: const Offset(0, 8),
                              blurRadius: 20,
                              color: const Color(0xFFE67E22).withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (top3.length > 1)
                            _TopPlayerCard(
                              rank: 2,
                              playerName: top3[1]['name'] ?? 'Unknown',
                              subtitle: getTopPlayerSubtitle(2),
                              rating: top3[1]['rating'],
                              color: getTopPlayerColor(2),
                              size: 80,
                            ),
                          if (top3.isNotEmpty)
                            _TopPlayerCard(
                              rank: 1,
                              playerName: top3[0]['name'] ?? 'Unknown',
                              subtitle: getTopPlayerSubtitle(1),
                              rating: top3[0]['rating'],
                              color: getTopPlayerColor(1),
                              size: 100,
                              isTopOne: true,
                            ),
                          if (top3.length > 2)
                            _TopPlayerCard(
                              rank: 3,
                              playerName: top3[2]['name'] ?? 'Unknown',
                              subtitle: getTopPlayerSubtitle(3),
                              rating: top3[2]['rating'],
                              color: getTopPlayerColor(3),
                              size: 75,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ALL RANKINGS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: FilipinoPalette.warmGold.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rest.length,
                    itemBuilder: (context, index) {
                      final player = rest[index];
                      final rank = index + 4;
                      final isCurrent = player['id'] == currentUser!.uid;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildLeaderboardRow(
                          rank: rank,
                          playerName: player['name'] ?? 'Unknown',
                          rating: player['rating'],
                          isCurrentPlayer: isCurrent,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FilipinoPalette.darkBg.withOpacity(0),
                      FilipinoPalette.darkBg.withOpacity(0.98),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: _buildCurrentPlayerBar(
                  rank: playerRank,
                  playerName: playerName ?? 'You',
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


  Widget _buildLeaderboardRow({
    required int rank,
    required String playerName,
    required int rating,
    required bool isCurrentPlayer,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrentPlayer
              ? [
                  FilipinoPalette.warmGold.withOpacity(0.12),
                  FilipinoPalette.deepRed.withOpacity(0.08),
                ]
              : [
                  FilipinoPalette.coconutBrown.withOpacity(0.08),
                  FilipinoPalette.earthTone.withOpacity(0.04),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlayer
              ? FilipinoPalette.warmGold.withOpacity(0.4)
              : FilipinoPalette.coconutBrown.withOpacity(0.2),
          width: isCurrentPlayer ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrentPlayer
                ? FilipinoPalette.warmGold.withOpacity(0.15)
                : Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FilipinoPalette.coconutBrown,
                  FilipinoPalette.earthTone,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: FilipinoPalette.coconutBrown.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: FilipinoPalette.creamAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 20,
            backgroundColor: getAvatarColor(rank),
            child: Text(
              getInitials(playerName),
              style: const TextStyle(
                color: FilipinoPalette.darkBg,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playerName,
                  style: TextStyle(
                    color: FilipinoPalette.creamAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Competitive Rank',
                  style: TextStyle(
                    color: FilipinoPalette.creamAccent.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FilipinoPalette.warmGold.withOpacity(0.9),
                  FilipinoPalette.goldGlow.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: FilipinoPalette.warmGold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              '$rating',
              style: const TextStyle(
                color: FilipinoPalette.darkBg,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlayerBar({
    required int rank,
    required String playerName,
    required int rating,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FilipinoPalette.warmGold.withOpacity(0.15),
            FilipinoPalette.deepRed.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: FilipinoPalette.warmGold.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: FilipinoPalette.warmGold.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FilipinoPalette.warmGold,
                  FilipinoPalette.goldGlow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: FilipinoPalette.darkBg,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: FilipinoPalette.creamAccent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your Current Rank',
                  style: TextStyle(
                    fontSize: 11,
                    color: FilipinoPalette.creamAccent.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: FilipinoPalette.deepRed,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: FilipinoPalette.deepRed.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              '$rating pts',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: FilipinoPalette.creamAccent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPlayerCard extends StatelessWidget {
  final int rank;
  final String playerName;
  final String subtitle;
  final int rating;
  final Color color;
  final double size;
  final bool isTopOne;

  const _TopPlayerCard({
    required this.rank,
    required this.playerName,
    required this.subtitle,
    required this.rating,
    required this.color,
    required this.size,
    this.isTopOne = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isTopOne)
              Container(
                width: size + 24,
                height: size + 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 12,
                    ),
                  ],
                ),
              ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  playerName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: size / 2.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          playerName,
          style: const TextStyle(
            color: FilipinoPalette.creamAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: FilipinoPalette.creamAccent.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$rating pts',
          style: const TextStyle(
            color: FilipinoPalette.warmGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
