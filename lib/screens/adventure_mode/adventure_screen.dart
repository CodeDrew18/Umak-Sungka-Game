import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/start_game_screen.dart';

class SungkaAdventureScreen extends StatefulWidget {
  const SungkaAdventureScreen({super.key});

  @override
  State<SungkaAdventureScreen> createState() => _SungkaAdventureScreenState();
}

class _SungkaAdventureScreenState extends State<SungkaAdventureScreen> {
  late PageController _pageController;
  int _currentLevel = 0;

  final List<Map<String, dynamic>> levels = [
    {
      "number": 1,
      "name": "Beginner’s Match",
      "desc": "Learn the rhythm of the board and flow of shells.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
      ],
      "unlocked": true,
    },
    {
      "number": 2,
      "name": "Strategic Moves",
      "desc": "Think ahead and trap your opponent’s side.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
      ],
      "unlocked": true,
    },
    {
      "number": 3,
      "name": "Swift Hands",
      "desc": "Speed and timing decide victory.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
      ],
      "unlocked": false,
    },
    {
      "number": 4,
      "name": "Master of the Board",
      "desc": "The final challenge. Outsmart and dominate.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
      ],
      "unlocked": false,
    },
    {
      "number": 5,
      "name": "Tactician’s Edge",
      "desc": "Combine strategy and intuition to control the flow.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
        "• Capture Rule: If the last seed lands in one of your empty pits and your opponent’s pit directly across holds seeds, you capture those seeds. Move both the captured seeds and your last seed into your store.",
      ],
      "unlocked": false,
    },
    {
      "number": 6,
      "name": "Grandmaster’s Trial",
      "desc": "Only the best can master both tactics and timing.",
      "rules": [
        "• Extra Turn: If the last seed you place lands in your store, you get to take another turn.",
        "• Capture Rule: If the last seed lands in one of your empty pits and your opponent’s pit directly across holds seeds, you capture those seeds. Move both the captured seeds and your last seed into your store.",
      ],
      "unlocked": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  LinearGradient _lockedGradientFallback() => LinearGradient(
        colors: [AppColors.grey800, AppColors.grey700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          _buildFlameBackButton(onTap: () {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>   GameWidget(game: HomeGame(context)),
                              ),
                            );
                          }),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Adventure Mode",
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Progress through unique Sungka challenges",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    SizedBox(
                      height: height * 0.52,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: levels.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() => _currentLevel = index);
                        },
                        itemBuilder: (context, index) {
                          final level = levels[index];
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double value = 1.0;
                              if (_pageController.position.haveDimensions) {
                                value = _pageController.page! - index;
                                value =
                                    (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                              }
                              return Center(
                                child: Transform.scale(
                                  scale: value,
                                  child: _buildLevelCard(
                                    level,
                                    lockedGradient: _lockedGradientFallback(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _buildPlayButton(),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlameBackButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: AppColors.gradient1,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLevelCard(Map<String, dynamic> level,
      {required LinearGradient lockedGradient}) {
    final bool unlocked = level["unlocked"];
    final gradient = unlocked ? AppColors.gradient2 : lockedGradient;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: const EdgeInsets.all(18),
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LEVEL ${level["number"]}",
            style: GoogleFonts.poppins(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level["name"],
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level["desc"],
            style: GoogleFonts.poppins(
              color: AppColors.white.withOpacity(0.95),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.white.withOpacity(0.25)),
          Text(
            "RULES",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.white.withOpacity(0.95),
              letterSpacing: 1.1,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  (level["rules"] as List).length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      level["rules"][i],
                      style: GoogleFonts.poppins(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    final current = levels[_currentLevel];
    final unlocked = current["unlocked"];
    final gradient = unlocked ? AppColors.gradient2 : _lockedGradientFallback();

    return GestureDetector(
      onTap: unlocked ? () {} : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            unlocked ? "START MATCH" : "LOCKED",
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
